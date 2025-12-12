/// Common utility functions
class StringUtils {
  StringUtils._(); // Private constructor to prevent instantiation

  /// Capitalize first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Format Pokemon ID with leading zeros (e.g., 001, 025, 151)
  static String formatPokemonId(int id) {
    return id.toString().padLeft(3, '0');
  }
}
