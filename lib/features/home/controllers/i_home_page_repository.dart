// Interface for Home Page Controller

import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';

abstract class IHomePageRepository {
  Future<Catalog> getPokemon(int geracao);
  Future<Pokemon> getPokemonDetail(Pokemon pokemon);
}
