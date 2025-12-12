import 'package:flutter/foundation.dart';

/// Pokemon model class representing a Pokemon entity
///
/// This class contains all the information about a Pokemon including
/// its basic data, sprites, types, stats, and evolution chain.
@immutable
class Pokemon {
  /// Creates a Pokemon instance
  const Pokemon({
    required this.id,
    required this.name,
    this.color,
    this.sprites,
    this.types,
    this.height,
    this.weight,
    this.abilities,
    this.stats,
    this.evolutionUrl,
    this.evolutions,
  });

  /// Pokemon's unique identifier
  final int id;

  /// Pokemon's name
  final String name;

  /// Pokemon's primary color (e.g., 'red', 'blue')
  final String? color;

  /// List of sprite URLs for the Pokemon's images
  final List<String>? sprites;

  /// List of Pokemon types (e.g., 'fire', 'water')
  final List<String>? types;

  /// Pokemon's height in decimeters
  final int? height;

  /// Pokemon's weight in hectograms
  final int? weight;

  /// List of Pokemon's ability names
  final List<String>? abilities;

  /// List of base stats [HP, Attack, Defense, Special Attack, Special Defense, Speed]
  final List<int>? stats;

  /// URL to the evolution chain endpoint
  final String? evolutionUrl;

  /// List of Pokemon in the evolution chain
  final List<Pokemon?>? evolutions;

  /// Creates a copy of this Pokemon with the given fields replaced with new values
  Pokemon copyWith({
    int? id,
    String? name,
    String? color,
    List<String>? sprites,
    List<String>? types,
    int? height,
    int? weight,
    List<String>? abilities,
    List<int>? stats,
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
    stats: stats ?? this.stats,
    evolutionUrl: evolutionUrl ?? this.evolutionUrl,
    evolutions: evolutions ?? this.evolutions,
  );

  /// Converts this Pokemon to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'sprites': sprites,
      'types': types,
      'height': height,
      'weight': weight,
      'abilities': abilities,
      'stats': stats,
      'evolutionUrl': evolutionUrl,
      'evolutions': evolutions?.map((e) => e?.toJson()).toList(),
    };
  }

  /// Creates a Pokemon from a JSON map
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      color: json['color'] as String?,
      sprites: (json['sprites'] as List<dynamic>?)?.cast<String>(),
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      abilities: (json['abilities'] as List<dynamic>?)?.cast<String>(),
      stats: (json['stats'] as List<dynamic>?)?.cast<int>(),
      evolutionUrl: json['evolutionUrl'] as String?,
      evolutions: (json['evolutions'] as List<dynamic>?)
          ?.map(
            (e) =>
                e != null ? Pokemon.fromJson(e as Map<String, dynamic>) : null,
          )
          .toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pokemon &&
        other.id == id &&
        other.name == name &&
        other.color == color &&
        listEquals(other.sprites, sprites) &&
        listEquals(other.types, types) &&
        other.height == height &&
        other.weight == weight &&
        listEquals(other.abilities, abilities) &&
        listEquals(other.stats, stats) &&
        other.evolutionUrl == evolutionUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      color,
      Object.hashAll(sprites ?? []),
      Object.hashAll(types ?? []),
      height,
      weight,
      Object.hashAll(abilities ?? []),
      Object.hashAll(stats ?? []),
      evolutionUrl,
    );
  }

  @override
  String toString() {
    return 'Pokemon(id: $id, name: $name, types: $types)';
  }
}
