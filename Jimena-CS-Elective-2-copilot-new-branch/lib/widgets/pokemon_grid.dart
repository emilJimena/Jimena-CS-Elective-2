import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class PokemonGrid extends StatelessWidget {
  const PokemonGrid({super.key, required this.pokemon, this.onPokemonTap});

  final List<Pokemon> pokemon;
  final void Function(Pokemon pokemon)? onPokemonTap;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = switch (constraints.maxWidth) {
        < 360 => 2,
        < 700 => 3,
        < 1000 => 4,
        _ => 5,
      };

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: pokemon.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) =>
            PokemonCard(pokemon: pokemon[index], onTap: onPokemonTap),
      );
    },
  );
}

class PokemonCard extends ConsumerWidget {
  const PokemonCard({super.key, required this.pokemon, this.onTap});

  final Pokemon pokemon;
  final void Function(Pokemon pokemon)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexStateProvider);
    final nickname = state.nicknameFor(pokemon);
    final isFavorite = state.favorites.contains(pokemon.id);
    return InkWell(
      onTap: () => onTap?.call(pokemon),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                    onPressed: () => ref
                        .read(pokedexStateProvider.notifier)
                        .toggleFavorite(pokemon),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                      size: 20,
                    ),
                  ),
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.catching_pokemon,
                      size: 56,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: Text(
                  _capitalize(pokemon.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (nickname != null)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '“$nickname”',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (pokemon.types.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    pokemon.types.map(_capitalize).join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
