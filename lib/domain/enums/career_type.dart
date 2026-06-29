enum CareerType {
  unemployed,
  student,
  sports,
  business,
  influencer,
  music,
  acting,
  politics,
  investment,
  crime,
  medical,
  tech,
  education;

  String get displayName {
    switch (this) {
      case CareerType.unemployed:
        return 'Desempleado';
      case CareerType.student:
        return 'Estudiante';
      case CareerType.sports:
        return 'Deportista';
      case CareerType.business:
        return 'Empresario';
      case CareerType.influencer:
        return 'Influencer';
      case CareerType.music:
        return 'Músico';
      case CareerType.acting:
        return 'Actor';
      case CareerType.politics:
        return 'Político';
      case CareerType.investment:
        return 'Inversor';
      case CareerType.crime:
        return 'Criminal';
      case CareerType.medical:
        return 'Médico';
      case CareerType.tech:
        return 'Tecnología';
      case CareerType.education:
        return 'Educación';
    }
  }
}
