import '../domain/enums/career_type.dart';

class CareerDefinition {
  final CareerType type;
  final String name;
  final String description;
  final Map<String, int> requirements;
  final List<double> salaries;
  final double experiencePerYear;

  const CareerDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.requirements,
    required this.salaries,
    this.experiencePerYear = 15,
  });
}

class CareerDefinitions {
  static List<CareerDefinition> all = [
    const CareerDefinition(
      type: CareerType.sports,
      name: 'Deportista Profesional',
      description: 'Carrera en el deporte profesional. Requiere disciplina y condición física.',
      requirements: {'athleticism': 60, 'discipline': 40},
      salaries: [30000, 150000, 500000, 2000000],
    ),
    const CareerDefinition(
      type: CareerType.business,
      name: 'Empresario',
      description: 'Construye tu propio imperio empresarial desde cero.',
      requirements: {'intelligence': 50, 'charisma': 40, 'discipline': 30},
      salaries: [20000, 80000, 300000, 1000000],
    ),
    const CareerDefinition(
      type: CareerType.influencer,
      name: 'Creador de Contenido',
      description: 'Construye una audiencia en redes sociales y monetiza tu influencia.',
      requirements: {'charisma': 50, 'appearance': 30},
      salaries: [5000, 40000, 200000, 800000],
    ),
    const CareerDefinition(
      type: CareerType.music,
      name: 'Músico',
      description: 'Persigue tu pasión por la música y conviértete en una estrella.',
      requirements: {'charisma': 45, 'discipline': 40, 'intelligence': 30},
      salaries: [5000, 50000, 300000, 1500000],
    ),
    const CareerDefinition(
      type: CareerType.acting,
      name: 'Actor',
      description: 'Triunfa en la industria del entretenimiento con talento y carisma.',
      requirements: {'charisma': 55, 'appearance': 45},
      salaries: [5000, 60000, 400000, 2000000],
    ),
    const CareerDefinition(
      type: CareerType.politics,
      name: 'Político',
      description: 'Sirve al público mientras construyes tu poder e influencia.',
      requirements: {'charisma': 50, 'intelligence': 50, 'reputation': 40},
      salaries: [30000, 80000, 200000, 400000],
    ),
    const CareerDefinition(
      type: CareerType.investment,
      name: 'Inversor',
      description: 'Haz crecer tu capital con inversiones inteligentes en el mercado.',
      requirements: {'intelligence': 55, 'discipline': 40},
      salaries: [15000, 60000, 250000, 1000000],
    ),
    const CareerDefinition(
      type: CareerType.crime,
      name: 'Criminal',
      description: 'Opera en los márgenes de la ley para acumular riqueza rápidamente.',
      requirements: {'discipline': 20, 'charisma': 25},
      salaries: [20000, 80000, 300000, 1000000],
    ),
    const CareerDefinition(
      type: CareerType.medical,
      name: 'Médico',
      description: 'Salva vidas mientras construyes una carrera respetada y lucrativa.',
      requirements: {'intelligence': 60, 'discipline': 50},
      salaries: [35000, 120000, 300000, 600000],
    ),
    const CareerDefinition(
      type: CareerType.tech,
      name: 'Tecnología',
      description: 'Innovación tecnológica y crecimiento en la industria digital.',
      requirements: {'intelligence': 55, 'discipline': 40},
      salaries: [40000, 120000, 300000, 800000],
    ),
    const CareerDefinition(
      type: CareerType.education,
      name: 'Educador',
      description: 'Forma las mentes del futuro en el mundo académico.',
      requirements: {'intelligence': 45, 'charisma': 30},
      salaries: [25000, 45000, 70000, 120000],
    ),
  ];

  static CareerDefinition? forType(CareerType type) {
    try {
      return all.firstWhere((c) => c.type == type);
    } catch (_) {
      return null;
    }
  }
}
