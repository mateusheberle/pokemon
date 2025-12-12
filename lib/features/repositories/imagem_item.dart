import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/core/utils/string_utils.dart';
import 'package:pokemon/features/repositories/imagem_network.dart';
import 'package:flutter/material.dart';

/// Widget to display a Pokemon image with its name
class ImageItem extends StatelessWidget {
  const ImageItem({
    super.key,
    required this.pokemon,
    required this.tag,
    required this.color,
  });

  final Pokemon pokemon;
  final String tag;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(color: color),
      child: ClipRRect(
        child: Stack(
          children: [
            ImageNetwork(
              url: pokemon.sprites?[0] ?? '',
              fit: BoxFit.contain,
              height: 350,
              width: null,
              color: color,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 20.0,
                ),
                child: Center(
                  child: Text(
                    StringUtils.capitalize(pokemon.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
