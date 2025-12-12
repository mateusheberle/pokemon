import '../../features/home/controllers/home_controller.dart';
import 'pokemon.dart';

/// Arguments class for passing data between routes
///
/// This class encapsulates navigation arguments used when
/// transitioning to Pokemon detail pages.
class Arguments {
  /// Creates an Arguments instance
  const Arguments({
    required this.tag,
    required this.pokemon,
    required this.homePageController,
  });

  /// Unique tag for hero animations
  final String tag;

  /// Pokemon data to display
  final Pokemon pokemon;

  /// Home page controller reference
  final HomePageController homePageController;

  /// Creates a copy of this Arguments with the given fields replaced
  Arguments copyWith({
    String? tag,
    Pokemon? pokemon,
    HomePageController? homePageController,
  }) {
    return Arguments(
      tag: tag ?? this.tag,
      pokemon: pokemon ?? this.pokemon,
      homePageController: homePageController ?? this.homePageController,
    );
  }
}
