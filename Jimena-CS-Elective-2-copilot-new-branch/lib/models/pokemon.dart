class Pokemon {
  const Pokemon({required this.id, required this.name, this.types = const []});

  final int id;
  final String name;
  final List<String> types;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'];
    final rawId = json['id'];

    if (name is! String) {
      throw const FormatException('Pokémon data is missing a name.');
    }

    final idFromUrl = url is String ? _idFromUrl(url) : null;
    final id = rawId is int ? rawId : idFromUrl;

    if (id == null) {
      throw const FormatException('Pokémon URL does not contain a valid ID.');
    }

    final rawTypes = json['types'];
    final types = rawTypes is List
        ? rawTypes
              .whereType<Map<String, dynamic>>()
              .map((type) => type['type'])
              .whereType<Map<String, dynamic>>()
              .map((type) => type['name'])
              .whereType<String>()
              .toList(growable: false)
        : const <String>[];

    return Pokemon(id: id, name: name, types: types);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  static int? _idFromUrl(String url) {
    final pathParts = Uri.parse(url).pathSegments;
    if (pathParts.isEmpty) return null;
    final idPart = pathParts.last.isEmpty
        ? (pathParts.length > 1 ? pathParts[pathParts.length - 2] : null)
        : pathParts.last;
    return idPart == null ? null : int.tryParse(idPart);
  }
}
