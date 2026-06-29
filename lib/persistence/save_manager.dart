import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pp;
import '../domain/models/game_state.dart';

class SaveManager {
  static Future<String> get _localPath async {
    final directory = await pp.getApplicationDocumentsDirectory();
    final savesDir = Directory('${directory.path}/lifesim_saves');
    if (!await savesDir.exists()) {
      await savesDir.create(recursive: true);
    }
    return savesDir.path;
  }

  static Future<List<String>> listSaves() async {
    final path = await _localPath;
    final dir = Directory(path);
    final files = await dir.list().toList();
    return files
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .map((f) => f.uri.pathSegments.last.replaceAll('.json', ''))
        .toList();
  }

  static Future<GameState?> loadSave(String name) async {
    try {
      final path = await _localPath;
      final file = File('$path/$name.json');
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      final json = jsonDecode(content);
      return GameState.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveGame(GameState state) async {
    try {
      final path = await _localPath;
      final file = File('$path/${state.id}.json');
      final json = state.toJson();
      await file.writeAsString(jsonEncode(json));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteSave(String name) async {
    try {
      final path = await _localPath;
      final file = File('$path/$name.json');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> saveExists(String name) async {
    final path = await _localPath;
    final file = File('$path/$name.json');
    return await file.exists();
  }
}
