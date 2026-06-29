import 'dart:math';
import 'stats.dart';
import 'career.dart';
import 'relationship.dart';
import 'asset.dart';
class Character {
  final String id;
  String name;
  String gender;
  int age;
  bool isAlive;
  DateTime birthDate;
  Stats stats;
  Career? career;
  List<Relationship> relationships;
  List<Asset> assets;
  List<Loan> loans;
  double money;
  List<String> eventHistory;
  List<String> achievements;
  int educationLevel;
  bool isMarried;
  String? partnerId;
  List<String> childrenIds;

  Character({
    required this.id,
    required this.name,
    this.gender = 'Hombre',
    this.age = 0,
    this.isAlive = true,
    DateTime? birthDate,
    Stats? stats,
    this.career,
    this.relationships = const [],
    this.assets = const [],
    this.loans = const [],
    this.money = 0,
    this.eventHistory = const [],
    this.achievements = const [],
    this.educationLevel = 0,
    this.isMarried = false,
    this.partnerId,
    this.childrenIds = const [],
  })  : birthDate = birthDate ?? DateTime.now(),
        stats = stats ?? Stats();

  double get netWorth {
    double assetValue = 0;
    for (final a in assets) {
      assetValue += a.value;
    }
    double totalDebt = 0;
    for (final l in loans) {
      totalDebt += l.remaining;
    }
    return money + assetValue - totalDebt;
  }

  double get monthlyExpenses {
    double expenses = 0;
    for (final a in assets) {
      expenses += a.maintenanceCost / 12;
    }
    expenses += 500 * (1 + netWorth / 100000); // living costs scale with wealth
    return expenses;
  }

  double get monthlyIncome {
    double income = 0;
    if (career != null) {
      income += career!.salary / 12;
    }
    for (final a in assets) {
      income += a.income / 12;
    }
    return income;
  }

  void ageOneYear(Random random) {
    age++;
    if (age > 5) {
      stats.health -= (age > 50 ? 2 : age > 30 ? 1 : 0);
      stats.stress += (stats.stress < 100 ? 2 : 0);
    }
    if (age > 80) {
      stats.health -= 3;
    }
    if (age > 90) {
      stats.health -= 5;
    }
    stats.clampAll();

    if (stats.health <= 0) {
      isAlive = false;
    }
  }

  void addMoney(double amount) {
    money += amount;
    if (money < 0) money = 0;
  }

  void modifyStat(String stat, int amount) {
    switch (stat) {
      case 'health':
        stats.health += amount;
        break;
      case 'intelligence':
        stats.intelligence += amount;
        break;
      case 'appearance':
        stats.appearance += amount;
        break;
      case 'charisma':
        stats.charisma += amount;
        break;
      case 'athleticism':
        stats.athleticism += amount;
        break;
      case 'reputation':
        stats.reputation += amount;
        break;
      case 'happiness':
        stats.happiness += amount;
        break;
      case 'stress':
        stats.stress += amount;
        break;
      case 'discipline':
        stats.discipline += amount;
        break;
    }
    stats.clampAll();
  }

  String get dieCause {
    if (stats.health <= 0) {
      if (age > 90) return 'Vejez';
      if (stats.stress > 80) return 'Ataque al corazón';
      return 'Enfermedad';
    }
    return 'Causa desconocida';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender,
        'age': age,
        'isAlive': isAlive,
        'birthDate': birthDate.toIso8601String(),
        'stats': stats.toJson(),
        'career': career?.toJson(),
        'relationships': relationships.map((r) => r.toJson()).toList(),
        'assets': assets.map((a) => a.toJson()).toList(),
        'loans': loans.map((l) => l.toJson()).toList(),
        'money': money,
        'eventHistory': eventHistory,
        'achievements': achievements,
        'educationLevel': educationLevel,
        'isMarried': isMarried,
        'partnerId': partnerId,
        'childrenIds': childrenIds,
      };

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'],
        name: json['name'],
        gender: json['gender'] ?? 'Hombre',
        age: json['age'] ?? 0,
        isAlive: json['isAlive'] ?? true,
        birthDate: DateTime.parse(json['birthDate']),
        stats: Stats.fromJson(json['stats'] ?? {}),
        career: json['career'] != null
            ? Career.fromJson(json['career'])
            : null,
        relationships: (json['relationships'] as List?)
                ?.map((r) => Relationship.fromJson(r))
                .toList() ??
            [],
        assets: (json['assets'] as List?)
                ?.map((a) => Asset.fromJson(a))
                .toList() ??
            [],
        loans: (json['loans'] as List?)
                ?.map((l) => Loan.fromJson(l))
                .toList() ??
            [],
        money: (json['money'] ?? 0).toDouble(),
        eventHistory: List<String>.from(json['eventHistory'] ?? []),
        achievements: List<String>.from(json['achievements'] ?? []),
        educationLevel: json['educationLevel'] ?? 0,
        isMarried: json['isMarried'] ?? false,
        partnerId: json['partnerId'],
        childrenIds: List<String>.from(json['childrenIds'] ?? []),
      );
}
