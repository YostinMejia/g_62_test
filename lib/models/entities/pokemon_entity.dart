class PokemonEntity {
  final String name;
  final String url;
  PokemonDetails? details;

  PokemonEntity({
    required this.name,
    required this.url,
    this.details,
  });

  factory PokemonEntity.fromJson(Map<String, dynamic> json) {
    return PokemonEntity(
      name: json["name"],
      url: json["url"],
      details: json["detail"] != null 
          ? PokemonDetails.fromJson(json["detail"]) 
          : null,
    );
  }
}

class PokemonDetails {
  final int id;
  final List<PokemonType> types;
  final int height;
  final int weight;
  final String spriteUrl;

  PokemonDetails({
    required this.id,
    required this.types,
    required this.height,
    required this.weight,
    required this.spriteUrl,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    return PokemonDetails(
      id: json["id"],
      height: json["height"],
      weight: json["weight"],
      spriteUrl: json["sprites"]["front_default"],
      types: List<PokemonType>.from(
        json["types"].map((type) => PokemonType.fromJson(type)),
      ),
    );
  }

  String get primaryType => types.isNotEmpty ? types[0].name : 'unknown';
  String? get secondaryType => types.length > 1 ? types[1].name : null;
}

class PokemonType {
  final String name;
  final String url;

  PokemonType({
    required this.name,
    required this.url,
  });

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      name: json["type"]["name"],
      url: json["type"]["url"],
    );
  }
}