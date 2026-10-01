import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/models/pokemon.dart';
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
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('Ivysaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.text('Product details'), findsNothing);
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
