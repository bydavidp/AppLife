import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/models/game_state.dart';
import '../domain/models/game_event.dart';
import '../domain/enums/asset_type.dart';
import '../engine/game_engine.dart';
import '../persistence/save_manager.dart';
import '../widgets/stat_bar.dart';
import '../widgets/decision_card.dart';
import 'economy_screen.dart';
import 'family_screen.dart';
import 'events_history_screen.dart';
import 'achievements_screen.dart';

class MainGameScreen extends StatefulWidget {
  final GameState gameState;

  const MainGameScreen({super.key, required this.gameState});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late GameEngine _engine;
  late GameState _gameState;
  GameEvent? _currentEvent;
  bool _showEvent = false;
  bool _showSummary = false;
  String _summary = '';
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
    _engine = GameEngine(character: _gameState.character);
    if (_gameState.character.age == 0) {
      _advanceToAge(1);
    }
    _checkForEvent();
  }

  void _advanceToAge(int targetAge) {
    while (_engine.character.age < targetAge && _engine.character.isAlive) {
      _engine.advanceYear();
    }
    _gameState = GameState(
      id: _gameState.id,
      playerName: _gameState.playerName,
      character: _engine.character,
      currentYear: _gameState.currentYear + (targetAge - _engine.character.age),
      lastSaved: DateTime.now(),
    );
  }

  void _advanceYear() {
    if (!_engine.character.isAlive) return;

    _engine.advanceYear();
    _gameState = GameState(
      id: _gameState.id,
      playerName: _gameState.playerName,
      character: _engine.character,
      currentYear: _gameState.currentYear + 1,
      lastSaved: DateTime.now(),
    );

    if (_engine.isGameOver) {
      _showGameOver();
      return;
    }

    _checkForEvent();
    setState(() {});
  }

  void _checkForEvent() {
    if (_engine.character.isAlive && Random().nextDouble() < 0.6) {
      final event = _engine.getNextEvent();
      if (event != null) {
        setState(() {
          _currentEvent = event;
          _showEvent = true;
        });
        return;
      }
    }
    setState(() => _currentEvent = null);
  }

  void _handleChoice(EventChoice choice) {
    if (_currentEvent == null) return;
    _engine.applyChoice(_currentEvent!, choice);
    _gameState = GameState(
      id: _gameState.id,
      playerName: _gameState.playerName,
      character: _engine.character,
      currentYear: _gameState.currentYear,
      lastSaved: DateTime.now(),
    );

    setState(() {
      _showEvent = false;
      _currentEvent = null;
    });

    if (_engine.isGameOver) {
      _showGameOver();
    }
  }

  void _showGameOver() {
    setState(() {
      _showSummary = true;
      _summary = _engine.getGameOverSummary();
    });
  }

  Future<void> _saveGame() async {
    final success = await SaveManager.saveGame(_gameState);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Partida guardada' : 'Error al guardar'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = _engine.character;

    if (_showSummary) {
      return _buildGameOverScreen(theme);
    }

    final screens = [
      _buildMainView(theme),
      EconomyScreen(character: c),
      FamilyScreen(character: c),
      EventsHistoryScreen(character: c),
      AchievementsScreen(character: c),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${c.name} - ${c.age} años',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveGame),
        ],
      ),
      body: screens[_navIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person), label: 'Vida'),
          NavigationDestination(icon: Icon(Icons.account_balance), label: 'Economía'),
          NavigationDestination(icon: Icon(Icons.family_restroom), label: 'Familia'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Eventos'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Logros'),
        ],
      ),
    );
  }

  Widget _buildMainView(ThemeData theme) {
    if (_showEvent && _currentEvent != null) {
      return SingleChildScrollView(
        child: DecisionCard(
          event: _currentEvent!,
          onChoice: _handleChoice,
        ),
      );
    }

    return _buildGameView(theme);
  }

  Widget _buildGameView(ThemeData theme) {
    final c = _engine.character;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopStats(theme, c),
          const SizedBox(height: 12),
          _buildInfoCard(theme, 'Resumen', [
            'Dinero: \$${c.money.toStringAsFixed(0)}',
            'Patrimonio: \$${c.netWorth.toStringAsFixed(0)}',
            'Carrera: ${c.career?.name ?? "Sin empleo"}',
            if (c.career != null)
              'Nivel: ${c.career!.levelName} · Salario: \$${c.career!.salary.toStringAsFixed(0)}/año',
            'Logros: ${c.achievements.length}',
          ]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatBar(
                  label: 'Inteligen.',
                  value: c.stats.intelligence,
                  icon: Icons.psychology,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatBar(
                  label: 'Apariencia',
                  value: c.stats.appearance,
                  icon: Icons.face,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: StatBar(
                  label: 'Carisma',
                  value: c.stats.charisma,
                  icon: Icons.forum,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatBar(
                  label: 'Atletismo',
                  value: c.stats.athleticism,
                  icon: Icons.fitness_center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: StatBar(
                  label: 'Disciplina',
                  value: c.stats.discipline,
                  icon: Icons.self_improvement,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 16),
          if (c.relationships.isNotEmpty) ...[
            Text('Familia y relaciones', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: c.relationships.map((r) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: Icon(
                      r.isAlive ? Icons.person : Icons.person_off,
                      size: 14,
                    ),
                    label: Text(
                      '${r.name} (${r.affinity})',
                      style: const TextStyle(fontSize: 10),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _engine.isGameOver ? null : _advanceYear,
              icon: const Icon(Icons.timer),
              label: Text(
                _engine.isGameOver ? 'Fin del juego' : 'Avanzar año',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (c.eventHistory.length > 2) ...[
            Text('Últimos eventos:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            ...c.eventHistory.reversed.take(4).map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildTopStats(ThemeData theme, dynamic c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatBar(
                    label: 'Salud',
                    value: c.stats.health,
                    icon: Icons.favorite,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatBar(
                    label: 'Felicidad',
                    value: c.stats.happiness,
                    icon: Icons.emoji_emotions,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatBar(
                    label: 'Estrés',
                    value: c.stats.stress,
                    icon: Icons.bolt,
                    color: c.stats.stress > 60 ? Colors.red : Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatBar(
                    label: 'Reputación',
                    value: c.stats.reputation,
                    icon: Icons.star,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, String title, List<String> lines) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...lines.map((l) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: Text(l, style: theme.textTheme.bodySmall),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverScreen(ThemeData theme) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 80, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text('Game Over', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 24),
              Text(_summary, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
