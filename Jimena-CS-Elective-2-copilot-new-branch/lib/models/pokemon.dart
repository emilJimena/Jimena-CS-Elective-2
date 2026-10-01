class Pokemon {
  const Pokemon({required this.id, required this.name});

  final int id;
  final String name;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'];

    if (name is! String || url is! String) {
      throw const FormatException('Pokémon data is missing a name or URL.');
    }

    final pathParts = Uri.parse(url).pathSegments;
    final idPart = pathParts.isNotEmpty && pathParts.last.isEmpty
        ? pathParts[pathParts.length - 2]
        : pathParts.last;
    final id = int.tryParse(idPart);

    if (id == null) {
      throw const FormatException('Pokémon URL does not contain a valid ID.');
    }

    return Pokemon(id: id, name: name);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
