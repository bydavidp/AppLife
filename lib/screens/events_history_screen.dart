import 'package:flutter/material.dart';
import '../domain/models/character.dart';

class EventsHistoryScreen extends StatelessWidget {
  final Character character;

  const EventsHistoryScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Eventos')),
      body: character.eventHistory.isEmpty
          ? Center(
              child: Text(
                'Sin eventos registrados',
                style: theme.textTheme.bodyLarge?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: character.eventHistory.length,
              itemBuilder: (_, i) {
                final idx = character.eventHistory.length - 1 - i;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      '${idx + 1}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(
                    character.eventHistory[idx],
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),
    );
  }
}
