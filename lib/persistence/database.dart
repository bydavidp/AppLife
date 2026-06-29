import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pp;

class GameDatabase {
  static Future<String> get _localPath async {
    final directory = await pp.getApplicationDocumentsDirectory();
    final dbDir = Directory('${directory.path}/lifesim_db');
    if (!await dbDir.exists()) {
      await dbDir.create(recursive: true);
    }
    return dbDir.path;
  }

  static Future<bool> saveData(String key, Map<String, dynamic> data) async {
    try {
      final path = await _localPath;
      final file = File('$path/$key.json');
      await file.writeAsString(jsonEncode(data));
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loadData(String key) async {
    try {
      final path = await _localPath;
      final file = File('$path/$key.json');
      if (!await file.exists()) return null;
      final content = await file.readAsString();
      return jsonDecode(content);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> deleteData(String key) async {
    try {
      final path = await _localPath;
      final file = File('$path/$key.json');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, int>> getStats() async {
    final data = await loadData('global_stats');
    if (data == null) return {};
    return data.map((k, v) => MapEntry(k, v as int));
  }

  static Future<void> recordPlaythrough(int yearsLived) async {
    final stats = await getStats();
    stats['total_playthroughs'] = (stats['total_playthroughs'] ?? 0) + 1;
    stats['total_years'] = (stats['total_years'] ?? 0) + yearsLived;
    stats['max_years'] = (stats['max_years'] ?? 0) > yearsLived
        ? stats['max_years']!
        : yearsLived;
    await saveData('global_stats', stats.map((k, v) => MapEntry(k, v)));
  }
}
