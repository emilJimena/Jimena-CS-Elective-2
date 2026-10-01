# flutter_application_1

## Pokédex

A small Flutter app that fetches the first 30 Pokémon from the PokéAPI and shows
their ID, name, and official artwork in a responsive, scrollable grid.

## Run

Run `flutter pub get`, then `flutter run`.

## How it is organized

- `lib/models/pokemon.dart` defines one Pokémon and its artwork URL.
- `lib/services/pokemon_service.dart` makes the API request and converts JSON.
- `lib/pages/pokedex_page.dart` loads the list and handles loading, error, and
	empty states.
- `lib/widgets/pokemon_grid.dart` displays the responsive grid and cards.
- `lib/main.dart` starts the app.

The list uses a `Future` because it is one request that returns one finite
result. A `Stream` would be more suitable for data that keeps arriving or
updating over time, which this Pokédex does not need.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
