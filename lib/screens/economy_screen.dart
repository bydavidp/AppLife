import 'package:flutter/material.dart';
import '../domain/models/character.dart';
import '../domain/enums/asset_type.dart';

class EconomyScreen extends StatelessWidget {
  final Character character;

  const EconomyScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final income = character.monthlyIncome * 12;
    final expenses = character.monthlyExpenses * 12;
    final net = income - expenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Economía')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Patrimonio Neto',
                        style: theme.textTheme.titleMedium),
                    Text(
                      '\$${character.netWorth.toStringAsFixed(0)}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: character.netWorth >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ingresos anuales: \$${income.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium),
                    Text('Gastos anuales: \$${expenses.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium),
                    Text('Balance: \$${net.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: net >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Activos', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            ...character.assets.map((a) => Card(
                  child: ListTile(
                    leading: Icon(_assetIcon(a.type)),
                    title: Text(a.name),
                    subtitle: Text('\$${a.value.toStringAsFixed(0)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (a.income > 0)
                          Text('+\$${a.income.toStringAsFixed(0)}/año',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 12)),
                        if (a.maintenanceCost > 0)
                          Text('-\$${a.maintenanceCost.toStringAsFixed(0)}/año',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12)),
                      ],
                    ),
                  ),
                )),
            if (character.assets.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Sin activos aún',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                ),
              ),
            const SizedBox(height: 12),
            Text('Deudas', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            ...character.loans.map((l) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.money_off, color: Colors.red),
                    title: Text(l.name),
                    subtitle:
                        Text('\$${l.remaining.toStringAsFixed(0)} restantes'),
                    trailing: Text('\$${l.monthlyPayment.toStringAsFixed(0)}/mes'),
                  ),
                )),
            if (character.loans.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Sin deudas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5))),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _assetIcon(AssetType type) {
    switch (type) {
      case AssetType.property:
        return Icons.home;
      case AssetType.vehicle:
        return Icons.directions_car;
      case AssetType.luxury:
        return Icons.diamond;
      case AssetType.business:
        return Icons.business;
      case AssetType.investment:
        return Icons.trending_up;
    }
  }
}
