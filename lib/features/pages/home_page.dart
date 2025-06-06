import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokemon/core/models/arguments.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/core/styles/appstyle.dart';
import 'package:pokemon/features/home/controllers/home_controller.dart';
import 'package:pokemon/features/home/controllers/home_page_repository.dart';
import 'package:pokemon/features/widgets/custom_appbar.dart';
import 'package:pokemon/features/widgets/custom_carousel_slider.dart';
import 'package:pokemon/features/widgets/custom_refresh.dart';

class HomePage extends StatefulWidget {
  final String title;
  final int geracao;

  const HomePage({super.key, required this.title, required this.geracao});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageController _homePageController;
  late final HomePageRepository _homePageRepository;

  @override
  void initState() {
    super.initState();
    final client = Client();
    _homePageRepository = HomePageRepository(client);
    _homePageController = HomePageController(
      userName: widget.title,
      repository: _homePageRepository,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homePageController.fetchPokemonByGeneration(widget.geracao);
    });
  }

  @override
  void dispose() {
    _homePageController.detailSearchController.dispose();
    _homePageController.isLoading.dispose();
    _homePageController.isRefreshing.dispose();
    _homePageController.allTypes.dispose();
    _homePageController.catalogData.dispose();
    _homePageController.sliders.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        arguments: Arguments(
          homePageController: _homePageController,
          tag: '',
          pokemon: Pokemon(id: 0, name: ''),
        ),
        globalKey: GlobalKey(),
        isDetailPage: false,
      ),
      body: ValueListenableBuilder(
        valueListenable: _homePageController.isLoading,
        builder: (context, value, child) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Center(
                  child: ValueListenableBuilder<List<CustomCarouselSlider>>(
                    valueListenable: _homePageController.sliders,
                    builder: (context, value, child) {
                      return Container(
                        color: AppStyle.mainBackground,
                        height: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _homePageController.sliders.value.length,
                          itemBuilder: (_, index) {
                            var items =
                                _homePageController.sliders.value[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: CustomCarouselSlider(
                                name: items.name,
                                type: items.type,
                                initialPage: items.initialPage,
                                pokemons: items.pokemons,
                                showType: true,
                                homePageController: _homePageController,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              CustomRefresh(
                homePageController: _homePageController,
                repository: _homePageRepository,
              ),
            ],
          );
        },
      ),
    );
  }
}
