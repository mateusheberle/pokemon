const String notLoaded = 'not loaded...';

class Pokemon {
  Pokemon({
    required this.id,
    required this.name,
    this.color,
    this.sprites,
    this.types,
    this.height,
    this.weight,
    this.abilities,
    this.status,
    this.evolutionUrl,
    this.evolutions,
  });

  int id;
  String name;
  String? color;
  List<String>? sprites;
  List<String>? types;
  int? height;
  int? weight;
  List<String>? abilities;
  List<int>? status;
  String? evolutionUrl;
  List<Pokemon?>? evolutions;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'sprites': sprites,
      'types': types,
      'height': height,
      'weight': weight,
      'abilities': abilities,
      'status': status,
      'evolution': evolutionUrl,
      'evolutions': evolutions,
    };
  }

  Pokemon copyWith({
    int? id,
    String? name,
    String? color,
    List<String>? sprites,
    List<String>? types,
    int? height,
    int? weight,
    List<String>? abilities,
    List<int>? status,
    String? evolutionUrl,
    List<Pokemon?>? evolutions,
  }) => Pokemon(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    sprites: sprites ?? this.sprites,
    types: types ?? this.types,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    abilities: abilities ?? this.abilities,
    status: status ?? this.status,
    evolutionUrl: evolutionUrl ?? this.evolutionUrl,
    evolutions: evolutions ?? this.evolutions,
  );
}
