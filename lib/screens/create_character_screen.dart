import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/character.dart';
import '../domain/models/stats.dart';
import '../domain/models/game_state.dart';
import 'main_game_screen.dart';

class CreateCharacterScreen extends StatefulWidget {
  const CreateCharacterScreen({super.key});

  @override
  State<CreateCharacterScreen> createState() => _CreateCharacterScreenState();
}

class _CreateCharacterScreenState extends State<CreateCharacterScreen> {
  final _nameController = TextEditingController();
  String _gender = 'Hombre';
  int _pointsRemaining = 20;
  final _stats = Stats();
  final _uuid = const Uuid();

  final Map<String, int> _tempStats = {
    'intelligence': 50,
    'appearance': 50,
    'charisma': 50,
    'athleticism': 50,
    'discipline': 50,
  };

  final Map<String, String> _statNames = {
    'intelligence': 'Inteligencia',
    'appearance': 'Apariencia',
    'charisma': 'Carisma',
    'athleticism': 'Atletismo',
    'discipline': 'Disciplina',
  };

  final Map<String, IconData> _statIcons = {
    'intelligence': Icons.psychology,
    'appearance': Icons.face,
    'charisma': Icons.forum,
    'athleticism': Icons.fitness_center,
    'discipline': Icons.self_improvement,
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Personaje'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text('Género', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Hombre', label: Text('Hombre')),
                ButtonSegment(value: 'Mujer', label: Text('Mujer')),
              ],
              selected: {_gender},
              onSelectionChanged: (v) => setState(() => _gender = v.first),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Distribuir puntos', style: theme.textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _pointsRemaining > 0
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$_pointsRemaining pts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _pointsRemaining > 0
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._tempStats.keys.map((key) => _buildStatSlider(key)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _canCreate() ? _createCharacter : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Comenzar Vida', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatSlider(String key) {
    final value = _tempStats[key]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_statIcons[key]!, size: 20),
              const SizedBox(width: 8),
              Text(_statNames[key]!),
              const Spacer(),
              Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: 20,
            max: 80,
            divisions: 60,
            label: '$value',
            onChanged: (v) {
              final diff = v.toInt() - value;
              if (_pointsRemaining - diff >= 0) {
                setState(() {
                  _tempStats[key] = v.toInt();
                  _pointsRemaining -= diff;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  bool _canCreate() => _nameController.text.trim().isNotEmpty;

  void _createCharacter() {
    final now = DateTime.now();
    final birthDate = DateTime(now.year - 0, now.month, now.day);

    final stats = Stats(
      intelligence: _tempStats['intelligence']!,
      appearance: _tempStats['appearance']!,
      charisma: _tempStats['charisma']!,
      athleticism: _tempStats['athleticism']!,
      discipline: _tempStats['discipline']!,
    );

    final character = Character(
      id: _uuid.v4(),
      name: _nameController.text.trim(),
      gender: _gender,
      age: 0,
      birthDate: birthDate,
      stats: stats,
      money: 500,
    );

    final state = GameState(
      id: character.id,
      playerName: character.name,
      character: character,
      currentYear: now.year,
      lastSaved: now,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainGameScreen(gameState: state),
      ),
    );
  }
}
