import '../enums/asset_type.dart';

class Asset {
  final String id;
  final String name;
  final AssetType type;
  double value;
  double maintenanceCost;
  double income;

  Asset({
    required this.id,
    required this.name,
    required this.type,
    this.value = 0,
    this.maintenanceCost = 0,
    this.income = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'value': value,
        'maintenanceCost': maintenanceCost,
        'income': income,
      };

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        id: json['id'],
        name: json['name'],
        type: AssetType.values.firstWhere((e) => e.name == json['type']),
        value: (json['value'] ?? 0).toDouble(),
        maintenanceCost: (json['maintenanceCost'] ?? 0).toDouble(),
        income: (json['income'] ?? 0).toDouble(),
      );
}

class Loan {
  final String id;
  final String name;
  double amount;
  double remaining;
  double monthlyPayment;
  double interestRate;

  Loan({
    required this.id,
    required this.name,
    this.amount = 0,
    this.remaining = 0,
    this.monthlyPayment = 0,
    this.interestRate = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'remaining': remaining,
        'monthlyPayment': monthlyPayment,
        'interestRate': interestRate,
      };

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
        id: json['id'],
        name: json['name'],
        amount: (json['amount'] ?? 0).toDouble(),
        remaining: (json['remaining'] ?? 0).toDouble(),
        monthlyPayment: (json['monthlyPayment'] ?? 0).toDouble(),
        interestRate: (json['interestRate'] ?? 0).toDouble(),
      );
}
