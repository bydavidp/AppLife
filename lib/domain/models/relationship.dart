import '../enums/relationship_type.dart';

class Relationship {
  final String id;
  final String name;
  final RelationshipType type;
  int affinity;
  bool isAlive;
  int age;
  String? career;

  Relationship({
    required this.id,
    required this.name,
    required this.type,
    this.affinity = 50,
    this.isAlive = true,
    this.age = 30,
    this.career,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'affinity': affinity,
        'isAlive': isAlive,
        'age': age,
        'career': career,
      };

  factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        id: json['id'],
        name: json['name'],
        type: RelationshipType.values.firstWhere((e) => e.name == json['type']),
        affinity: json['affinity'] ?? 50,
        isAlive: json['isAlive'] ?? true,
        age: json['age'] ?? 30,
        career: json['career'],
      );
}
