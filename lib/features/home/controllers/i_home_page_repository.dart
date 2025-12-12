import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';

/// Interface for Home Page Repository
///
/// This interface defines the contract for fetching Pokemon data
/// from external sources (API).
abstract class IHomePageRepository {
  /// Fetches all Pokemon from a specific generation
  ///
  /// Returns a [Catalog] containing all Pokemon from the specified [generation]
  /// Throws an exception if the request fails
  Future<Catalog> getPokemon(int generation);

  /// Fetches detailed information for a specific Pokemon
  ///
  /// Returns the updated [Pokemon] with additional details like color,
  /// evolution chain, etc.
  Future<Pokemon> getPokemonDetail(Pokemon pokemon);
}
