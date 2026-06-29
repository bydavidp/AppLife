class Stats {
  int health;
  int intelligence;
  int appearance;
  int charisma;
  int athleticism;
  int reputation;
  int happiness;
  int stress;
  int discipline;

  Stats({
    this.health = 100,
    this.intelligence = 50,
    this.appearance = 50,
    this.charisma = 50,
    this.athleticism = 50,
    this.reputation = 50,
    this.happiness = 70,
    this.stress = 0,
    this.discipline = 50,
  });

  Stats copyWith({
    int? health,
    int? intelligence,
    int? appearance,
    int? charisma,
    int? athleticism,
    int? reputation,
    int? happiness,
    int? stress,
    int? discipline,
  }) {
    return Stats(
      health: health ?? this.health,
      intelligence: intelligence ?? this.intelligence,
      appearance: appearance ?? this.appearance,
      charisma: charisma ?? this.charisma,
      athleticism: athleticism ?? this.athleticism,
      reputation: reputation ?? this.reputation,
      happiness: happiness ?? this.happiness,
      stress: stress ?? this.stress,
      discipline: discipline ?? this.discipline,
    );
  }

  void clampAll() {
    health = health.clamp(0, 100);
    intelligence = intelligence.clamp(0, 100);
    appearance = appearance.clamp(0, 100);
    charisma = charisma.clamp(0, 100);
    athleticism = athleticism.clamp(0, 100);
    reputation = reputation.clamp(0, 100);
    happiness = happiness.clamp(0, 100);
    stress = stress.clamp(0, 100);
    discipline = discipline.clamp(0, 100);
  }

  bool allMaxed() =>
      health >= 100 &&
      intelligence >= 100 &&
      appearance >= 100 &&
      charisma >= 100 &&
      athleticism >= 100 &&
      reputation >= 100 &&
      happiness >= 100 &&
      discipline >= 100;

  double get average =>
      (health + intelligence + appearance + charisma + athleticism +
              reputation + happiness + discipline) /
          8;

  Map<String, dynamic> toJson() => {
        'health': health,
        'intelligence': intelligence,
        'appearance': appearance,
        'charisma': charisma,
        'athleticism': athleticism,
        'reputation': reputation,
        'happiness': happiness,
        'stress': stress,
        'discipline': discipline,
      };

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        health: json['health'] ?? 100,
        intelligence: json['intelligence'] ?? 50,
        appearance: json['appearance'] ?? 50,
        charisma: json['charisma'] ?? 50,
        athleticism: json['athleticism'] ?? 50,
        reputation: json['reputation'] ?? 50,
        happiness: json['happiness'] ?? 70,
        stress: json['stress'] ?? 0,
        discipline: json['discipline'] ?? 50,
      );
}
