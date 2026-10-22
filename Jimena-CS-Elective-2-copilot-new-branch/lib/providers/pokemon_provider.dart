import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

final pokemonFetcherProvider = Provider<Future<List<Pokemon>> Function()>(
  (ref) => PokemonService.fetchFirstThirty,
);

final pokemonListProvider =
    AsyncNotifierProvider<PokemonListNotifier, List<Pokemon>>(
      PokemonListNotifier.new,
    );

class PokemonListNotifier extends AsyncNotifier<List<Pokemon>> {
  @override
  Future<List<Pokemon>> build() => ref.read(pokemonFetcherProvider)();

  Future<void> fetch() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(pokemonFetcherProvider)());
  }
}

final pokedexStateProvider =
    NotifierProvider<PokedexStateNotifier, PokedexState>(
      PokedexStateNotifier.new,
    );

class PokedexState {
  const PokedexState({
    this.selectedPokemon,
    this.nicknames = const {},
    this.favorites = const {},
    this.selectedType,
  });

  final Pokemon? selectedPokemon;
  final Map<int, String> nicknames;
  final Set<int> favorites;
  final String? selectedType;

  String? nicknameFor(Pokemon pokemon) => nicknames[pokemon.id];

  PokedexState copyWith({
    Pokemon? selectedPokemon,
    bool clearSelection = false,
    Map<int, String>? nicknames,
    Set<int>? favorites,
    String? selectedType,
    bool clearType = false,
  }) => PokedexState(
    selectedPokemon: clearSelection
        ? null
        : selectedPokemon ?? this.selectedPokemon,
    nicknames: nicknames ?? this.nicknames,
    favorites: favorites ?? this.favorites,
    selectedType: clearType ? null : selectedType ?? this.selectedType,
  );
}

class PokedexStateNotifier extends Notifier<PokedexState> {
  @override
  PokedexState build() => const PokedexState();

  void selectPokemon(Pokemon pokemon) =>
      state = state.copyWith(selectedPokemon: pokemon);

  void setNickname(Pokemon pokemon, String? nickname) {
    final updated = Map<int, String>.from(state.nicknames);
    final cleaned = nickname?.trim() ?? '';
    if (cleaned.isEmpty) {
      updated.remove(pokemon.id);
    } else {
      updated[pokemon.id] = cleaned;
    }
    state = state.copyWith(nicknames: updated);
  }

  void toggleFavorite(Pokemon pokemon) {
    final updated = Set<int>.from(state.favorites);
    if (!updated.add(pokemon.id)) updated.remove(pokemon.id);
    state = state.copyWith(favorites: updated);
  }

  void setTypeFilter(String? type) =>
      state = state.copyWith(selectedType: type, clearType: type == null);

  void clearSelection() => state = state.copyWith(clearSelection: true);
}

final filteredPokemonProvider = Provider<List<Pokemon>>((ref) {
  final pokemon =
      ref.watch(pokemonListProvider).asData?.value ?? const <Pokemon>[];
  final selectedType = ref.watch(pokedexStateProvider).selectedType;
  if (selectedType == null) return pokemon;
  return pokemon
      .where((item) => item.types.contains(selectedType))
      .toList(growable: false);
});

final favoritePokemonProvider = Provider<List<Pokemon>>((ref) {
  final pokemon =
      ref.watch(pokemonListProvider).asData?.value ?? const <Pokemon>[];
  final favorites = ref.watch(pokedexStateProvider).favorites;
  return pokemon.where((item) => favorites.contains(item.id)).toList();
});

final pokemonTypesProvider = Provider<List<String>>((ref) {
  return const [
    'normal',
    'fire',
    'water',
    'grass',
    'electric',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dragon',
    'dark',
    'steel',
    'fairy',
  ];
});
