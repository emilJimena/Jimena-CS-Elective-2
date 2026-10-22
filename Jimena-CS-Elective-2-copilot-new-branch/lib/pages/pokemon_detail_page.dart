import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/nickname_editor_dialog.dart';

class PokemonDetailPage extends ConsumerWidget {
  const PokemonDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Pokemon? pokemon = ref.watch(pokedexStateProvider).selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pokémon')),
        body: const Column(
          children: [
            SizedBox(height: 12),
            FavoritesPanel(),
            Expanded(child: Center(child: Text('No Pokémon selected.'))),
          ],
        ),
      );
    }
    final state = ref.watch(pokedexStateProvider);
    final nickname = state.nicknameFor(pokemon);
    final isFavorite = state.favorites.contains(pokemon.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC3545),
        foregroundColor: Colors.white,
        title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const FavoritesPanel(),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        pokemon.imageUrl,
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.catching_pokemon,
                          size: 120,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _capitalize(pokemon.name),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (nickname != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Nickname: $nickname',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (pokemon.types.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Type: ${pokemon.types.map(_capitalize).join(' · ')}',
                        ),
                      ],
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          FilledButton.icon(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) =>
                                  NicknameEditorDialog(pokemon: pokemon),
                            ),
                            icon: const Icon(Icons.edit),
                            label: Text(
                              nickname == null
                                  ? 'Add nickname'
                                  : 'Edit nickname',
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () => ref
                                .read(pokedexStateProvider.notifier)
                                .toggleFavorite(pokemon),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            label: Text(
                              isFavorite ? 'Favorited' : 'Add favorite',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
