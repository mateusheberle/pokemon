import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon/core/constants/app_strings.dart';
import 'package:pokemon/core/models/arguments.dart';
import 'package:pokemon/core/models/pokemon.dart';
import 'package:pokemon/core/utils/color_utils.dart';
import 'package:pokemon/core/utils/string_utils.dart';
import 'package:pokemon/features/repositories/imagem_network.dart';
import 'package:flutter/material.dart';

class PokemonDetail extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  ValueNotifier<bool> crossFade = ValueNotifier(false);
  ValueNotifier<bool> printMovieDetail = ValueNotifier(false);

  Arguments extractArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Arguments;
    return arguments;
  }

  Future<void> startCrossFade() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      crossFade.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    startCrossFade();
  }

  @override
  void dispose() {
    crossFade.dispose();
    printMovieDetail.dispose();
    super.dispose();
  }

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    Arguments arguments = extractArguments(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              widget.pokemon.sprites?[1] ?? '',
              height: 80,
              width: 80,
            ),
            Text(
              "#${StringUtils.formatPokemonId(widget.pokemon.id)}",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: PokemonColorUtils.getSpeciesColor(
          arguments.pokemon.color ?? 'white',
          opacity: 200,
        ),
        elevation: 0,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: crossFade,
        builder: (context, value, child) {
          return SizedBox.expand(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: PokemonColorUtils.getSpeciesColor(
                arguments.pokemon.color ?? 'white',
                opacity: 200,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        arguments.pokemon.sprites!.isNotEmpty &&
                                arguments.tag.isNotEmpty
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 360,
                                    width: 360,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: PokemonColorUtils.getSpeciesColor(
                                        arguments.pokemon.color ?? 'white',
                                        opacity: 300,
                                      ),
                                      borderRadius: BorderRadius.circular(180),
                                    ),
                                  ),
                                  ImageNetwork(
                                    url: arguments.pokemon.sprites?[0] ?? '',
                                    fit: BoxFit.cover,
                                    height: 240,
                                    width: 240,
                                    color: PokemonColorUtils.getSpeciesColor(
                                      arguments.pokemon.color ?? 'white',
                                      opacity: 600,
                                    ),
                                  ),
                                ],
                              )
                            : const Placeholder(),
                        Text(
                          StringUtils.capitalize(arguments.pokemon.name),
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var type in arguments.pokemon.types!)
                              Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: PokemonColorUtils.getSpeciesColor(
                                    arguments.pokemon.color ?? 'black',
                                    opacity: 600,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  StringUtils.capitalize(type),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        _buildTabCard(
                          0,
                          AppStrings.infoTab,
                          InfoTab(pokemon: arguments.pokemon),
                          arguments,
                        ),
                        _buildTabCard(
                          1,
                          AppStrings.statsTab,
                          StatusTab(pokemon: arguments.pokemon),
                          arguments,
                        ),
                        _buildTabCard(
                          2,
                          AppStrings.evolutionTab,
                          EvolucaoTab(pokemon: arguments.pokemon),
                          arguments,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabCard(
    int index,
    String title,
    Widget content,
    Arguments arguments,
  ) {
    final isOpen = activeIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          activeIndex = isOpen ? -1 : index;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: PokemonColorUtils.getSpeciesColor(
                      arguments.pokemon.color ?? 'black',
                      opacity: 600,
                    ),
                  ),
                ),
                isOpen ? content : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Conteúdo das "abas"
class InfoTab extends StatelessWidget {
  final Pokemon pokemon;
  const InfoTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            pokemon.sprites?[1] ?? '',
            height: 100,
            width: 100,
          ),
        ),
        const SizedBox(height: 10),
        _linha(AppStrings.id, '#${StringUtils.formatPokemonId(pokemon.id)}'),
        _linha(AppStrings.species, StringUtils.capitalize(pokemon.name)),
        _linha(
          AppStrings.type,
          pokemon.types!.map((type) => StringUtils.capitalize(type)).join(', '),
        ),
        _linha(AppStrings.height, '${pokemon.height}'),
        _linha(AppStrings.weight, '${pokemon.weight}'),
        _linha(
          AppStrings.abilities,
          pokemon.abilities!
              .map((ability) => StringUtils.capitalize(ability))
              .join('\n'),
        ),
      ],
    );
  }

  Row _linha(String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Text(
          text2,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            overflow: TextOverflow.ellipsis,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class StatusTab extends StatelessWidget {
  final Pokemon pokemon;
  const StatusTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _linha(AppStrings.hp, pokemon.stats![0]),
        _linha(AppStrings.attack, pokemon.stats![1]),
        _linha(AppStrings.defense, pokemon.stats![2]),
        _linha(AppStrings.specialAttack, pokemon.stats![3]),
        _linha(AppStrings.specialDefense, pokemon.stats![4]),
        _linha(AppStrings.speed, pokemon.stats![5]),
      ],
    );
  }

  Row _linha(String text1, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            text1,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: value / 150,
            color: Colors.teal,
            backgroundColor: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}

class EvolucaoTab extends StatelessWidget {
  final Pokemon pokemon;

  const EvolucaoTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (pokemon.evolutions != null)
          for (var evolution in pokemon.evolutions!)
            if (evolution != null)
              EvolutionRow(
                id: evolution.id,
                name: StringUtils.capitalize(evolution.name),
                type: evolution.types!
                    .map((t) => StringUtils.capitalize(t))
                    .toList(),
                sprites: evolution.sprites ?? [],
              ),
      ],
    );
  }
}

class EvolutionRow extends StatelessWidget {
  final int id;
  final String name;
  final List<String> type;
  final List<String> sprites;

  const EvolutionRow({
    super.key,
    required this.id,
    required this.name,
    required this.type,
    required this.sprites,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 56,
        height: 56,
        child: ImageNetwork(
          url: sprites[0],
          fit: BoxFit.cover,
          height: 60,
          width: 60,
          color: Colors.transparent,
        ),
      ),
      title: Text(
        StringUtils.capitalize(name),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        type.map((t) => StringUtils.capitalize(t)).join(', '),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
