import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/models/pokemon.dart';
import 'package:flutter_application_1/models/pokemon_details.dart';
import 'package:flutter_application_1/pages/pokedex_page.dart';

void main() {
  testWidgets('renders a Pokédex grid without a details screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 720);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: PokedexPage(
          loadPokemon: () async => const [
            Pokemon(id: 1, name: 'bulbasaur'),
            Pokemon(id: 2, name: 'ivysaur'),
          ],
          loadPokemonDetails: (id) async => const PokemonDetails(
            description: 'A strange seed was planted on its back at birth.',
            types: ['grass', 'poison'],
            height: 7,
            weight: 69,
            abilities: ['overgrow'],
            stats: [PokemonStat(name: 'hp', value: 45)],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('Ivysaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);

    await tester.tap(find.text('Bulbasaur'));
    await tester.pumpAndSettle();

    expect(find.text('POKÉDEX DESCRIPTION'), findsOneWidget);
    expect(
      find.text('A strange seed was planted on its back at birth.'),
      findsOneWidget,
    );
    expect(find.text('Overgrow'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows an empty state when the API returns no Pokémon', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PokedexPage(loadPokemon: () async => const <Pokemon>[]),
      ),
    );
    await tester.pump();

    expect(find.text('No Pokémon found'), findsOneWidget);
  });

  testWidgets('shows an error message and retry action on failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PokedexPage(loadPokemon: () async => throw Exception('offline')),
      ),
    );
    await tester.pump();

    expect(find.text('Could not load Pokémon'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}
