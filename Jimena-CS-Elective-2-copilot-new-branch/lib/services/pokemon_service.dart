import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';
import '../models/pokemon_details.dart';

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

  static Future<PokemonDetails> fetchDetails(int pokemonId) async {
    final pokemonUri = Uri.parse('$_pokemonUrl/$pokemonId');
    final speciesUri = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon-species/$pokemonId',
    );
    final responses = await Future.wait([
      _getJson(pokemonUri),
      _getJson(speciesUri),
    ]);
    final pokemonData = responses[0];
    final speciesData = responses[1];

    final types = _asList(pokemonData['types'], 'types')
        .map((entry) => _asMap(entry, 'type entry'))
        .map((entry) => _asMap(entry['type'], 'type'))
        .map((type) => _asString(type['name'], 'type name'))
        .toList(growable: false);
    final abilities = _asList(pokemonData['abilities'], 'abilities')
        .map((entry) => _asMap(entry, 'ability entry'))
        .map((entry) => _asMap(entry['ability'], 'ability'))
        .map((ability) => _asString(ability['name'], 'ability name'))
        .toList(growable: false);
    final stats = _asList(pokemonData['stats'], 'stats')
        .map((entry) => _asMap(entry, 'stat entry'))
        .map(
          (entry) => PokemonStat(
            name: _asString(_asMap(entry['stat'], 'stat')['name'], 'stat name'),
            value: entry['base_stat'] is int
                ? entry['base_stat'] as int
                : throw const FormatException('Pokémon stat is invalid.'),
          ),
        )
        .toList(growable: false);

    return PokemonDetails(
      description: _englishDescription(speciesData),
      types: types,
      height: _asInt(pokemonData['height'], 'height'),
      weight: _asInt(pokemonData['weight'], 'weight'),
      abilities: abilities,
      stats: stats,
    );
  }

  static Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw PokemonApiException(
        'PokéAPI returned status code ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('PokéAPI returned an unexpected response.');
    }
    return decoded;
  }

  static String _englishDescription(Map<String, dynamic> speciesData) {
    final entries = _asList(speciesData['flavor_text_entries'], 'descriptions');
    for (final entry in entries) {
      final entryMap = _asMap(entry, 'description entry');
      final language = _asMap(entryMap['language'], 'description language');
      if (language['name'] == 'en' && entryMap['flavor_text'] is String) {
        return (entryMap['flavor_text'] as String)
            .replaceAll(RegExp(r'[\n\f]+'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
      }
    }
    return 'No Pokédex description is available.';
  }

  static List<dynamic> _asList(dynamic value, String field) {
    if (value is List<dynamic>) return value;
    throw FormatException('PokéAPI returned invalid $field data.');
  }

  static Map<String, dynamic> _asMap(dynamic value, String field) {
    if (value is Map<String, dynamic>) return value;
    throw FormatException('PokéAPI returned invalid $field data.');
  }

  static String _asString(dynamic value, String field) {
    if (value is String) return value;
    throw FormatException('PokéAPI returned an invalid $field.');
  }

  static int _asInt(dynamic value, String field) {
    if (value is int) return value;
    throw FormatException('PokéAPI returned an invalid $field.');
  }
}

class PokemonApiException implements Exception {
  const PokemonApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
