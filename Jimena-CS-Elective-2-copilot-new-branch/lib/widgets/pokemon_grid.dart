import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonGrid extends StatelessWidget {
  const PokemonGrid({
    super.key,
    required this.pokemon,
    this.onPokemonTap,
  });

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
        itemCount: pokemon.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) => PokemonCard(
          pokemon: pokemon[index],
          onTap: onPokemonTap,
        ),
      );
    },
  );
}

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon, this.onTap});

  final Pokemon pokemon;
  final void Function(Pokemon pokemon)? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => onTap?.call(pokemon),
    borderRadius: BorderRadius.circular(12),
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator.adaptive()),
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
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
