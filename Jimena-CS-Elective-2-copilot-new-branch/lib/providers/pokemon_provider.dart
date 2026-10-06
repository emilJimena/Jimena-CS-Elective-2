import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider extends ChangeNotifier {
  PokemonProvider({Future<List<Pokemon>> Function()? fetchPokemon})
      : _fetchPokemon = fetchPokemon ?? PokemonService.fetchFirstThirty;

  final Future<List<Pokemon>> Function() _fetchPokemon;

  List<Pokemon> _pokemon = const <Pokemon>[];
  bool _isLoading = false;
  String? _errorMessage;
  Pokemon? _selectedPokemon;

  List<Pokemon> get pokemon => _pokemon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  Pokemon? get selectedPokemon => _selectedPokemon;

  Future<void> fetchPokemon() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedPokemon = await _fetchPokemon();
      _pokemon = loadedPokemon;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => fetchPokemon();

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }

  void clearSelection() {
    _selectedPokemon = null;
    notifyListeners();
  }
}
