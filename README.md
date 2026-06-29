# Life Simulator

Juego simulador de vida estilo BitLife para Android. Vive una vida completa desde el nacimiento hasta la muerte: toma decisiones, desarrolla carreras, acumula riqueza, forma una familia y deja un legado.

## Características

- **11 carreras**: Deportes, Negocios, Influencer, Música, Actuación, Política, Inversiones, Crimen, Medicina, Tecnología, Educación
- **Stats dinámicos**: Salud, inteligencia, carisma, atletismo, reputación, felicidad, estrés, disciplina
- **Sistema económico**: Salarios, activos, propiedades, inversiones, deudas, patrimonio neto
- **Motor de eventos**: 25+ eventos con decisiones y consecuencias que afectan tu partida
- **Relaciones y familia**: Afinidad, matrimonio, hijos, herencias
- **Guardado persistente**: Guarda y carga tu progreso en cualquier momento
- **Logros**: Millonario, leyenda, centenario y más
- **Legado**: Posibilidad de continuar con la siguiente generación

## Requisitos

- Android 5.0 (API 21) o superior
- ~50 MB de espacio

## Instalación

Descarga el APK desde [Releases](https://github.com/bydavidp/AppLife/releases) e instálalo en tu dispositivo Android.

## Compilar desde código fuente

```bash
flutter pub get
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Tecnologías

- **Flutter** - Framework UI multiplataforma
- **Dart** - Lenguaje de programación
- **SQLite** (vía path_provider) - Persistencia local
- **Arquitectura limpia**: Separación domain/engine/data/persistence/ui
