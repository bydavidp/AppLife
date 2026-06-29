import 'dart:math';
import '../domain/models/character.dart';
import '../domain/models/career.dart';
import '../domain/models/game_event.dart';
import '../domain/enums/career_type.dart';
import '../domain/enums/asset_type.dart';
import '../data/event_catalog.dart';
import '../data/career_definitions.dart';

class GameEngine {
  final Random _random = Random();
  final Set<String> _usedEvents = {};
  final List<GameEvent> _pendingChainEvents = [];

  Character character;

  GameEngine({required this.character});

  int get age => character.age;

  void advanceYear() {
    if (!character.isAlive) return;

    character.ageOneYear(_random);

    if (!character.isAlive) return;

    _processEconomy();
    _processRelationships();
    _processCareerProgression();
    _applyRandomStatChanges();
  }

  void _processEconomy() {
    final income = character.monthlyIncome * 12;
    final expenses = character.monthlyExpenses * 12;
    final net = income - expenses;

    character.addMoney(net);

    for (final loan in character.loans) {
      if (loan.remaining > 0) {
        loan.remaining -= loan.monthlyPayment;
        if (loan.remaining < 0) loan.remaining = 0;
      }
    }

    for (final asset in character.assets) {
      if (asset.type == AssetType.investment) {
        final change = (asset.value * (_random.nextDouble() - 0.45) * 0.2);
        asset.value += change;
        if (asset.value < 0) asset.value = 0;
      }
      if (asset.type == AssetType.property) {
        final appreciation = asset.value * _random.nextDouble() * 0.05;
        asset.value += appreciation;
      }
    }
  }

  void _processRelationships() {
    for (final r in character.relationships) {
      r.age++;
      if (r.age > 80 && _random.nextDouble() < 0.1) {
        r.isAlive = false;
      }
      if (r.affinity > 50 && _random.nextDouble() < 0.3) {
        r.affinity = (r.affinity + 1).clamp(0, 100);
      }
    }

    if (character.isMarried && character.partnerId != null) {
      final partner = character.relationships
          .where((r) => r.id == character.partnerId)
          .firstOrNull;
      if (partner != null) {
        partner.affinity =
            (partner.affinity + (_random.nextDouble() * 4 - 2).round())
                .clamp(0, 100);
      }
    }
  }

  void _processCareerProgression() {
    if (character.career == null) return;

    final def = CareerDefinitions.forType(character.career!.type);
    if (def == null) return;

    character.career!.experience +=
        def.experiencePerYear * (1 + character.stats.discipline / 200);

    if (character.career!.experience >= 100 * (character.career!.level + 1) &&
        character.career!.level < 3) {
      character.career!.level++;
      character.career!.salary = def.salaries[character.career!.level];
      character.eventHistory.add(
          'Ascendido a ${character.career!.levelName} en ${character.career!.name}');
    }

    if (character.career!.type == CareerType.crime) {
      if (_random.nextDouble() < 0.05) {
        character.modifyStat('reputation', -5);
        if (_random.nextDouble() < 0.3) {
          character.modifyStat('happiness', -10);
          character.addMoney(-5000);
        }
      }
    }
  }

  void _applyRandomStatChanges() {
    if (_random.nextDouble() < 0.3) {
      character.modifyStat('happiness',
          (_random.nextDouble() * 6 - 3).round());
    }
    if (_random.nextDouble() < 0.2) {
      character.modifyStat('stress', (_random.nextDouble() * 4).round());
    }
    if (character.stats.stress > 70 && _random.nextDouble() < 0.3) {
      character.modifyStat('health', -2);
    }
    if (_random.nextDouble() < 0.15) {
      character.modifyStat(
          'intelligence', (_random.nextDouble() * 2).round());
    }
  }

  GameEvent? getNextEvent() {
    if (_pendingChainEvents.isNotEmpty) {
      return _pendingChainEvents.removeAt(0);
    }

    final available = EventCatalog.allEvents.where((e) {
      if (e.oneTime && _usedEvents.contains(e.id)) return false;
      if (character.age < e.minAge || character.age > e.maxAge) return false;

      if (e.careerRequired != null) {
        if (character.career == null) return false;
        if (character.career!.type.name != e.careerRequired) return false;
      }

      if (e.moneyRequired != null &&
          character.money < e.moneyRequired!) return false;

      if (e.statRequirements != null) {
        for (final entry in e.statRequirements!.entries) {
          final statValue = _getStat(entry.key);
          if (statValue < entry.value) return false;
        }
      }

      return true;
    }).toList();

    if (available.isEmpty) return null;

    final event = available[_random.nextInt(available.length)];
    return event;
  }

  int _getStat(String key) {
    switch (key) {
      case 'intelligence':
        return character.stats.intelligence;
      case 'charisma':
        return character.stats.charisma;
      case 'athleticism':
        return character.stats.athleticism;
      case 'appearance':
        return character.stats.appearance;
      case 'reputation':
        return character.stats.reputation;
      case 'health':
        return character.stats.health;
      case 'discipline':
        return character.stats.discipline;
      case 'happiness':
        return character.stats.happiness;
      default:
        return 50;
    }
  }

  void applyChoice(GameEvent event, EventChoice choice) {
    final statKeys = choice.statEffects.keys.toList();
    for (final key in statKeys) {
      character.modifyStat(key, choice.statEffects[key]!);
    }

    character.addMoney(choice.moneyEffect);
    if (choice.reputationEffect != null) {
      character.modifyStat('reputation', choice.reputationEffect!.round());
    }

    if (choice.careerGranted != null) {
      final type = CareerType.values.firstWhere(
        (e) => e.name == choice.careerGranted,
        orElse: () => CareerType.unemployed,
      );
      if (type != CareerType.unemployed) {
        _grantCareer(type);
      }
    }

    if (choice.careerExperience != null && character.career != null) {
      character.career!.experience += choice.careerExperience!;
    }

    if (choice.nextEventId != null) {
      final next = EventCatalog.allEvents
          .where((e) => e.id == choice.nextEventId)
          .firstOrNull;
      if (next != null) {
        _pendingChainEvents.add(next);
      }
    }

    if (event.oneTime) {
      _usedEvents.add(event.id);
    }

    character.eventHistory
        .add('${event.title}: ${choice.text}');

    _checkAchievements(event, choice);
  }

  void _grantCareer(CareerType type) {
    final def = CareerDefinitions.forType(type);
    if (def == null) return;

    character.career = Career(
      type: type,
      name: def.name,
      salary: def.salaries[0],
      level: 0,
      experience: 0,
    );
  }

  void _checkAchievements(GameEvent event, EventChoice choice) {
    if (character.netWorth > 1000000 &&
        !character.achievements.contains('millonario')) {
      character.achievements.add('millonario');
    }
    if (character.netWorth > 100000000 &&
        !character.achievements.contains('multimillonario')) {
      character.achievements.add('multimillonario');
    }
    if (character.stats.allMaxed() &&
        !character.achievements.contains('perfecto')) {
      character.achievements.add('perfecto');
    }
    if (character.career?.level == 3 &&
        !character.achievements.contains('leyenda')) {
      character.achievements.add('leyenda');
    }
    if (character.age > 100 &&
        !character.achievements.contains('centenario')) {
      character.achievements.add('centenario');
    }
  }

  bool get isGameOver => !character.isAlive;

  String getGameOverSummary() {
    final buffer = StringBuffer();
    buffer.writeln('${character.name} falleció a los ${character.age} años.');
    buffer.writeln('Causa: ${character.dieCause}');
    buffer.writeln('Patrimonio final: \$${character.netWorth.toStringAsFixed(0)}');
    if (character.career != null) {
      buffer.writeln(
          'Carrera: ${character.career!.name} (${character.career!.levelName})');
    }
    buffer.writeln('Logros: ${character.achievements.length}');
    buffer.writeln('Eventos vividos: ${character.eventHistory.length}');
    return buffer.toString();
  }
}
