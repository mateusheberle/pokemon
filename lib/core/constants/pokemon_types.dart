/// Pokemon type constants
class PokemonTypes {
  PokemonTypes._(); // Private constructor to prevent instantiation

  static const String normal = 'normal';
  static const String fighting = 'fighting';
  static const String flying = 'flying';
  static const String poison = 'poison';
  static const String ground = 'ground';
  static const String rock = 'rock';
  static const String bug = 'bug';
  static const String ghost = 'ghost';
  static const String fire = 'fire';
  static const String water = 'water';
  static const String grass = 'grass';
  static const String electric = 'electric';
  static const String psychic = 'psychic';
  static const String ice = 'ice';
  static const String dragon = 'dragon';
  static const String fairy = 'fairy';
  static const String dark = 'dark';
  static const String steel = 'steel';
  static const String unknown = 'unknown';
  static const String shadow = 'shadow';

  /// List of all valid Pokemon types
  static const List<String> allTypes = [
    normal,
    fighting,
    flying,
    poison,
    ground,
    rock,
    bug,
    ghost,
    fire,
    water,
    grass,
    electric,
    psychic,
    ice,
    dragon,
    fairy,
    dark,
    steel,
    unknown,
    shadow,
  ];

  /// Check if a type is valid
  static bool isValidType(String type) => allTypes.contains(type.toLowerCase());
}
