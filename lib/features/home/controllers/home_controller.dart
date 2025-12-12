import 'package:flutter/material.dart';
import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/features/home/controllers/i_home_page_repository.dart';
import 'package:pokemon/features/widgets/custom_carousel_slider.dart';

/// Controller for the Home Page
///
/// This class manages the state and business logic for the home page,
/// including fetching Pokemon data, organizing them by type, and
/// creating carousel sliders.
class HomePageController {
  HomePageController({required this.userName, required this.repository});

  /// User name or title for the page
  final String userName;

  /// Repository instance for data fetching
  final IHomePageRepository repository;

  /// Text controller for detail search
  final TextEditingController detailSearchController = TextEditingController();

  /// Loading state indicator
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Refreshing state indicator
  final ValueNotifier<bool> isRefreshing = ValueNotifier(false);

  /// List of all unique Pokemon types in the current catalog
  final ValueNotifier<List<String>> allTypes = ValueNotifier([]);

  /// Current catalog data
  final ValueNotifier<Catalog> catalogData = ValueNotifier(
    const Catalog(pokemons: []),
  );

  /// List of carousel sliders to display
  final ValueNotifier<List<CustomCarouselSlider>> sliders = ValueNotifier([]);

  /// Disposes all resources used by this controller
  void dispose() {
    detailSearchController.dispose();
    isLoading.dispose();
    isRefreshing.dispose();
    allTypes.dispose();
    catalogData.dispose();
    sliders.dispose();
  }

  /// Fetches Pokemon data for a specific generation
  ///
  /// [generation] - The generation number (1, 2, 3, etc.)
  /// Returns the updated [Catalog] or the current one if fetch fails
  Future<Catalog> fetchPokemonByGeneration(int generation) async {
    isRefreshing.value = true;

    try {
      final result = await repository.getPokemon(generation);

      if (result.pokemons.isEmpty) {
        return catalogData.value;
      }

      await _processCatalog(result);
      return catalogData.value;
    } catch (e) {
      debugPrint('Error fetching Pokemon for generation $generation: $e');
      rethrow;
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Fetches detailed information for a specific Pokemon
  Future<Pokemon> fetchPokemonDetails(Pokemon pokemon) {
    return repository.getPokemonDetail(pokemon);
  }

  /// Processes the catalog data by extracting types and creating sliders
  Future<void> _processCatalog(Catalog newCatalog) async {
    catalogData.value = newCatalog;
    final hasTypes = _extractTypes();
    await _createSliders(groupByType: hasTypes);
  }

  /// Extracts all unique types from the current catalog
  ///
  /// Returns true if any types were found
  bool _extractTypes() {
    final typeSet = <String>{};
    for (final pokemon in catalogData.value.pokemons) {
      if (pokemon.types != null && pokemon.types!.isNotEmpty) {
        typeSet.addAll(pokemon.types!);
      }
    }
    allTypes.value = typeSet.toList();
    return allTypes.value.isNotEmpty;
  }

  /// Creates carousel sliders from the current catalog
  ///
  /// [groupByType] - If true, creates one slider per type; otherwise, one slider for all
  Future<void> _createSliders({required bool groupByType}) async {
    sliders.value = [];

    final pokemons = catalogData.value.pokemons;
    if (pokemons.isEmpty) return;

    if (groupByType) {
      for (final type in allTypes.value) {
        final filtered = pokemons
            .where((p) => p.types?.contains(type) ?? false)
            .toList();

        if (filtered.isNotEmpty) {
          final copiedList = filtered.map((p) => p.copyWith()).toList();
          sliders.value = [
            ...sliders.value,
            CustomCarouselSlider(
              name: userName,
              type: type,
              initialPage: _getInitialPage(copiedList.length),
              pokemons: copiedList,
              showType: true,
              homePageController: this,
            ),
          ];
        }
      }
    } else {
      final copiedList = pokemons.map((p) => p.copyWith()).toList();
      if (copiedList.isNotEmpty) {
        sliders.value = [
          CustomCarouselSlider(
            name: userName,
            type: '',
            initialPage: _getInitialPage(copiedList.length),
            pokemons: copiedList,
            showType: false,
            homePageController: this,
          ),
        ];
      }
    }

    // Small delay to ensure UI updates properly
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Calculates a random initial page for carousel
  ///
  /// Uses current time to generate a pseudo-random starting page
  int _getInitialPage(int listLength) {
    if (listLength <= 1) return 0;
    return (listLength * DateTime.now().millisecond ~/ 1000) % listLength;
  }

  /// Generates a unique tag for hero animations
  String generateUniqueTag() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
