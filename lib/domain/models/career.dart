import '../enums/career_type.dart';

class Career {
  final CareerType type;
  String name;
  int level; // 0 = entry, 1 = mid, 2 = senior, 3 = elite
  double salary;
  double experience;
  double reputationGain;

  Career({
    required this.type,
    required this.name,
    this.level = 0,
    this.salary = 0,
    this.experience = 0,
    this.reputationGain = 0,
  });

  String get levelName {
    switch (type) {
      case CareerType.sports:
        return ['Novato', 'Profesional', 'Estrella', 'Leyenda'][level.clamp(0, 3)];
      case CareerType.business:
        return ['Emprendedor', 'Gerente', 'Directivo', 'Magnate'][level.clamp(0, 3)];
      case CareerType.influencer:
        return ['Novato', 'Creador', 'Celebridad', 'Icono'][level.clamp(0, 3)];
      case CareerType.music:
        return ['Aficionado', 'Artista', 'Estrella', 'Leyenda'][level.clamp(0, 3)];
      case CareerType.acting:
        return ['Extra', 'Actor', 'Estrella', 'A-List'][level.clamp(0, 3)];
      case CareerType.politics:
        return ['Activista', 'Concejal', 'Senador', 'Presidente'][level.clamp(0, 3)];
      case CareerType.investment:
        return ['Novato', 'Analista', 'Gestor', 'Magnate'][level.clamp(0, 3)];
      case CareerType.crime:
        return ['Ladrón', 'Mafioso', 'Capo', 'Don'][level.clamp(0, 3)];
      case CareerType.medical:
        return ['Interno', 'Residente', 'Especialista', 'Cirujano Jefe'][level.clamp(0, 3)];
      case CareerType.tech:
        return ['Junior', 'Senior', 'Arquitecto', 'CTO'][level.clamp(0, 3)];
      case CareerType.education:
        return ['Profesor', 'Director', 'Decano', 'Rector'][level.clamp(0, 3)];
      default:
        return '';
    }
  }

  double get maxSalary {
    return salary * (1 + level * 0.5);
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'name': name,
        'level': level,
        'salary': salary,
        'experience': experience,
        'reputationGain': reputationGain,
      };

  factory Career.fromJson(Map<String, dynamic> json) => Career(
        type: CareerType.values.firstWhere((e) => e.name == json['type']),
        name: json['name'] ?? '',
        level: json['level'] ?? 0,
        salary: (json['salary'] ?? 0).toDouble(),
        experience: (json['experience'] ?? 0).toDouble(),
        reputationGain: (json['reputationGain'] ?? 0).toDouble(),
      );
}
