import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/models/pokemon.dart';
import 'package:flutter_application_1/pages/pokedex_page.dart';
import 'package:flutter_application_1/pages/pokemon_detail_page.dart';
import 'package:flutter_application_1/providers/pokemon_provider.dart';

void main() {
  testWidgets('shows loading state then renders Pokémon from app state', (
    tester,
  ) async {
    final completer = Completer<List<Pokemon>>();
    final provider = PokemonProvider(
      fetchPokemon: () => completer.future,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: PokedexPage()),
      ),
    );

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(const [
      Pokemon(id: 1, name: 'bulbasaur'),
      Pokemon(id: 2, name: 'ivysaur'),
    ]);
    await tester.pump();

    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('Ivysaur'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
  });

  testWidgets('shows an empty state when the provider has no Pokémon', (
    tester,
  ) async {
    final provider = PokemonProvider(fetchPokemon: () async => const <Pokemon>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: PokedexPage()),
      ),
    );

    await tester.pump();

    expect(find.text('No Pokémon found'), findsOneWidget);
  });

  testWidgets('shows an error state and retry action when provider fetch fails', (
    tester,
  ) async {
    final provider = PokemonProvider(fetchPokemon: () async => throw Exception('offline'));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: PokedexPage()),
      ),
    );

    await tester.pump();

    expect(find.text('Could not load Pokémon'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('navigates to the detail page and shows info from provider state', (
    tester,
  ) async {
    final provider = PokemonProvider(
      fetchPokemon: () async => const [Pokemon(id: 25, name: 'pikachu')],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: const PokedexPage(),
          routes: {
            '/detail': (context) => const PokemonDetailPage(),
          },
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.text('Pikachu'));
    await tester.pumpAndSettle();

    expect(find.text('Pikachu'), findsWidgets);
    expect(find.text('#025'), findsOneWidget);
  });
}
