import 'pokemon.dart';

/// Catalog model representing a collection of Pokemon
///
/// This class is used to group Pokemon together, typically
/// representing all Pokemon from a specific generation.
class Catalog {
  /// Creates a catalog with a list of Pokemon
  const Catalog({this.pokemons = const []});

  /// List of Pokemon in this catalog
  final List<Pokemon> pokemons;

  /// Creates a copy of this Catalog with the given fields replaced
  Catalog copyWith({List<Pokemon>? pokemons}) {
    return Catalog(pokemons: pokemons ?? this.pokemons);
  }

  /// Converts this Catalog to a JSON map
  Map<String, dynamic> toJson() {
    return {'pokemons': pokemons.map((p) => p.toJson()).toList()};
  }

  /// Creates a Catalog from a JSON map
  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      pokemons:
          (json['pokemons'] as List<dynamic>?)
              ?.map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
