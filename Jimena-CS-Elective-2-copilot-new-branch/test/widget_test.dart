import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/models/pokemon.dart';
import 'package:flutter_application_1/pages/pokedex_page.dart';
import 'package:flutter_application_1/pages/pokemon_detail_page.dart';
import 'package:flutter_application_1/providers/pokemon_provider.dart';

void main() {
  test('parses ID and actual types from a PokéAPI detail record', () {
    final pokemon = Pokemon.fromJson({
      'id': 6,
      'name': 'charizard',
      'types': [
        {
          'slot': 1,
          'type': {'name': 'fire', 'url': 'https://pokeapi.co/api/v2/type/10/'},
        },
        {
          'slot': 2,
          'type': {
            'name': 'flying',
            'url': 'https://pokeapi.co/api/v2/type/3/',
          },
        },
      ],
    });

    expect(pokemon.id, 6);
    expect(pokemon.name, 'charizard');
    expect(pokemon.types, ['fire', 'flying']);
  });

  test('fetch method reloads Pokémon through the configured fetcher', () async {
    var fetchCount = 0;
    final container = ProviderContainer(
      overrides: [
        pokemonFetcherProvider.overrideWithValue(() async {
          fetchCount++;
          return [Pokemon(id: fetchCount, name: 'pokemon-$fetchCount')];
        }),
      ],
    );
    addTearDown(container.dispose);

    await container.read(pokemonListProvider.future);
    await container.read(pokemonListProvider.notifier).fetch();

    expect(fetchCount, 2);
    expect(container.read(pokemonListProvider).requireValue.single.id, 2);
  });

  test(
    'Riverpod state manages nicknames, favorites, and type filtering',
    () async {
      const pokemon = [
        Pokemon(id: 4, name: 'charmander', types: ['fire']),
        Pokemon(id: 7, name: 'squirtle', types: ['water']),
      ];
      final container = ProviderContainer(
        overrides: [
          pokemonFetcherProvider.overrideWithValue(() async => pokemon),
        ],
      );
      addTearDown(container.dispose);

      await container.read(pokemonListProvider.future);
      final state = container.read(pokedexStateProvider.notifier);
      state.setNickname(pokemon[0], 'Blaze');
      state.toggleFavorite(pokemon[0]);
      state.setTypeFilter('fire');

      expect(
        container.read(pokedexStateProvider).nicknameFor(pokemon[0]),
        'Blaze',
      );
      expect(container.read(favoritePokemonProvider), [pokemon[0]]);
      expect(container.read(filteredPokemonProvider), [pokemon[0]]);

      state.setNickname(pokemon[0], null);
      state.toggleFavorite(pokemon[0]);
      state.setTypeFilter(null);

      expect(
        container.read(pokedexStateProvider).nicknameFor(pokemon[0]),
        isNull,
      );
      expect(container.read(favoritePokemonProvider), isEmpty);
      expect(container.read(filteredPokemonProvider), pokemon);
    },
  );

  testWidgets('shows loading state then renders Pokémon from app state', (
    tester,
  ) async {
    final completer = Completer<List<Pokemon>>();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonFetcherProvider.overrideWithValue(() => completer.future),
        ],
        child: const MaterialApp(home: PokedexPage()),
      ),
    );

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(const [
      Pokemon(id: 1, name: 'bulbasaur', types: ['grass', 'poison']),
      Pokemon(id: 2, name: 'ivysaur', types: ['grass', 'poison']),
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonFetcherProvider.overrideWithValue(
            () async => const <Pokemon>[],
          ),
        ],
        child: const MaterialApp(home: PokedexPage()),
      ),
    );

    await tester.pump();

    expect(find.text('No Pokémon found'), findsOneWidget);
  });

  testWidgets(
    'shows an error state and retry action when provider fetch fails',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pokemonFetcherProvider.overrideWithValue(
              () async => throw Exception('offline'),
            ),
          ],
          child: const MaterialApp(home: PokedexPage()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Could not load Pokémon'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    },
  );

  testWidgets(
    'navigates to the detail page and shows info from provider state',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pokemonFetcherProvider.overrideWithValue(
              () async => const [
                Pokemon(id: 25, name: 'pikachu', types: ['electric']),
              ],
            ),
          ],
          child: MaterialApp(
            home: const PokedexPage(),
            routes: {'/detail': (context) => const PokemonDetailPage()},
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.text('Pikachu'));
      await tester.pumpAndSettle();

      expect(find.text('Pikachu'), findsWidgets);
      expect(find.text('#025'), findsOneWidget);
    },
  );
}
