import 'package:flutter/material.dart';
import 'package:pokemon/core/models/catalog.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/features/home/controllers/i_home_page_repository.dart';
import 'package:pokemon/features/widgets/custom_carousel_slider.dart';

class HomePageController {
  final String userName;
  final IHomePageRepository repository;

  final TextEditingController detailSearchController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<bool> isRefreshing = ValueNotifier(false);
  final ValueNotifier<List<String>> allTypes = ValueNotifier([]);
  final ValueNotifier<Catalog> catalogData = ValueNotifier(
    Catalog(pokemons: []),
  );
  final ValueNotifier<List<CustomCarouselSlider>> sliders = ValueNotifier([]);

  HomePageController({required this.userName, required this.repository});

  void dispose() {
    detailSearchController.dispose();
    isLoading.dispose();
    isRefreshing.dispose();
    allTypes.dispose();
    catalogData.dispose();
    sliders.dispose();
  }

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
      debugPrint('Erro ao buscar pokémons da geração $generation: $e');
      rethrow;
    } finally {
      isRefreshing.value = false;
    }
  }

  Future<Pokemon> fetchPokemonDetails(Pokemon pokemon) {
    return repository.getPokemonDetail(pokemon);
  }

  Future<void> _processCatalog(Catalog newCatalog) async {
    catalogData.value = newCatalog;
    final hasTypes = _extractTypes();
    await _createSliders(groupByType: hasTypes);
  }

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
          sliders.value.add(
            CustomCarouselSlider(
              name: userName,
              type: type,
              initialPage: _getInitialPage(copiedList.length),
              pokemons: copiedList,
              showType: true,
              homePageController: this,
            ),
          );
        }
      }
    } else {
      final copiedList = pokemons.map((p) => p.copyWith()).toList();
      if (copiedList.isNotEmpty) {
        sliders.value.add(
          CustomCarouselSlider(
            name: userName,
            type: '',
            initialPage: _getInitialPage(copiedList.length),
            pokemons: copiedList,
            showType: false,
            homePageController: this,
          ),
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 100));
  }

  int _getInitialPage(int listLength) {
    if (listLength <= 1) return 0;
    return (listLength * DateTime.now().millisecond ~/ 1000) % listLength;
  }

  String generateUniqueTag() =>
      DateTime.now().microsecondsSinceEpoch.toString();
}
