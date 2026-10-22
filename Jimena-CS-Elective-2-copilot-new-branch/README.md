# flutter_application_1

## Pokédex

A Flutter app that fetches the first 30 Pokémon from the PokéAPI and shows their
ID, original name, official artwork, and actual types in a responsive grid.
Use Riverpod to refresh the list, filter by type, assign nicknames, and manage
favorites.

## Run

Run `flutter pub get`, then `flutter run`.

## How it is organized

- `lib/models/pokemon.dart` defines one Pokémon and its artwork URL.
- `lib/services/pokemon_service.dart` makes the API request and converts JSON.
- `lib/providers/pokemon_provider.dart` manages async list fetching and all
	Pokédex interaction state with Riverpod.
- `lib/pages/pokedex_page.dart` handles loading/error/empty states, refresh,
	type filtering, and the expandable favorites panel.
- `lib/pages/pokemon_detail_page.dart` displays Pokémon details and nickname and
	favorite controls.
- `lib/widgets/pokemon_grid.dart` displays responsive cards and favorite hearts.
- `lib/widgets/nickname_editor_dialog.dart` edits or removes custom nicknames.
- `lib/widgets/favorites_panel.dart` shows the expandable, live favorites list.
- `lib/main.dart` starts the app inside a Riverpod `ProviderScope`.

The app uses a Riverpod `AsyncNotifier` for asynchronous Pokémon loading and a
Riverpod `Notifier` for nicknames, favorites, the selected Pokémon, and the type
filter. The service fetches each Pokémon's detail record to get its actual type
data for filtering.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
