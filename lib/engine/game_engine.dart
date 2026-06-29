import 'dart:math';
import 'package:uuid/uuid.dart';
import '../domain/models/character.dart';
import '../domain/models/stats.dart';
import '../domain/models/career.dart';
import '../domain/models/game_event.dart';
import '../domain/models/asset.dart';
import '../domain/models/relationship.dart';
import '../domain/enums/career_type.dart';
import '../domain/enums/asset_type.dart';
import '../domain/enums/relationship_type.dart';
import '../data/event_catalog.dart';
import '../data/career_definitions.dart';

class GameEngine {
  final Random _random = Random();
  final _uuid = const Uuid();
  final Set<String> _usedEvents = {};
  final List<GameEvent> _pendingChainEvents = [];

  Character character;
  int currentYear;

  GameEngine({required this.character, this.currentYear = 2024});

  int get age => character.age;

  void initializeFamily() {
    final mother = Relationship(
      id: _uuid.v4(),
      name: character.gender == 'Hombre' ? _randomName('Mujer') : _randomName('Mujer'),
      type: RelationshipType.parent,
      affinity: 70 + _random.nextInt(20),
      age: 25 + _random.nextInt(10),
    );
    final father = Relationship(
      id: _uuid.v4(),
      name: character.gender == 'Mujer' ? _randomName('Hombre') : _randomName('Hombre'),
      type: RelationshipType.parent,
      affinity: 65 + _random.nextInt(20),
      age: 28 + _random.nextInt(10),
    );
    character.relationships = [mother, father];
  }

  String _randomName(String gender) {
    final maleNames = ['Carlos', 'Miguel', 'Javier', 'Roberto', 'Alejandro', 'Diego', 'Fernando', 'Andrés', 'Sergio', 'Pablo'];
    final femaleNames = ['María', 'Ana', 'Laura', 'Sofía', 'Carmen', 'Isabel', 'Elena', 'Patricia', 'Rosa', 'Mónica'];
    final surnames = ['García', 'Rodríguez', 'López', 'Martínez', 'Pérez', 'González', 'Sánchez', 'Ramírez', 'Torres', 'Flores'];
    final name = gender == 'Hombre' ? maleNames[_random.nextInt(maleNames.length)] : femaleNames[_random.nextInt(femaleNames.length)];
    final surname = surnames[_random.nextInt(surnames.length)];
    return '$name $surname';
  }

  void advanceYear() {
    if (!character.isAlive) return;

    character.ageOneYear(_random);
    if (!character.isAlive) return;

    _processEducation();
    _processEconomy();
    _processRelationships();
    _processCareerProgression();
    _applyRandomStatChanges();
    _checkDeathByAge();
    currentYear++;
  }

  void _processEducation() {
    if (character.age >= 6 && character.age <= 16 && character.educationLevel == 0) {
      character.educationLevel = 1;
      character.eventHistory.add('Comenzó la escuela primaria');
    }
    if (character.age >= 12 && character.age <= 18 && character.educationLevel == 1) {
      character.educationLevel = 2;
      character.eventHistory.add('Comenzó la secundaria');
    }
  }

  void _processEconomy() {
    final income = character.monthlyIncome * 12;
    double expenses = character.monthlyExpenses * 12;

    double taxes = 0;
    if (income > 0) {
      taxes = income * _getTaxRate(income);
      expenses += taxes;
    }

    character.eventHistory.removeWhere((e) => e.startsWith('Impuestos'));
    if (taxes > 0) {
      character.eventHistory.add('Impuestos pagados: \$${taxes.toStringAsFixed(0)}');
    }

    final net = income - expenses;
    character.addMoney(net);

    for (final loan in character.loans) {
      if (loan.remaining > 0) {
        final interest = loan.remaining * (loan.interestRate / 100 / 12);
        loan.remaining -= loan.monthlyPayment;
        loan.remaining += interest;
        if (loan.remaining < 0) loan.remaining = 0;
      }
    }

    for (final asset in character.assets) {
      if (asset.type == AssetType.investment) {
        final volatility = _random.nextDouble() * 0.3;
        final direction = _random.nextDouble() < 0.55 ? 1 : -1;
        final change = asset.value * volatility * direction;
        asset.value += change;
        if (asset.value < 0) asset.value = 0;
      }
      if (asset.type == AssetType.property) {
        final appreciation = asset.value * _random.nextDouble() * 0.08;
        asset.value += appreciation;
      }
      if (asset.type == AssetType.business) {
        final profit = asset.value * (_random.nextDouble() * 0.15);
        asset.income = profit;
        final maintenance = asset.value * 0.02;
        asset.maintenanceCost = maintenance;
      }
      if (asset.type == AssetType.luxury) {
        asset.value *= (1 - _random.nextDouble() * 0.05);
      }
    }

    if (_random.nextDouble() < 0.08) {
      character.eventHistory.add('Inflación: los precios subieron este año');
    }
  }

  double _getTaxRate(double income) {
    if (income <= 0) return 0;
    if (income < 20000) return 0.05;
    if (income < 50000) return 0.10;
    if (income < 100000) return 0.15;
    if (income < 500000) return 0.25;
    return 0.35;
  }

  void _processRelationships() {
    final toRemove = <Relationship>[];
    for (final r in character.relationships) {
      r.age++;
      if (r.age > 80 && _random.nextDouble() < 0.08) {
        r.isAlive = false;
        character.eventHistory.add('${r.name} falleció');
        toRemove.add(r);
      }
      if (r.isAlive) {
        if (r.affinity > 50) {
          r.affinity = (r.affinity + (_random.nextDouble() * 2).round()).clamp(0, 100);
        } else if (r.affinity < 30 && _random.nextDouble() < 0.1) {
          r.affinity = (r.affinity - 1).clamp(0, 100);
        }
      }
    }

    if (character.isMarried && character.partnerId != null) {
      final partner = character.relationships
          .where((r) => r.id == character.partnerId)
          .firstOrNull;
      if (partner != null) {
        partner.affinity = (partner.affinity + (_random.nextDouble() * 4 - 2).round()).clamp(0, 100);
        if (partner.affinity < 20 && _random.nextDouble() < 0.05) {
          character.isMarried = false;
          character.eventHistory.add('Divorcio de ${partner.name}');
        }
      }
    }
  }

  void _processCareerProgression() {
    if (character.career == null) return;
    if (character.age < 16) return;

    final def = CareerDefinitions.forType(character.career!.type);
    if (def == null) return;

    character.career!.experience += def.experiencePerYear * (1 + character.stats.discipline / 200);

    final neededExp = 100 * (character.career!.level + 1);
    if (character.career!.experience >= neededExp && character.career!.level < 3) {
      character.career!.level++;
      character.career!.salary = def.salaries[character.career!.level];
      character.modifyStat('reputation', 5);
      character.modifyStat('happiness', 5);
      character.eventHistory.add('Ascendido a ${character.career!.levelName} en ${character.career!.name}');
    }

    if (character.career!.type == CareerType.sports && character.age > 35) {
      if (_random.nextDouble() < 0.15) {
        character.modifyStat('athleticism', -3);
        character.modifyStat('health', -2);
      }
      if (character.age > 40 && _random.nextDouble() < 0.2) {
        character.eventHistory.add('Retiro forzado del deporte por edad');
        character.career = null;
        return;
      }
    }

    if (character.career!.type == CareerType.crime) {
      if (_random.nextDouble() < 0.08) {
        character.modifyStat('reputation', -5);
        if (_random.nextDouble() < 0.2) {
          character.modifyStat('happiness', -10);
          character.addMoney(-_random.nextInt(20000).toDouble());
          character.eventHistory.add('Problemas legales: multas y abogados');
        }
      }
    }
  }

  void _applyRandomStatChanges() {
    if (_random.nextDouble() < 0.4) {
      character.modifyStat('happiness', (_random.nextDouble() * 6 - 3).round());
    }
    if (_random.nextDouble() < 0.3) {
      character.modifyStat('stress', (_random.nextDouble() * 5).round());
    }
    if (character.stats.stress > 70 && _random.nextDouble() < 0.4) {
      character.modifyStat('health', -2);
    }
    if (_random.nextDouble() < 0.2) {
      character.modifyStat('intelligence', (_random.nextDouble() * 2).round());
    }
    if (character.stats.happiness < 20 && _random.nextDouble() < 0.3) {
      character.modifyStat('health', -1);
    }
  }

  void _checkDeathByAge() {
    if (character.age > 95 && _random.nextDouble() < 0.3) {
      character.isAlive = false;
    } else if (character.age > 100) {
      character.isAlive = false;
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
      if (e.moneyRequired != null && character.money < e.moneyRequired!) return false;
      if (e.statRequirements != null) {
        for (final entry in e.statRequirements!.entries) {
          final statValue = _getStat(entry.key);
          if (statValue < entry.value) return false;
        }
      }
      return true;
    }).toList();

    if (available.isEmpty) return null;
    return available[_random.nextInt(available.length)];
  }

  int _getStat(String key) {
    switch (key) {
      case 'intelligence': return character.stats.intelligence;
      case 'charisma': return character.stats.charisma;
      case 'athleticism': return character.stats.athleticism;
      case 'appearance': return character.stats.appearance;
      case 'reputation': return character.stats.reputation;
      case 'health': return character.stats.health;
      case 'discipline': return character.stats.discipline;
      case 'happiness': return character.stats.happiness;
      default: return 50;
    }
  }

  void applyChoice(GameEvent event, EventChoice choice) {
    for (final key in choice.statEffects.keys) {
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

    _applyEventSpecialEffects(event, choice);

    if (choice.nextEventId != null) {
      final next = EventCatalog.allEvents
          .where((e) => e.id == choice.nextEventId)
          .firstOrNull;
      if (next != null) _pendingChainEvents.add(next);
    }

    if (event.oneTime) _usedEvents.add(event.id);
    character.eventHistory.add('${event.title}: ${choice.text}');
    _checkAchievements();
  }

  void _applyEventSpecialEffects(GameEvent event, EventChoice choice) {
    if (event.id == 'marriage_proposal' && choice.text == 'Proponer matrimonio') {
      character.isMarried = true;
      final partnerId = _uuid.v4();
      character.partnerId = partnerId;
      final partner = Relationship(
        id: partnerId,
        name: _randomName(character.gender == 'Hombre' ? 'Mujer' : 'Hombre'),
        type: RelationshipType.partner,
        affinity: 80,
        age: character.age - _random.nextInt(5),
      );
      character.relationships = List.from(character.relationships)..add(partner);
      character.eventHistory.add('Te casaste con ${partner.name}');
    }

    if (event.id == 'having_child' && choice.text.startsWith('Estar emocionado')) {
      final childId = _uuid.v4();
      final child = Relationship(
        id: childId,
        name: _randomName(_random.nextBool() ? 'Hombre' : 'Mujer'),
        type: RelationshipType.child,
        affinity: 90,
        age: 0,
      );
      character.relationships = List.from(character.relationships)..add(child);
      character.childrenIds = List.from(character.childrenIds)..add(childId);
      character.eventHistory.add('Nació ${child.name}');
    }

    if (event.id == 'divorce' && choice.text == 'Separarnos') {
      character.isMarried = false;
      if (character.partnerId != null) {
        character.relationships = character.relationships
            .where((r) => r.id != character.partnerId)
            .toList();
        character.partnerId = null;
      }
    }

    if (event.id == 'inheritance' && choice.text == 'Aceptar la herencia') {
      final asset = Asset(
        id: _uuid.v4(),
        name: 'Herencia familiar',
        type: AssetType.property,
        value: 100000,
        maintenanceCost: 2000,
        income: 0,
      );
      character.assets = List.from(character.assets)..add(asset);
    }

    if (event.id == 'business_opportunity' && choice.text.startsWith('Invertir')) {
      final asset = Asset(
        id: _uuid.v4(),
        name: 'Negocio propio',
        type: AssetType.business,
        value: choice.moneyEffect.abs(),
        maintenanceCost: 5000,
        income: choice.moneyEffect.abs() * 0.12,
      );
      character.assets = List.from(character.assets)..add(asset);
    }

    if (event.id == 'stock_market' && choice.text.startsWith('Invertir')) {
      final asset = Asset(
        id: _uuid.v4(),
        name: 'Cartera de inversiones',
        type: AssetType.investment,
        value: choice.moneyEffect.abs(),
        maintenanceCost: 0,
        income: 0,
      );
      character.assets = List.from(character.assets)..add(asset);
    }

    if (event.id == 'midlife_crisis' && choice.text == 'Comprar un auto deportivo') {
      final asset = Asset(
        id: _uuid.v4(),
        name: 'Auto deportivo de lujo',
        type: AssetType.vehicle,
        value: 50000,
        maintenanceCost: 5000,
        income: 0,
      );
      character.assets = List.from(character.assets)..add(asset);
    }
  }

  void _grantCareer(CareerType type) {
    final def = CareerDefinitions.forType(type);
    if (def == null) return;

    if (character.career != null && character.career!.type == type) return;

    final career = Career(
      type: type,
      name: def.name,
      salary: def.salaries[0],
      level: 0,
      experience: 0,
    );
    character.career = career;
    character.eventHistory.add('Comenzó carrera como ${def.name}');
  }

  void _checkAchievements() {
    if (character.netWorth > 1000000 && !character.achievements.contains('millonario')) {
      character.achievements.add('millonario');
      character.eventHistory.add('¡Logro: Millonario!');
    }
    if (character.netWorth > 100000000 && !character.achievements.contains('multimillonario')) {
      character.achievements.add('multimillonario');
      character.eventHistory.add('¡Logro: Multimillonario!');
    }
    if (character.stats.allMaxed() && !character.achievements.contains('perfecto')) {
      character.achievements.add('perfecto');
      character.eventHistory.add('¡Logro: Perfecto!');
    }
    if (character.career?.level == 3 && !character.achievements.contains('leyenda')) {
      character.achievements.add('leyenda');
      character.eventHistory.add('¡Logro: Leyenda!');
    }
    if (character.age > 100 && !character.achievements.contains('centenario')) {
      character.achievements.add('centenario');
      character.eventHistory.add('¡Logro: Centenario!');
    }
  }

  bool get isGameOver => !character.isAlive;

  String getGameOverSummary() {
    final buffer = StringBuffer();
    buffer.writeln('${character.name} falleció a los ${character.age} años.');
    buffer.writeln('Causa: ${character.dieCause}');
    buffer.writeln('');
    buffer.writeln('=== ESTADÍSTICAS FINALES ===');
    buffer.writeln('Salud: ${character.stats.health}');
    buffer.writeln('Felicidad: ${character.stats.happiness}');
    buffer.writeln('Inteligencia: ${character.stats.intelligence}');
    buffer.writeln('Carisma: ${character.stats.charisma}');
    buffer.writeln('Reputación: ${character.stats.reputation}');
    buffer.writeln('');
    buffer.writeln('=== PATRIMONIO ===');
    buffer.writeln('Dinero: \$${character.money.toStringAsFixed(0)}');
    buffer.writeln('Activos: ${character.assets.length}');
    buffer.writeln('Patrimonio total: \$${character.netWorth.toStringAsFixed(0)}');
    if (character.career != null) {
      buffer.writeln('');
      buffer.writeln('=== CARRERA ===');
      buffer.writeln('${character.career!.name} (${character.career!.levelName})');
      buffer.writeln('Salario final: \$${character.career!.salary.toStringAsFixed(0)}/año');
    }
    buffer.writeln('');
    buffer.writeln('=== FAMILIA ===');
    buffer.writeln('Hijos: ${character.childrenIds.length}');
    buffer.writeln('Relaciones: ${character.relationships.length}');
    buffer.writeln('');
    buffer.writeln('Logros: ${character.achievements.length}');
    buffer.writeln('Eventos vividos: ${character.eventHistory.length}');
    return buffer.toString();
  }

  String? getHeirId() {
    if (character.childrenIds.isEmpty) return null;
    return character.childrenIds[_random.nextInt(character.childrenIds.length)];
  }

  Character createHeir(String heirId) {
    final child = character.relationships.where((r) => r.id == heirId).firstOrNull;
    if (child == null) return character;

    final heir = Character(
      id: _uuid.v4(),
      name: child.name,
      age: child.age,
      money: character.netWorth * 0.5,
      stats: Stats(
        health: 80 + _random.nextInt(15),
        intelligence: (character.stats.intelligence * 0.5 + _random.nextInt(30)).round(),
        appearance: (character.stats.appearance * 0.5 + _random.nextInt(20)).round(),
        charisma: (character.stats.charisma * 0.5 + _random.nextInt(20)).round(),
        athleticism: (character.stats.athleticism * 0.4 + _random.nextInt(25)).round(),
        discipline: (character.stats.discipline * 0.4 + _random.nextInt(20)).round(),
        reputation: 30 + _random.nextInt(20),
        happiness: 50,
        stress: 10,
      ),
      relationships: [],
      assets: [],
      loans: [],
      eventHistory: ['Comienzas con la herencia de ${character.name}'],
      achievements: [],
      educationLevel: 0,
    );
    return heir;
  }
}
