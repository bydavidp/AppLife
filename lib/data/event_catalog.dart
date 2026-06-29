import '../domain/models/game_event.dart';
import '../domain/enums/event_type.dart';

class EventCatalog {
  static final List<GameEvent> allEvents = [
    // --- Childhood Events ---
    GameEvent(
      id: 'birthday_party',
      type: EventType.social,
      title: 'Fiesta de cumpleaños',
      description: 'Tus padres te organizan una fiesta de cumpleaños. ¿Invitas a todos tus amigos?',
      minAge: 4,
      maxAge: 15,
      oneTime: false,
      choices: [
        EventChoice(
          text: 'Invitar a todos',
          statEffects: {'happiness': 10, 'charisma': 2},
          reputationEffect: 2,
        ),
        EventChoice(
          text: 'Solo a los mejores amigos',
          statEffects: {'happiness': 5, 'charisma': 1},
        ),
      ],
    ),
    GameEvent(
      id: 'school_test',
      type: EventType.school,
      title: 'Examen sorpresa',
      description: 'Tu profesor anuncia un examen sorpresa. No has estudiado mucho.',
      minAge: 8,
      maxAge: 18,
      oneTime: false,
      statRequirements: {'intelligence': 30},
      choices: [
        EventChoice(
          text: 'Estudiar toda la noche',
          statEffects: {'intelligence': 3, 'stress': 15, 'discipline': 3},
          reputationEffect: 3,
        ),
        EventChoice(
          text: 'Copiar del compañero',
          statEffects: {'intelligence': -2, 'reputation': -5, 'stress': -10},
          careerExperience: 5,
        ),
        EventChoice(
          text: 'Hacer lo que puedas',
          statEffects: {'stress': 5},
        ),
      ],
    ),
    GameEvent(
      id: 'sports_competition',
      type: EventType.sports,
      title: 'Competencia deportiva escolar',
      description: 'Hay una competencia deportiva en la escuela. ¿Te inscribes?',
      minAge: 8,
      maxAge: 18,
      statRequirements: {'athleticism': 30},
      choices: [
        EventChoice(
          text: 'Participar y esforzarme al máximo',
          statEffects: {'athleticism': 5, 'reputation': 3, 'happiness': 5},
          reputationEffect: 3,
        ),
        EventChoice(
          text: 'Participar sin esforzarme',
          statEffects: {'athleticism': 1, 'happiness': 2},
        ),
        EventChoice(
          text: 'No participar',
          statEffects: {'discipline': -2},
        ),
      ],
    ),
    GameEvent(
      id: 'bullying',
      type: EventType.school,
      title: 'Problemas con bullying',
      description: 'Un grupo de compañeros te está molestando en la escuela.',
      minAge: 8,
      maxAge: 16,
      oneTime: false,
      choices: [
        EventChoice(
          text: 'Enfrentarlos',
          statEffects: {'athleticism': 2, 'reputation': 5, 'stress': 10},
        ),
        EventChoice(
          text: 'Ignorarlos',
          statEffects: {'discipline': 3, 'happiness': -5},
        ),
        EventChoice(
          text: 'Decírselo a un profesor',
          statEffects: {'intelligence': 1, 'reputation': 2},
        ),
      ],
    ),

    // --- Teen / Young Adult Events ---
    GameEvent(
      id: 'first_job',
      type: EventType.work,
      title: 'Primer trabajo',
      description: 'Un vecino te ofrece un trabajo de medio tiempo. ¿Lo aceptas?',
      minAge: 14,
      maxAge: 20,
      choices: [
        EventChoice(
          text: 'Aceptar el trabajo',
          statEffects: {'discipline': 3, 'stress': 5},
          moneyEffect: 2000,
          careerExperience: 10,
        ),
        EventChoice(
          text: 'Rechazarlo, prefiero estudiar',
          statEffects: {'intelligence': 3, 'discipline': 2},
        ),
      ],
    ),
    GameEvent(
      id: 'university_choice',
      type: EventType.lifeMilestone,
      title: 'Elección de universidad',
      description: 'Es hora de elegir qué estudiar en la universidad. Esta decisión definirá tu futuro.',
      minAge: 17,
      maxAge: 20,
      oneTime: true,
      statRequirements: {'intelligence': 40},
      choices: [
        EventChoice(
          text: 'Medicina',
          statEffects: {'intelligence': 10, 'stress': 15, 'discipline': 5},
          careerGranted: 'medical',
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Negocios',
          statEffects: {'intelligence': 8, 'charisma': 5},
          careerGranted: 'business',
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Tecnología',
          statEffects: {'intelligence': 10, 'discipline': 3},
          careerGranted: 'tech',
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Artes',
          statEffects: {'charisma': 8, 'appearance': 3},
          careerGranted: 'music',
          careerExperience: 20,
        ),
        EventChoice(
          text: 'No ir a la universidad',
          statEffects: {'stress': -10, 'happiness': 5, 'discipline': -3},
        ),
      ],
    ),
    GameEvent(
      id: 'gym_invitation',
      type: EventType.social,
      title: 'Invitación al gimnasio',
      description: 'Un amigo te invita a unirte a su gimnasio. Podrías ponerte en forma.',
      minAge: 15,
      maxAge: 60,
      choices: [
        EventChoice(
          text: 'Unirme y entrenar duro',
          statEffects: {'athleticism': 5, 'appearance': 3, 'health': 3, 'discipline': 3},
          moneyEffect: -500,
        ),
        EventChoice(
          text: 'Ir de vez en cuando',
          statEffects: {'athleticism': 2, 'appearance': 1},
          moneyEffect: -200,
        ),
        EventChoice(
          text: 'No me interesa',
          statEffects: {},
        ),
      ],
    ),
    GameEvent(
      id: 'romance_opportunity',
      type: EventType.romantic,
      title: 'Oportunidad romántica',
      description: 'Alguien muestra interés en ti. Es atractivo y parece tener buena personalidad.',
      minAge: 16,
      maxAge: 60,
      statRequirements: {'charisma': 25, 'appearance': 20},
      choices: [
        EventChoice(
          text: 'Invitarle a salir',
          statEffects: {'charisma': 3, 'happiness': 10},
          reputationEffect: 5,
        ),
        EventChoice(
          text: 'Ser solo amigos',
          statEffects: {'charisma': 1, 'happiness': 3},
        ),
        EventChoice(
          text: 'Rechazar la oportunidad',
          statEffects: {},
        ),
      ],
    ),

    // --- Career Events ---
    GameEvent(
      id: 'promotion_opportunity',
      type: EventType.work,
      title: 'Oportunidad de ascenso',
      description: 'Tu jefe te ofrece un ascenso. Viene con más responsabilidad y mejor salario.',
      minAge: 22,
      maxAge: 65,
      careerRequired: 'business',
      statRequirements: {'intelligence': 50, 'charisma': 40},
      choices: [
        EventChoice(
          text: 'Aceptar el ascenso',
          statEffects: {'stress': 15, 'reputation': 5},
          moneyEffect: 20000,
          careerExperience: 30,
        ),
        EventChoice(
          text: 'Rechazarlo, prefiero estabilidad',
          statEffects: {'stress': -10, 'happiness': 5},
        ),
      ],
    ),
    GameEvent(
      id: 'sports_talent_spotted',
      type: EventType.sports,
      title: 'Talento deportivo descubierto',
      description: 'Un cazatalentos te ha visto jugar. Quiere que firmes con un club profesional.',
      minAge: 16,
      maxAge: 30,
      statRequirements: {'athleticism': 60},
      choices: [
        EventChoice(
          text: 'Firmar el contrato profesional',
          statEffects: {'athleticism': 5, 'stress': 15, 'reputation': 15},
          moneyEffect: 50000,
          careerGranted: 'sports',
          careerExperience: 50,
        ),
        EventChoice(
          text: 'Pedir tiempo para pensarlo',
          statEffects: {'stress': 5},
        ),
        EventChoice(
          text: 'Rechazar, prefiero estudiar',
          statEffects: {'intelligence': 3},
        ),
      ],
    ),
    GameEvent(
      id: 'sports_injury',
      type: EventType.sports,
      title: 'Lesión deportiva',
      description: 'Durante un partido importante, sufres una lesión grave.',
      minAge: 16,
      maxAge: 45,
      careerRequired: 'sports',
      choices: [
        EventChoice(
          text: 'Operarme y rehabilitarme',
          statEffects: {'health': -10, 'athleticism': -5, 'discipline': 5, 'stress': 20},
          moneyEffect: -10000,
        ),
        EventChoice(
          text: 'Seguir jugando con dolor',
          statEffects: {'health': -20, 'athleticism': -2, 'reputation': 3},
        ),
        EventChoice(
          text: 'Retirarme del deporte',
          statEffects: {'happiness': -15, 'health': 5, 'stress': -20},
        ),
      ],
    ),
    GameEvent(
      id: 'business_opportunity',
      type: EventType.financial,
      title: 'Oportunidad de negocio',
      description: 'Un socio te propone invertir en un nuevo negocio prometedor.',
      minAge: 20,
      maxAge: 70,
      moneyRequired: 20000,
      statRequirements: {'intelligence': 45, 'charisma': 35},
      choices: [
        EventChoice(
          text: 'Invertir agresivamente',
          statEffects: {'stress': 20, 'reputation': 10},
          moneyEffect: -50000,
          careerExperience: 40,
        ),
        EventChoice(
          text: 'Invertir una cantidad modesta',
          statEffects: {'stress': 10},
          moneyEffect: -10000,
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Rechazar la oportunidad',
          statEffects: {'stress': -5},
        ),
      ],
    ),
    GameEvent(
      id: 'stock_market',
      type: EventType.financial,
      title: 'El mercado de valores',
      description: 'Has oído rumores sobre una acción que podría dispararse. ¿Inviertes?',
      minAge: 18,
      maxAge: 80,
      moneyRequired: 5000,
      choices: [
        EventChoice(
          text: 'Invertir una fortuna',
          statEffects: {'stress': 25, 'intelligence': 3},
          moneyEffect: -30000,
          careerExperience: 15,
        ),
        EventChoice(
          text: 'Invertir un poco',
          statEffects: {'stress': 10, 'intelligence': 2},
          moneyEffect: -5000,
          careerExperience: 10,
        ),
        EventChoice(
          text: 'No invertir, es muy arriesgado',
          statEffects: {'stress': -5},
        ),
      ],
    ),
    GameEvent(
      id: 'crime_opportunity',
      type: EventType.crime,
      title: 'Oportunidad ilegal',
      description: 'Un conocido te propone un negocio turbio pero muy lucrativo.',
      minAge: 16,
      maxAge: 60,
      statRequirements: {'discipline': 20},
      choices: [
        EventChoice(
          text: 'Aceptar la propuesta',
          statEffects: {'reputation': -15, 'stress': 20, 'discipline': -5},
          moneyEffect: 40000,
          careerGranted: 'crime',
          careerExperience: 30,
        ),
        EventChoice(
          text: 'Rechazarla firmemente',
          statEffects: {'reputation': 5, 'discipline': 3},
        ),
        EventChoice(
          text: 'Denunciarlo a la policía',
          statEffects: {'reputation': 10, 'stress': 5},
        ),
      ],
    ),
    GameEvent(
      id: 'political_career',
      type: EventType.work,
      title: 'Carrera política',
      description: 'Un partido político te ofrece postularte para un cargo local.',
      minAge: 25,
      maxAge: 70,
      statRequirements: {'charisma': 50, 'reputation': 40, 'intelligence': 40},
      choices: [
        EventChoice(
          text: 'Aceptar y comenzar mi carrera política',
          statEffects: {'reputation': 15, 'stress': 20, 'charisma': 5},
          careerGranted: 'politics',
          careerExperience: 40,
        ),
        EventChoice(
          text: 'Rechazar la oferta',
          statEffects: {'reputation': 2},
        ),
      ],
    ),
    GameEvent(
      id: 'influencer_opportunity',
      type: EventType.work,
      title: 'Oportunidad de influencer',
      description: 'Tu contenido en redes sociales está ganando tracción. Una marca quiere patrocinarte.',
      minAge: 14,
      maxAge: 50,
      statRequirements: {'charisma': 35, 'appearance': 25},
      moneyRequired: 0,
      choices: [
        EventChoice(
          text: 'Aceptar el patrocinio y dedicarme a esto',
          statEffects: {'charisma': 5, 'reputation': 10, 'stress': 15},
          moneyEffect: 10000,
          careerGranted: 'influencer',
          careerExperience: 30,
        ),
        EventChoice(
          text: 'Aceptar pero mantener mi trabajo actual',
          statEffects: {'charisma': 3, 'reputation': 5, 'stress': 10},
          moneyEffect: 5000,
          careerExperience: 15,
        ),
        EventChoice(
          text: 'Rechazar, no me interesa la fama',
          statEffects: {},
        ),
      ],
    ),

    // --- Life Events ---
    GameEvent(
      id: 'marriage_proposal',
      type: EventType.romantic,
      title: 'Propuesta de matrimonio',
      description: 'Tu pareja te dice que está lista para el siguiente paso. ¿Le propones matrimonio?',
      minAge: 20,
      maxAge: 70,
      statRequirements: {'charisma': 30, 'happiness': 40},
      choices: [
        EventChoice(
          text: 'Proponer matrimonio',
          statEffects: {'happiness': 20, 'stress': 10, 'reputation': 5},
          moneyEffect: -15000,
        ),
        EventChoice(
          text: 'Esperar un poco más',
          statEffects: {'happiness': -5, 'stress': -5},
        ),
        EventChoice(
          text: 'Terminar la relación',
          statEffects: {'happiness': -20, 'stress': 10, 'reputation': -5},
        ),
      ],
    ),
    GameEvent(
      id: 'having_child',
      type: EventType.family,
      title: '¡Bebé en camino!',
      description: 'Tu pareja está embarazada. Pronto serás padre/madre.',
      minAge: 20,
      maxAge: 55,
      choices: [
        EventChoice(
          text: 'Estar emocionado y prepararme',
          statEffects: {'happiness': 15, 'stress': 15, 'discipline': 3},
          moneyEffect: -5000,
        ),
        EventChoice(
          text: 'Estar nervioso pero aceptarlo',
          statEffects: {'happiness': 10, 'stress': 20},
          moneyEffect: -3000,
        ),
        EventChoice(
          text: 'Entrar en pánico',
          statEffects: {'happiness': -5, 'stress': 30},
        ),
      ],
    ),
    GameEvent(
      id: 'inheritance',
      type: EventType.family,
      title: 'Herencia familiar',
      description: 'Un familiar falleció y te ha dejado una herencia.',
      minAge: 25,
      maxAge: 80,
      choices: [
        EventChoice(
          text: 'Aceptar la herencia',
          statEffects: {'happiness': 5, 'stress': -5},
          moneyEffect: 100000,
        ),
        EventChoice(
          text: 'Donarla a una causa benéfica',
          statEffects: {'reputation': 20, 'happiness': 10},
        ),
      ],
    ),
    GameEvent(
      id: 'lottery',
      type: EventType.financial,
      title: '¡Ganaste la lotería!',
      description: 'El boleto que compraste por casualidad resultó ganador.',
      minAge: 18,
      maxAge: 90,
      choices: [
        EventChoice(
          text: 'Cobrar el premio completo',
          statEffects: {'happiness': 30, 'stress': -20, 'discipline': -5},
          moneyEffect: 500000,
        ),
        EventChoice(
          text: 'Invertir la mayor parte',
          statEffects: {'intelligence': 5, 'stress': -10},
          moneyEffect: 300000,
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Mantenerlo en secreto',
          statEffects: {'stress': 10, 'reputation': -5},
          moneyEffect: 500000,
        ),
      ],
    ),
    GameEvent(
      id: 'midlife_crisis',
      type: EventType.random,
      title: 'Crisis de mediana edad',
      description: 'Llegaste a cierta edad y cuestionas todo lo que has logrado.',
      minAge: 38,
      maxAge: 55,
      choices: [
        EventChoice(
          text: 'Comprar un auto deportivo',
          statEffects: {'happiness': 10, 'stress': -10},
          moneyEffect: -50000,
        ),
        EventChoice(
          text: 'Empezar un nuevo hobby',
          statEffects: {'happiness': 15, 'stress': -15, 'discipline': 3},
        ),
        EventChoice(
          text: 'Ignorar esos pensamientos',
          statEffects: {'stress': 5, 'happiness': -5},
        ),
      ],
    ),
    GameEvent(
      id: 'health_scare',
      type: EventType.medical,
      title: 'Alerta de salud',
      description: 'En un chequeo médico encuentran algo preocupante.',
      minAge: 35,
      maxAge: 90,
      choices: [
        EventChoice(
          text: 'Seguir el tratamiento completo',
          statEffects: {'health': 15, 'stress': 10, 'money': -20000},
          moneyEffect: -20000,
        ),
        EventChoice(
          text: 'Buscar segundas opiniones',
          statEffects: {'health': 5, 'stress': 15},
          moneyEffect: -5000,
        ),
        EventChoice(
          text: 'Ignorarlo',
          statEffects: {'health': -15, 'stress': -5},
        ),
      ],
    ),
    GameEvent(
      id: 'investment_windfall',
      type: EventType.financial,
      title: 'Inversión exitosa',
      description: 'Una de tus inversiones dio frutos inesperados.',
      minAge: 20,
      maxAge: 90,
      moneyRequired: 10000,
      choices: [
        EventChoice(
          text: 'Reinvertir las ganancias',
          statEffects: {'intelligence': 3, 'stress': 5},
          moneyEffect: 50000,
          careerExperience: 20,
        ),
        EventChoice(
          text: 'Retirar y disfrutar el dinero',
          statEffects: {'happiness': 10, 'stress': -10},
          moneyEffect: 30000,
        ),
      ],
    ),
    GameEvent(
      id: 'retirement',
      type: EventType.lifeMilestone,
      title: 'Jubilación',
      description: 'Después de una larga carrera, es momento de jubilarse.',
      minAge: 60,
      maxAge: 90,
      oneTime: true,
      choices: [
        EventChoice(
          text: 'Jubilarme y disfrutar la vida',
          statEffects: {'happiness': 20, 'stress': -30, 'health': 5},
        ),
        EventChoice(
          text: 'Seguir trabajando medio tiempo',
          statEffects: {'stress': -15, 'happiness': 10, 'discipline': 3},
        ),
        EventChoice(
          text: 'Emprender algo nuevo',
          statEffects: {'stress': -10, 'happiness': 15, 'intelligence': 3},
        ),
      ],
    ),
    GameEvent(
      id: 'divorce',
      type: EventType.romantic,
      title: 'Problemas matrimoniales',
      description: 'Tu matrimonio está pasando por una crisis seria.',
      minAge: 25,
      maxAge: 80,
      choices: [
        EventChoice(
          text: 'Ir a terapia de pareja',
          statEffects: {'happiness': 10, 'stress': 5, 'charisma': 3},
          moneyEffect: -3000,
        ),
        EventChoice(
          text: 'Separarnos',
          statEffects: {'happiness': -15, 'stress': 15, 'reputation': -5},
          moneyEffect: -50000,
        ),
        EventChoice(
          text: 'Ignorar el problema',
          statEffects: {'happiness': -10, 'stress': 10},
        ),
      ],
    ),

    // --- Crime events ---
    GameEvent(
      id: 'police_raid',
      type: EventType.crime,
      title: 'Redada policial',
      description: 'La policía está investigando tus actividades. Tienes que tomar decisiones.',
      minAge: 16,
      maxAge: 80,
      careerRequired: 'crime',
      choices: [
        EventChoice(
          text: 'Esconder todo y cooperar',
          statEffects: {'stress': 20, 'reputation': 5, 'intelligence': 3},
          moneyEffect: -10000,
        ),
        EventChoice(
          text: 'Usar tus contactos para resolverlo',
          statEffects: {'stress': 15, 'reputation': -5},
          moneyEffect: -50000,
        ),
        EventChoice(
          text: 'Huír de la ciudad',
          statEffects: {'happiness': -20, 'stress': 30, 'reputation': -20},
          moneyEffect: -20000,
        ),
      ],
    ),

    // --- Education events ---
    GameEvent(
      id: 'scholarship',
      type: EventType.school,
      title: 'Beca académica',
      description: 'Por tu rendimiento académico, te ofrecen una beca completa.',
      minAge: 16,
      maxAge: 22,
      statRequirements: {'intelligence': 60},
      choices: [
        EventChoice(
          text: 'Aceptar la beca',
          statEffects: {'intelligence': 5, 'reputation': 10, 'happiness': 10},
          careerExperience: 15,
        ),
        EventChoice(
          text: 'Rechazarla y trabajar',
          statEffects: {'discipline': 3},
          moneyEffect: 10000,
        ),
      ],
    ),
  ];
}
