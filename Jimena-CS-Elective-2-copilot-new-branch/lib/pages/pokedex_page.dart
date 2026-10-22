import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/favorites_panel.dart';
import '../widgets/pokemon_grid.dart';

class PokedexPage extends ConsumerWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonListProvider);
    final state = ref.watch(pokedexStateProvider);
    final types = ref.watch(pokemonTypesProvider);
    final selectableTypes = {
      ...types,
      if (state.selectedType != null) state.selectedType!,
    }.toList()..sort();
    final filteredPokemon = ref.watch(filteredPokemonProvider);

    Future<void> refreshPokemon() =>
        ref.read(pokemonListProvider.notifier).fetch();

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
            onPressed: refreshPokemon,
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
            const FavoritesPanel(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: state.selectedType ?? '',
                      isExpanded: true,
                      menuMaxHeight: 280,
                      decoration: const InputDecoration(
                        labelText: 'Filter by type',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All types'),
                        ),
                        ...selectableTypes.map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(_capitalize(type)),
                          ),
                        ),
                      ],
                      onChanged: (type) => ref
                          .read(pokedexStateProvider.notifier)
                          .setTypeFilter(
                            type == null || type.isEmpty ? null : type,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshPokemon,
                child: pokemonAsync.when(
                  loading: () => const _ScrollableMessage(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  error: (error, stackTrace) => _ScrollableMessage(
                    child: _MessageState(
                      icon: Icons.cloud_off_outlined,
                      title: 'Could not load Pokémon',
                      message:
                          'Check your internet connection and pull down to retry.',
                      actionLabel: 'Try again',
                      onAction: refreshPokemon,
                    ),
                  ),
                  data: (pokemon) => pokemon.isEmpty
                      ? const _ScrollableMessage(
                          child: _MessageState(
                            icon: Icons.search_off_outlined,
                            title: 'No Pokémon found',
                            message: 'The PokéAPI did not return any Pokémon.',
                          ),
                        )
                      : filteredPokemon.isEmpty
                      ? _ScrollableMessage(
                          child: _MessageState(
                            icon: Icons.filter_alt_off,
                            title: 'No Pokémon match this type',
                            message: 'Choose another type or clear the filter.',
                            actionLabel: 'Clear filter',
                            onAction: () => ref
                                .read(pokedexStateProvider.notifier)
                                .setTypeFilter(null),
                          ),
                        )
                      : PokemonGrid(
                          pokemon: filteredPokemon,
                          onPokemonTap: (Pokemon selectedPokemon) {
                            ref
                                .read(pokedexStateProvider.notifier)
                                .selectPokemon(selectedPokemon);
                            Navigator.pushNamed(context, '/detail');
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [SizedBox(height: 320, child: child)],
  );
}

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

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
