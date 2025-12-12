import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:pokemon/core/constants/api_constants.dart';
import 'package:pokemon/core/constants/pokemon_types.dart';
import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/features/home/controllers/i_home_page_repository.dart';

/// Repository implementation for Pokemon data fetching
///
/// This class handles all HTTP requests to the PokeAPI
class HomePageRepository implements IHomePageRepository {
  final Client client;

  HomePageRepository(this.client);

  @override
  Future<Catalog> getPokemon(int generation) async {
    try {
      final url = Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.generation(generation),
      );
      final response = await client.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch generation $generation: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final pokemonSpeciesList = data['pokemon_species'] as List<dynamic>?;

      if (pokemonSpeciesList == null) {
        return const Catalog(pokemons: []);
      }

      var pokemons = pokemonSpeciesList
          .map<Pokemon?>((pokemon) {
            try {
              final url = pokemon['url'] as String;
              final urlParts = url.split('pokemon-species/');
              final id = int.tryParse(urlParts.last.split('/').first);
              final name = pokemon['name'] as String;

              return id != null ? Pokemon(id: id, name: name) : null;
            } catch (e) {
              debugPrint('Error parsing pokemon: $e');
              return null;
            }
          })
          .whereType<Pokemon>()
          .toList();

      // Sort by ID
      pokemons.sort((a, b) => a.id.compareTo(b.id));

      // Fetch details for all Pokemon in parallel
      final detailedPokemons = await Future.wait(
        pokemons.map((pokemon) async {
          var updated = pokemon;
          updated = await _fetchPokemonDetails(updated);
          updated = await getPokemonDetail(updated);
          return updated;
        }),
      );

      return Catalog(pokemons: detailedPokemons);
    } catch (e) {
      debugPrint('Error in getPokemon: $e');
      rethrow;
    }
  }

  /// Fetches basic Pokemon details (sprites, types, stats, etc.)
  Future<Pokemon> _fetchPokemonDetails(Pokemon pokemon) async {
    try {
      final url = Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.pokemon(pokemon.name),
      );
      final response = await client.get(url);

      if (response.statusCode != 200) {
        debugPrint(
          'Failed to fetch details for ${pokemon.name}: ${response.statusCode}',
        );
        return pokemon;
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;

      // Extract types
      final typesData = map['types'] as List<dynamic>?;
      final types = typesData
          ?.map((x) => x['type']?['name']?.toString() ?? '')
          .where((type) => PokemonTypes.isValidType(type))
          .toList();

      // Extract sprites
      final spritesData = map['sprites'] as Map<String, dynamic>?;
      List<String>? sprites;
      if (spritesData != null) {
        final dreamWorld =
            spritesData['other']?['dream_world']?['front_default'] as String?;
        final frontDefault = spritesData['front_default'] as String?;

        if (dreamWorld != null || frontDefault != null) {
          sprites = [];
          if (dreamWorld != null) sprites.add(dreamWorld);
          if (frontDefault != null) sprites.add(frontDefault);
        }
      }

      // Extract abilities
      final abilitiesData = map['abilities'] as List<dynamic>?;
      final abilities = abilitiesData
          ?.map((x) => x['ability']?['name']?.toString() ?? '')
          .where((ability) => ability.isNotEmpty)
          .toList();

      // Extract stats
      final statsData = map['stats'] as List<dynamic>?;
      final stats = statsData?.map((x) => x['base_stat'] as int? ?? 0).toList();

      return pokemon.copyWith(
        types: types,
        sprites: sprites,
        height: map['height'] as int?,
        weight: map['weight'] as int?,
        abilities: abilities,
        stats: stats,
      );
    } catch (e) {
      debugPrint('Error fetching details for ${pokemon.name}: $e');
      return pokemon;
    }
  }

  @override
  Future<Pokemon> getPokemonDetail(Pokemon pokemon) async {
    try {
      final url = Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.pokemonSpecies(pokemon.id),
      );
      final response = await client.get(url);

      if (response.statusCode != 200) {
        debugPrint(
          'Failed to fetch species for ${pokemon.name}: ${response.statusCode}',
        );
        return pokemon;
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;

      // Extract color
      final color = map['color']?['name'] as String?;

      // Extract evolution chain URL
      final evolutionChain = map['evolution_chain'] as Map<String, dynamic>?;
      final evolutionUrl = evolutionChain?['url'] as String?;

      if (evolutionUrl == null) {
        return pokemon.copyWith(color: color);
      }

      // Fetch evolution chain
      final evolutions = await _fetchEvolutionChain(evolutionUrl);

      return pokemon.copyWith(
        color: color,
        evolutionUrl: evolutionUrl,
        evolutions: evolutions,
      );
    } catch (e) {
      debugPrint('Error getting pokemon detail for ${pokemon.name}: $e');
      return pokemon;
    }
  }

  /// Fetches and processes the evolution chain for a Pokemon
  Future<List<Pokemon?>> _fetchEvolutionChain(String evolutionUrl) async {
    try {
      final evolutionId = int.tryParse(
        evolutionUrl.split('/').where((e) => e.isNotEmpty).last,
      );

      if (evolutionId == null) return [];

      final url = Uri.https(
        ApiConstants.baseUrl,
        ApiConstants.evolutionChain(evolutionId),
      );
      final response = await client.get(url);

      if (response.statusCode != 200) {
        debugPrint('Failed to fetch evolution chain: ${response.statusCode}');
        return [];
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final chain = data['chain'] as Map<String, dynamic>?;

      if (chain == null) return [];

      // Extract evolution names
      final evolutionNames = <String>[];

      // Base species
      final baseSpecies = chain['species']?['name'] as String?;
      if (baseSpecies != null) evolutionNames.add(baseSpecies);

      // First evolution
      final firstEvolve =
          (chain['evolves_to'] as List<dynamic>?)?.firstOrNull
              as Map<String, dynamic>?;
      if (firstEvolve != null) {
        final firstSpecies = firstEvolve['species']?['name'] as String?;
        if (firstSpecies != null) evolutionNames.add(firstSpecies);

        // Second evolution
        final secondEvolve =
            (firstEvolve['evolves_to'] as List<dynamic>?)?.firstOrNull
                as Map<String, dynamic>?;
        if (secondEvolve != null) {
          final secondSpecies = secondEvolve['species']?['name'] as String?;
          if (secondSpecies != null) evolutionNames.add(secondSpecies);
        }
      }

      // Fetch details for each evolution
      final evolutions = await Future.wait(
        evolutionNames.map((name) => _fetchEvolutionPokemon(name)),
      );

      return evolutions;
    } catch (e) {
      debugPrint('Error fetching evolution chain: $e');
      return [];
    }
  }

  /// Fetches a Pokemon in the evolution chain
  Future<Pokemon?> _fetchEvolutionPokemon(String name) async {
    try {
      final url = Uri.https(ApiConstants.baseUrl, ApiConstants.pokemon(name));
      final response = await client.get(url);

      if (response.statusCode != 200) {
        debugPrint('Failed to fetch evolution pokemon $name');
        return null;
      }

      final map = jsonDecode(response.body) as Map<String, dynamic>;

      final id = map['id'] as int? ?? 0;
      final typesData = map['types'] as List<dynamic>?;
      final types = typesData
          ?.map((x) => x['type']?['name']?.toString() ?? '')
          .where((type) => type.isNotEmpty)
          .toList();

      final sprites = map['sprites'] as Map<String, dynamic>?;
      final dreamWorld =
          sprites?['other']?['dream_world']?['front_default'] as String?;

      return Pokemon(
        id: id,
        name: name,
        types: types,
        sprites: dreamWorld != null ? [dreamWorld] : null,
      );
    } catch (e) {
      debugPrint('Error fetching evolution pokemon $name: $e');
      return null;
    }
  }
}
