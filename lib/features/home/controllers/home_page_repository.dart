import 'dart:convert';

import 'package:http/http.dart';
import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/core/utils/utils.dart';
import 'package:pokemon/features/home/controllers/i_home_page_repository.dart';

class HomePageRepository implements IHomePageRepository {
  final Client client;

  HomePageRepository(this.client);

  @override
  Future<Catalog> getPokemon(int generation) async {
    final url = Uri.https(baseUrl, 'api/v2/generation/$generation/');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar geração: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final pokemons = (data['pokemon_species'] as List<dynamic>)
        .map<Pokemon?>((pokemon) {
          final urlParts = (pokemon['url'] as String).split('pokemon-species/');
          final id = int.tryParse(urlParts.last.split('/').first);
          return id != null ? Pokemon(id: id, name: pokemon['name']) : null;
        })
        .whereType<Pokemon>()
        .toList();

    pokemons.sort((a, b) => a.id.compareTo(b.id));

    await Future.wait([
      ...pokemons.map(fetchPokemonDetails),
      ...pokemons.map(getPokemonDetail),
    ]);

    return Catalog(pokemons: pokemons);
  }

  Future<void> fetchPokemonDetails(Pokemon pokemon) async {
    final url = Uri.https(baseUrl, '$urlPokemons2/${pokemon.name}');
    final response = await client.get(url);

    if (response.statusCode != 200) return;

    final map = jsonDecode(response.body);

    const typesList = [
      "normal",
      "fighting",
      "flying",
      "poison",
      "ground",
      "rock",
      "bug",
      "ghost",
      "fire",
      "water",
      "grass",
      "electric",
      "psychic",
      "ice",
      "dragon",
      "fairy",
      "dark",
      "steel",
      "unknown",
      "shadow",
    ];

    pokemon.types = (map['types'] as List?)
        ?.map((x) => x['type']?['name']?.toString() ?? '')
        .where((type) => typesList.contains(type))
        .toList();

    final sprites = map['sprites'] as Map<String, dynamic>?;

    pokemon.height = map['height'] as int?;
    pokemon.weight = map['weight'] as int?;
    pokemon.abilities = (map['abilities'] as List?)
        ?.map((x) => x['ability']?['name']?.toString() ?? '')
        .toList();
    pokemon.status = (map['stats'] as List?)
        ?.map((x) => x['base_stat'] as int? ?? 0)
        .toList();

    if (sprites != null) {
      final dream =
          sprites['other']?['dream_world']?['front_default'] as String?;
      final front = sprites['front_default'] as String?;
      if (dream != null) (pokemon.sprites ??= []).add(dream);
      if (front != null) (pokemon.sprites ??= []).add(front);
    }
  }

  @override
  Future<Pokemon> getPokemonDetail(Pokemon pokemon) async {
    final url = Uri.https(baseUrl, '$urlPokemons1/${pokemon.id}');
    final response = await client.get(url);

    if (response.statusCode != 200) return pokemon;

    final map = jsonDecode(response.body);
    pokemon.color = map['color']?['name'];
    pokemon.evolutionUrl = map['evolution_chain']['url'];

    final evolutionId = int.tryParse(
      pokemon.evolutionUrl!.split('/').where((e) => e.isNotEmpty).last,
    );

    if (evolutionId == null) return pokemon;

    final evolutionResponse = await client.get(
      Uri.https(baseUrl, '$urlPokemons3/$evolutionId'),
    );

    if (evolutionResponse.statusCode != 200) return pokemon;

    final chain = jsonDecode(evolutionResponse.body)['chain'];

    final List<String> evolutionNames = [];

    final baseSpecies = chain['species']?['name'];
    if (baseSpecies != null) {
      evolutionNames.add(baseSpecies);
    }

    final firstEvolve = (chain['evolves_to'] as List?)?.firstOrNull;
    if (firstEvolve != null) {
      final firstSpecies = firstEvolve['species']?['name'];
      if (firstSpecies != null) {
        evolutionNames.add(firstSpecies);
      }

      final secondEvolve = (firstEvolve['evolves_to'] as List?)?.firstOrNull;
      if (secondEvolve != null) {
        final secondSpecies = secondEvolve['species']?['name'];
        if (secondSpecies != null) {
          evolutionNames.add(secondSpecies);
        }
      }
    }

    for (final name in evolutionNames.whereType<String>()) {
      final evoPokemon = Pokemon(id: 0, name: name, sprites: [], types: []);
      final detailUrl = Uri.https(baseUrl, '$urlPokemons2/$name');
      final detailResp = await client.get(detailUrl);

      if (detailResp.statusCode == 200) {
        final evoMap = jsonDecode(detailResp.body);

        evoPokemon.id = evoMap['id'];
        evoPokemon.types = (evoMap['types'] as List?)
            ?.map((x) => x['type']?['name']?.toString() ?? '')
            .toList();

        final evoSprites = evoMap['sprites'] as Map<String, dynamic>?;
        if (evoSprites != null) {
          final front =
              evoSprites['other']?['dream_world']?['front_default'] as String?;
          if (front != null) (pokemon.sprites ??= []).add(front);
          evoPokemon.sprites = [front ?? ''];
        }
      } else {
        evoPokemon.id = 0; // Fallback ID if detail fetch fails
      }
      pokemon.evolutions ??= [];
      pokemon.evolutions!.add(evoPokemon);
    }
    return pokemon;
  }
}
