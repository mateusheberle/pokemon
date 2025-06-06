import 'package:flutter/material.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/features/Widgets/carousel_card.dart';
import 'package:pokemon/features/home/controllers/home_controller.dart';

// import '../../Common/Model/movie.dart';

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
  ValueNotifier<int> indexSelectedContainer = ValueNotifier<int>(-1);
  ValueNotifier<double> sizeSelectedContainer = ValueNotifier<double>(150);
  ValueNotifier<FocusNode> itemFocusNode = ValueNotifier<FocusNode>(
    FocusNode(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    indexSelectedContainer.dispose();
    sizeSelectedContainer.dispose();
    itemFocusNode.dispose();
    super.dispose();
  }

  Color getColorFromName(String name, int opacity) {
    final typesColor = {
      "normal": Colors.brown[opacity],
      "fighting": Colors.red[opacity],
      "flying": Colors.blue[opacity],
      "poison": Colors.purple[opacity],
      "ground": Colors.brown[opacity],
      "rock": Colors.grey[opacity],
      "bug": Colors.lightGreen[opacity],
      "ghost": Colors.deepPurple[opacity],
      "fire": Colors.orange[opacity],
      "water": Colors.blue[opacity],
      "grass": Colors.green[opacity],
      "electric": Colors.yellow[opacity],
      "psychic": Colors.pink[opacity],
      "ice": Colors.cyan[opacity],
      "dragon": Colors.indigo[opacity],
      "fairy": Colors.pink[opacity],
      "dark": Colors.brown[opacity],
      "steel": Colors.blueGrey[opacity],
      "unknown": Colors.grey,
      "shadow": Colors.black,
    };

    return typesColor[name.toLowerCase()] ??
        Colors.grey; // Cor padrão se não encontrar
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColorFromName(widget.showType ? widget.type : widget.name, 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.showType
              ? Text(
                  widget.type.isNotEmpty
                      ? widget.type[0].toUpperCase() + widget.type.substring(1)
                      : widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: EdgeInsets.only(top: widget.showType ? 4 : 0),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.pokemons.length,
                itemBuilder: (_, index) {
                  var item = widget.pokemons[index];
                  return CarouselCard(
                    index: index,
                    name: widget.name,
                    pokemon: item,
                    color: getColorFromName(
                      widget.showType ? widget.type : widget.name,
                      300,
                    ),
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
