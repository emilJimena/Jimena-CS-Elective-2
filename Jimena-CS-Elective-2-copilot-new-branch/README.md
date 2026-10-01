# Pokédex

A Flutter app that fetches the first 30 Pokémon from PokéAPI. Tap any grid card
to open a trading-card-inspired page with its description, type, abilities,
measurements, and base stats.

## Run

Run `flutter pub get`, then `flutter run`.

## Folder structure

- `lib/models/` — Pokémon list and detail data models.
- `lib/services/` — PokéAPI requests and JSON parsing.
- `lib/pages/` — Pokédex list and Pokémon detail screens.
- `lib/widgets/` — responsive grid and Pokémon cards.
- `lib/theme/` — shared app styling.
- `lib/main.dart` — app entry point.

Each API request uses a `Future` because it returns one finite result. A
`Stream` would be better for continuous updates or data arriving over time.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
