import 'package:flutter/material.dart';
import '../domain/models/character.dart';
import '../domain/enums/relationship_type.dart';

class FamilyScreen extends StatelessWidget {
  final Character character;

  const FamilyScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Familia y Relaciones')),
      body: character.relationships.isEmpty
          ? Center(
              child: Text(
                'Sin relaciones aún',
                style: theme.textTheme.bodyLarge?.copyWith(
                    color:
                        theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: character.relationships.length,
              itemBuilder: (_, i) {
                final r = character.relationships[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _affinityColor(r.affinity),
                      child: Icon(
                        r.isAlive ? Icons.person : Icons.person_off,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(r.name),
                    subtitle: Text(
                        '${_typeName(r.type)} · Afinidad: ${r.affinity}%'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!r.isAlive)
                          const Icon(Icons.shield_outlined,
                              color: Colors.grey, size: 16),
                        Text('${r.age}',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _affinityColor(int affinity) {
    if (affinity < 25) return Colors.red;
    if (affinity < 50) return Colors.orange;
    if (affinity < 75) return Colors.blue;
    return Colors.green;
  }

  String _typeName(RelationshipType type) {
    switch (type) {
      case RelationshipType.parent:
        return 'Padre/Madre';
      case RelationshipType.partner:
        return 'Pareja';
      case RelationshipType.child:
        return 'Hijo/a';
      case RelationshipType.friend:
        return 'Amigo';
      case RelationshipType.rival:
        return 'Rival';
    }
  }
}
