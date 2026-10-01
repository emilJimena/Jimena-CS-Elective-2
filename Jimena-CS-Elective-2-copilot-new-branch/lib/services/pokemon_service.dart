import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const _pokemonUrl = 'https://pokeapi.co/api/v2/pokemon';
  static const _pokemonLimit = 30;

  static Future<List<Pokemon>> fetchFirstThirty() async {
    final uri = Uri.parse(
      _pokemonUrl,
    ).replace(queryParameters: {'limit': '$_pokemonLimit'});
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw PokemonApiException(
        'PokéAPI returned status code ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['results'] is! List) {
      throw const FormatException('PokéAPI returned an unexpected response.');
    }

    final results = decoded['results'] as List<dynamic>;
    return results
        .map((result) {
          if (result is! Map<String, dynamic>) {
            throw const FormatException(
              'PokéAPI returned invalid Pokémon data.',
            );
          }
          return Pokemon.fromJson(result);
        })
        .toList(growable: false);
  }
}

class PokemonApiException implements Exception {
  const PokemonApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
