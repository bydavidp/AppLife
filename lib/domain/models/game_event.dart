import '../enums/event_type.dart';

class GameEvent {
  final String id;
  final EventType type;
  final String title;
  final String description;
  final int minAge;
  final int maxAge;
  final Map<String, int>? statRequirements;
  final String? careerRequired;
  final double? moneyRequired;
  final bool oneTime;
  final List<EventChoice> choices;

  GameEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.minAge = 0,
    this.maxAge = 120,
    this.statRequirements,
    this.careerRequired,
    this.moneyRequired,
    this.oneTime = false,
    required this.choices,
  });
}

class EventChoice {
  final String text;
  final Map<String, int> statEffects;
  final double moneyEffect;
  final double? reputationEffect;
  final String? nextEventId;
  final String? careerGranted;
  final double? careerExperience;

  EventChoice({
    required this.text,
    this.statEffects = const {},
    this.moneyEffect = 0,
    this.reputationEffect,
    this.nextEventId,
    this.careerGranted,
    this.careerExperience,
  });
}
