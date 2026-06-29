import 'package:flutter/material.dart';
import 'create_character_screen.dart';
import 'main_game_screen.dart';
import '../persistence/save_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _saves = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSaves();
  }

  Future<void> _loadSaves() async {
    final saves = await SaveManager.listSaves();
    setState(() {
      _saves = saves;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.3),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_stories,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Life Simulator',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vive tu propia historia',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => _startNewGame(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva Vida', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _saves.isEmpty ? null : () => _showLoadDialog(context),
                    icon: const Icon(Icons.save),
                    label: Text(
                      'Cargar Partida',
                      style: TextStyle(
                        fontSize: 18,
                        color: _saves.isEmpty
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                            : null,
                      ),
                    ),
                  ),
                ),
                if (_saves.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_saves.length} partida(s) guardada(s)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startNewGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCharacterScreen()),
    );
  }

  void _showLoadDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _saves.length,
        itemBuilder: (_, i) => ListTile(
          leading: const Icon(Icons.save),
          title: Text(_saves[i]),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await SaveManager.deleteSave(_saves[i]);
              _loadSaves();
              Navigator.pop(ctx);
            },
          ),
          onTap: () async {
            Navigator.pop(ctx);
            final state = await SaveManager.loadSave(_saves[i]);
            if (state != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainGameScreen(gameState: state),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
