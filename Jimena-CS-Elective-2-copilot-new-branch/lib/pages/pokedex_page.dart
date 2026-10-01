import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../models/pokemon_details.dart';
import '../services/pokemon_service.dart';
import 'pokemon_detail_page.dart';
import '../widgets/pokemon_grid.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({
    super.key,
    this.loadPokemon = PokemonService.fetchFirstThirty,
    this.loadPokemonDetails = PokemonService.fetchDetails,
  });

  final Future<List<Pokemon>> Function() loadPokemon;
  final Future<PokemonDetails> Function(int id) loadPokemonDetails;

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  late Future<List<Pokemon>> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = widget.loadPokemon();
  }

  void _retry() {
    setState(() => _pokemonFuture = widget.loadPokemon());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFDC3545),
      foregroundColor: Colors.white,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.catching_pokemon, size: 29),
          SizedBox(width: 8),
          Text('Pokédex', style: TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Column(
              children: [
                Text(
                  'Meet the first 30 Pokémon',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 5),
                Text(
                  'Browse the original Pokédex collection.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pokemon>>(
              future: _pokemonFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (snapshot.hasError) {
                  return _MessageState(
                    icon: Icons.cloud_off_outlined,
                    title: 'Could not load Pokémon',
                    message: 'Check your internet connection and try again.',
                    actionLabel: 'Try again',
                    onAction: _retry,
                  );
                }

                final pokemon = snapshot.data ?? const <Pokemon>[];
                if (pokemon.isEmpty) {
                  return const _MessageState(
                    icon: Icons.search_off_outlined,
                    title: 'No Pokémon found',
                    message: 'The PokéAPI did not return any Pokémon.',
                  );
                }

                return PokemonGrid(
                  pokemon: pokemon,
                  onPokemonTap: (selectedPokemon) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => PokemonDetailPage(
                          pokemon: selectedPokemon,
                          loadDetails: widget.loadPokemonDetails,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(message, textAlign: TextAlign.center),
          if (actionLabel != null) ...[
            const SizedBox(height: 14),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    ),
  );
}
