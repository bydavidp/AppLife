import 'package:flutter/material.dart';
import '../domain/enums/event_type.dart';
import '../domain/models/game_event.dart';

class DecisionCard extends StatelessWidget {
  final GameEvent event;
  final void Function(EventChoice choice) onChoice;

  const DecisionCard({
    super.key,
    required this.event,
    required this.onChoice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _eventColor(event.type);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_eventIcon(event.type), color: typeColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  event.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.description,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ...event.choices.map((choice) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => onChoice(choice),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        choice.text,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  IconData _eventIcon(EventType type) {
    switch (type) {
      case EventType.school:
        return Icons.school;
      case EventType.work:
        return Icons.work;
      case EventType.sports:
        return Icons.fitness_center;
      case EventType.romantic:
        return Icons.favorite;
      case EventType.financial:
        return Icons.account_balance;
      case EventType.social:
        return Icons.people;
      case EventType.random:
        return Icons.casino;
      case EventType.crime:
        return Icons.gavel;
      case EventType.medical:
        return Icons.local_hospital;
      case EventType.family:
        return Icons.family_restroom;
      case EventType.lifeMilestone:
        return Icons.celebration;
    }
  }

  Color _eventColor(EventType type) {
    switch (type) {
      case EventType.school:
        return Colors.blue;
      case EventType.work:
        return Colors.indigo;
      case EventType.sports:
        return Colors.green;
      case EventType.romantic:
        return Colors.pink;
      case EventType.financial:
        return Colors.amber;
      case EventType.social:
        return Colors.teal;
      case EventType.random:
        return Colors.purple;
      case EventType.crime:
        return Colors.red;
      case EventType.medical:
        return Colors.cyan;
      case EventType.family:
        return Colors.orange;
      case EventType.lifeMilestone:
        return Colors.deepPurple;
    }
  }
}
