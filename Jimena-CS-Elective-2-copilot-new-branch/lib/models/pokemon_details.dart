class PokemonDetails {
  const PokemonDetails({
    required this.description,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.stats,
  });

  final String description;
  final List<String> types;
  // PokéAPI measures height in decimeters and weight in hectograms.
  final int height;
  final int weight;
  final List<String> abilities;
  final List<PokemonStat> stats;
}

class PokemonStat {
  const PokemonStat({required this.name, required this.value});

  final String name;
  final int value;
}
