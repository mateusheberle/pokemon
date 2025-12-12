import 'package:flutter/material.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/core/utils/color_utils.dart';
import 'package:pokemon/core/utils/string_utils.dart';
import 'package:pokemon/features/widgets/carousel_card.dart';
import 'package:pokemon/features/home/controllers/home_controller.dart';

/// Custom carousel slider widget for displaying Pokemon cards
class CustomCarouselSlider extends StatefulWidget {
  const CustomCarouselSlider({
    super.key,
    required this.name,
    required this.type,
    required this.showType,
    required this.initialPage,
    required this.pokemons,
    required this.homePageController,
  });

  final String name;
  final String type;
  final bool showType;
  final int initialPage;
  final List<Pokemon> pokemons;
  final HomePageController homePageController;

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  final ValueNotifier<int> indexSelectedContainer = ValueNotifier<int>(-1);
  final ValueNotifier<double> sizeSelectedContainer = ValueNotifier<double>(
    150,
  );
  final ValueNotifier<FocusNode> itemFocusNode = ValueNotifier<FocusNode>(
    FocusNode(),
  );

  @override
  void dispose() {
    indexSelectedContainer.dispose();
    sizeSelectedContainer.dispose();
    itemFocusNode.value.dispose();
    itemFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.showType
        ? PokemonColorUtils.getTypeColor(widget.type, opacity: 300)
        : PokemonColorUtils.getTypeColor(widget.name, opacity: 300);

    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.showType)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                StringUtils.capitalize(
                  widget.type.isNotEmpty ? widget.type : widget.name,
                ),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: widget.showType ? 4 : 0),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.pokemons.length,
                itemBuilder: (_, index) {
                  final item = widget.pokemons[index];
                  final cardColor = widget.showType
                      ? PokemonColorUtils.getTypeColor(
                          widget.type,
                          opacity: 300,
                        )
                      : PokemonColorUtils.getTypeColor(
                          widget.name,
                          opacity: 300,
                        );

                  return CarouselCard(
                    index: index,
                    name: widget.name,
                    pokemon: item,
                    color: cardColor,
                    homePageController: widget.homePageController,
                    indexSelectedContainer: indexSelectedContainer,
                    sizeSelectedContainer: sizeSelectedContainer,
                    itemFocusNode: itemFocusNode,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
