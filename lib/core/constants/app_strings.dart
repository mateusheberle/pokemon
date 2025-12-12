/// Application string constants for localization and consistency
class AppStrings {
  AppStrings._(); // Private constructor to prevent instantiation

  // App title
  static const String appTitle = 'Pokédex';

  // Generation page
  static const String generationsTitle = 'Gerações de Pokémon';
  static const String generation = 'Geração';
  static String generationSelected(int number) => 'Geração $number selecionada';

  // Pokemon detail tabs
  static const String infoTab = 'Info';
  static const String statsTab = 'Stats';
  static const String evolutionTab = 'Evolução';

  // Pokemon info fields
  static const String id = 'ID';
  static const String species = 'Espécie';
  static const String type = 'Tipo';
  static const String height = 'Altura';
  static const String weight = 'Peso';
  static const String abilities = 'Habilidades';

  // Pokemon stats
  static const String hp = 'HP';
  static const String attack = 'Ataque';
  static const String defense = 'Defesa';
  static const String specialAttack = 'Ataque Especial';
  static const String specialDefense = 'Defesa Especial';
  static const String speed = 'Velocidade';

  // Error messages
  static const String errorLoadingPokemon = 'Erro ao carregar Pokémon';
  static const String errorLoadingGeneration = 'Erro ao buscar geração';
  static const String noDataAvailable = 'Nenhum dado disponível';
  static const String tryAgain = 'Tentar novamente';
}
