import 'dart:math';
import 'package:flutter/material.dart';
import '../domain/models/game_state.dart';
import '../domain/models/game_event.dart';
import '../domain/models/character.dart';
import '../domain/enums/asset_type.dart';
import '../engine/game_engine.dart';
import '../persistence/save_manager.dart';
import '../widgets/stat_bar.dart';
import '../widgets/decision_card.dart';
import 'economy_screen.dart';
import 'family_screen.dart';
import 'events_history_screen.dart';
import 'achievements_screen.dart';
import 'shop_screen.dart';

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
  int _eventYearsSkipped = 0;

  @override
  void initState() {
    super.initState();
    _gameState = widget.gameState;
    _engine = GameEngine(character: _gameState.character, currentYear: _gameState.currentYear);

    if (_gameState.character.relationships.isEmpty && _gameState.character.age < 5) {
      _engine.initializeFamily();
    }

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
      currentYear: _engine.currentYear,
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
      currentYear: _engine.currentYear,
      lastSaved: DateTime.now(),
    );

    if (_engine.isGameOver) {
      _showGameOver();
      return;
    }

    _eventYearsSkipped = 0;
    _checkForEvent();
    setState(() {});
  }

  void _advanceMultipleYears(int years) {
    if (!_engine.character.isAlive) return;

    for (int i = 0; i < years; i++) {
      _engine.advanceYear();
      if (_engine.isGameOver) break;
    }

    _gameState = GameState(
      id: _gameState.id,
      playerName: _gameState.playerName,
      character: _engine.character,
      currentYear: _engine.currentYear,
      lastSaved: DateTime.now(),
    );

    if (_engine.isGameOver) {
      _showGameOver();
      return;
    }

    _eventYearsSkipped = 0;
    _checkForEvent();
    setState(() {});
  }

  void _checkForEvent() {
    if (!_engine.character.isAlive) return;

    if (_eventYearsSkipped > 3) {
      _eventYearsSkipped = 0;
      setState(() => _currentEvent = null);
      return;
    }

    final event = _engine.getNextEvent();
    if (event != null) {
      setState(() {
        _currentEvent = event;
        _showEvent = true;
      });
    } else {
      _eventYearsSkipped++;
      setState(() => _currentEvent = null);
    }
  }

  void _handleChoice(EventChoice choice) {
    if (_currentEvent == null) return;
    _engine.applyChoice(_currentEvent!, choice);
    _gameState = GameState(
      id: _gameState.id,
      playerName: _gameState.playerName,
      character: _engine.character,
      currentYear: _engine.currentYear,
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

  void _startLegacy() {
    final heirId = _engine.getHeirId();
    if (heirId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No tienes hijos para continuar el legado'), backgroundColor: Colors.orange),
      );
      return;
    }

    final heir = _engine.createHeir(heirId);
    _engine = GameEngine(character: heir, currentYear: _engine.currentYear);
    _engine.initializeFamily();
    _gameState = GameState(
      id: heir.id,
      playerName: heir.name,
      character: heir,
      currentYear: _engine.currentYear,
      lastSaved: DateTime.now(),
      isLegacyMode: true,
    );

    setState(() {
      _showSummary = false;
      _showEvent = false;
      _currentEvent = null;
    });
    _checkForEvent();
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
        title: Text('${c.name} - ${c.age} años', style: const TextStyle(fontSize: 16)),
        actions: [
          if (c.age >= 18)
            IconButton(icon: const Icon(Icons.shopping_bag), onPressed: () => _openShop()),
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

  void _openShop() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopScreen(
          character: _engine.character,
          onPurchase: () {
            setState(() {});
            _saveGame();
          },
        ),
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
            if (c.career != null) 'Nivel: ${c.career!.levelName} · Salario: \$${c.career!.salary.toStringAsFixed(0)}/año',
            if (c.isMarried) 'Estado: Casado/a',
            'Hijos: ${c.childrenIds.length} · Logros: ${c.achievements.length}',
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: StatBar(label: 'Inteligen.', value: c.stats.intelligence, icon: Icons.psychology)),
            const SizedBox(width: 8),
            Expanded(child: StatBar(label: 'Apariencia', value: c.stats.appearance, icon: Icons.face)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: StatBar(label: 'Carisma', value: c.stats.charisma, icon: Icons.forum)),
            const SizedBox(width: 8),
            Expanded(child: StatBar(label: 'Atletismo', value: c.stats.athleticism, icon: Icons.fitness_center)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            Expanded(child: StatBar(label: 'Disciplina', value: c.stats.discipline, icon: Icons.self_improvement)),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
          ]),
          const SizedBox(height: 16),
          if (c.relationships.isNotEmpty) ...[
            Text('Relaciones cercanas', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: c.relationships.where((r) => r.isAlive).take(6).map((r) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: Icon(Icons.person, size: 14),
                    label: Text('${r.name} (${r.affinity})', style: const TextStyle(fontSize: 10)),
                    visualDensity: VisualDensity.compact,
                  ),
                )).toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _engine.isGameOver ? null : _advanceYear,
              icon: const Icon(Icons.timer),
              label: Text('Avanzar 1 año', style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 8),
          if (c.age >= 16)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _engine.isGameOver ? null : () => _advanceMultipleYears(5),
                icon: const Icon(Icons.fast_forward),
                label: const Text('Avanzar 5 años'),
              ),
            ),
          if (c.age >= 30)
            const SizedBox(height: 8),
          if (c.age >= 30)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _engine.isGameOver ? null : () => _advanceMultipleYears(10),
                icon: const Icon(Icons.skip_next),
                label: const Text('Avanzar 10 años'),
              ),
            ),
          const SizedBox(height: 16),
          if (c.eventHistory.length > 2) ...[
            Text('Eventos recientes:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            ...c.eventHistory.reversed.take(5).map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
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
        child: Column(children: [
          Row(children: [
            Expanded(child: StatBar(label: 'Salud', value: c.stats.health, icon: Icons.favorite)),
            const SizedBox(width: 8),
            Expanded(child: StatBar(label: 'Felicidad', value: c.stats.happiness, icon: Icons.emoji_emotions)),
          ]),
          Row(children: [
            Expanded(child: StatBar(label: 'Estrés', value: c.stats.stress, icon: Icons.bolt, color: c.stats.stress > 60 ? Colors.red : Colors.orange)),
            const SizedBox(width: 8),
            Expanded(child: StatBar(label: 'Reputación', value: c.stats.reputation, icon: Icons.star)),
          ]),
        ]),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, String title, List<String> lines) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: Text(l, style: theme.textTheme.bodySmall))),
        ]),
      ),
    );
  }

  Widget _buildGameOverScreen(ThemeData theme) {
    final hasHeir = _engine.getHeirId() != null;
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_summary, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              ),
              const SizedBox(height: 24),
              if (hasHeir)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _startLegacy,
                    icon: const Icon(Icons.family_restroom),
                    label: const Text('Continuar con el legado', style: TextStyle(fontSize: 18)),
                  ),
                ),
              if (hasHeir) const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                  icon: const Icon(Icons.home),
                  label: const Text('Volver al inicio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
