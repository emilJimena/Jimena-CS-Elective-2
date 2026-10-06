import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';

class PokemonDetailPage extends StatelessWidget {
  const PokemonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();
    final Pokemon? pokemon = provider.selectedPokemon;

    if (pokemon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pokémon')),
        body: const Center(child: Text('No Pokémon selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDC3545),
        foregroundColor: Colors.white,
        title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
      ),
      body: Center(
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
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '#${pokemon.id.toString().padLeft(3, '0')}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
