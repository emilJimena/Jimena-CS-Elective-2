import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_grid.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProvider>().fetchPokemon();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
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
        actions: [
          IconButton(
            onPressed: provider.refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Pokémon',
          ),
        ],
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
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : provider.hasError
                      ? _MessageState(
                          icon: Icons.cloud_off_outlined,
                          title: 'Could not load Pokémon',
                          message: 'Check your internet connection and try again.',
                          actionLabel: 'Try again',
                          onAction: provider.refresh,
                        )
                      : provider.pokemon.isEmpty
                          ? const _MessageState(
                              icon: Icons.search_off_outlined,
                              title: 'No Pokémon found',
                              message: 'The PokéAPI did not return any Pokémon.',
                            )
                          : PokemonGrid(
                              pokemon: provider.pokemon,
                              onPokemonTap: (Pokemon pokemon) {
                                provider.selectPokemon(pokemon);
                                Navigator.pushNamed(context, '/detail');
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
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
