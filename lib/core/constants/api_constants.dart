/// API endpoints and base URL constants
class ApiConstants {
  ApiConstants._(); // Private constructor to prevent instantiation

  /// Base URL for PokeAPI
  static const String baseUrl = 'pokeapi.co';

  /// API version prefix
  static const String apiVersion = 'api/v2';

  /// Endpoint paths
  static const String generationPath = '$apiVersion/generation';
  static const String pokemonSpeciesPath = '$apiVersion/pokemon-species';
  static const String pokemonPath = '$apiVersion/pokemon';
  static const String evolutionChainPath = '$apiVersion/evolution-chain';

  /// Complete endpoint URLs
  static String generation(int generationId) =>
      '$generationPath/$generationId/';
  static String pokemonSpecies(int id) => '$pokemonSpeciesPath/$id';
  static String pokemon(String nameOrId) => '$pokemonPath/$nameOrId';
  static String evolutionChain(int id) => '$evolutionChainPath/$id';
}
