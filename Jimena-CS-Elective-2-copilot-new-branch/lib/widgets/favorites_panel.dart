import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class FavoritesPanel extends ConsumerWidget {
  const FavoritesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexStateProvider);
    final favorites = ref.watch(favoritePokemonProvider);
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ExpansionTile(
        leading: const Icon(Icons.favorite, color: Colors.red),
        title: Text('Favorites (${state.favorites.length})'),
        children: [
          if (favorites.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Text('No Pokémon have been favorited yet.'),
            )
          else
            SizedBox(
              height: favorites.length > 3 ? 220 : favorites.length * 70.0,
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final pokemon = favorites[index];
                  return ListTile(
                    leading: Image.network(
                      pokemon.imageUrl,
                      width: 42,
                      height: 42,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.catching_pokemon),
                    ),
                    title: Text(_displayName(pokemon, state)),
                    subtitle: Text(_capitalize(pokemon.name)),
                    trailing: IconButton(
                      tooltip: 'Remove from favorites',
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () => ref
                          .read(pokedexStateProvider.notifier)
                          .toggleFavorite(pokemon),
                    ),
                    onTap: () {
                      ref
                          .read(pokedexStateProvider.notifier)
                          .selectPokemon(pokemon);
                      Navigator.pushNamed(context, '/detail');
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

String _displayName(Pokemon pokemon, PokedexState state) =>
    state.nicknameFor(pokemon) ?? _capitalize(pokemon.name);

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
