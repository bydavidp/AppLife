import 'character.dart';

class GameState {
  final String id;
  final String playerName;
  final Character character;
  final int currentYear;
  final DateTime lastSaved;
  final bool isLegacyMode;

  GameState({
    required this.id,
    required this.playerName,
    required this.character,
    required this.currentYear,
    required this.lastSaved,
    this.isLegacyMode = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'playerName': playerName,
        'character': character.toJson(),
        'currentYear': currentYear,
        'lastSaved': lastSaved.toIso8601String(),
        'isLegacyMode': isLegacyMode,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        id: json['id'],
        playerName: json['playerName'],
        character: Character.fromJson(json['character']),
        currentYear: json['currentYear'] ?? 2024,
        lastSaved: DateTime.parse(json['lastSaved']),
        isLegacyMode: json['isLegacyMode'] ?? false,
      );
}
