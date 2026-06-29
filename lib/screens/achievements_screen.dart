import 'package:flutter/material.dart';
import '../domain/models/character.dart';

class AchievementsScreen extends StatelessWidget {
  final Character character;

  const AchievementsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final allAchievements = {
      'millonario': 'Millonario',
      'multimillonario': 'Multimillonario',
      'leyenda': 'Leyenda',
      'perfecto': 'Perfecto',
      'centenario': 'Centenario',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Logros')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: allAchievements.entries.map<Widget>((entry) {
          final unlocked = character.achievements.contains(entry.key);
          final card = Card(
            child: ListTile(
              leading: Icon(
                unlocked ? Icons.emoji_events : Icons.lock,
                color: unlocked ? Colors.amber : Colors.grey,
              ),
              title: Text(
                entry.value,
                style: TextStyle(
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              subtitle: Text(
                unlocked ? 'Desbloqueado' : 'Bloqueado',
                style: TextStyle(
                  color: unlocked ? Colors.green : Colors.grey,
                ),
              ),
            ),
          );
          if (unlocked) return card;
          return Opacity(opacity: 0.4, child: card);
        }).toList(),
      ),
    );
  }
}
