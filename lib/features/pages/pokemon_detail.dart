import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon/core/models/arguments.dart';
import 'package:pokemon/core/models/pokemon.dart';
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

  String getId(Pokemon pokemon) {
    if (pokemon.id.toString().length < 3) {
      return '00${pokemon.id}';
    } else if (pokemon.id.toString().length < 2) {
      return '00${pokemon.id}';
    }
    return '${pokemon.id}';
  }

  Color getColorFromName(String name, int opacity) {
    final colors = {
      'red': Colors.red[opacity],
      'green': Colors.green[opacity],
      'blue': Colors.blue[opacity],
      'yellow': Colors.yellow[opacity],
      'orange': Colors.orange[opacity],
      'purple': Colors.purple[opacity],
      'pink': Colors.pink[opacity],
      'brown': Colors.brown[opacity],
      'grey': Colors.grey[opacity],
      'black': Colors.black,
      'white': Colors.white,
      // Adicione mais se necessário
    };

    return colors[name.toLowerCase()] ??
        Colors.grey; // Cor padrão se não encontrar
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
              "#${getId(widget.pokemon)}",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: getColorFromName(
          arguments.pokemon.color ?? 'white',
          200,
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
              color: getColorFromName(arguments.pokemon.color ?? 'white', 200),
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
                                      color: getColorFromName(
                                        arguments.pokemon.color ?? 'white',
                                        300,
                                      ),
                                      borderRadius: BorderRadius.circular(180),
                                    ),
                                  ),
                                  ImageNetwork(
                                    url: arguments.pokemon.sprites?[0] ?? '',
                                    fit: BoxFit.cover,
                                    height: 240,
                                    width: 240,
                                    color: getColorFromName(
                                      arguments.pokemon.color ?? 'white',
                                      600,
                                    ),
                                  ),
                                ],
                              )
                            : const Placeholder(),
                        Text(
                          arguments.pokemon.name[0].toUpperCase() +
                              arguments.pokemon.name.substring(1),
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
                                  color: getColorFromName(
                                    arguments.pokemon.color ?? 'black',
                                    600,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  type[0].toUpperCase() + type.substring(1),
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
                          'Info',
                          InfoTab(pokemon: arguments.pokemon),
                          arguments,
                        ),
                        _buildTabCard(
                          1,
                          'Stats',
                          StatusTab(pokemon: arguments.pokemon),
                          arguments,
                        ),
                        _buildTabCard(
                          2,
                          'Evolução',
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
                    color: getColorFromName(
                      arguments.pokemon.color ?? 'black',
                      600,
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
        _linha('ID', '#${pokemon.id.toString().padLeft(3, '0')}'),
        _linha(
          'Espécie',
          pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
        ),
        _linha(
          'Tipo',
          pokemon.types!
              .map((type) => type[0].toUpperCase() + type.substring(1))
              .join(', '),
        ),
        _linha('Altura', '${pokemon.height}'),
        _linha('Peso', '${pokemon.weight}'),
        _linha(
          'Habilidades',
          pokemon.abilities!
              .map((ability) => ability[0].toUpperCase() + ability.substring(1))
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
        _linha('HP', pokemon.status![0]),
        _linha('Ataque', pokemon.status![1]),
        _linha('Defesa', pokemon.status![2]),
        _linha('Ataque Especial', pokemon.status![3]),
        _linha('Defesa Especial', pokemon.status![4]),
        _linha('Velocidade', pokemon.status![5]),
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
                name:
                    evolution.name[0].toUpperCase() +
                    evolution.name.substring(1),
                type: evolution.types!
                    .map((t) => t[0].toUpperCase() + t.substring(1))
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
        name[0].toUpperCase() + name.substring(1),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        type.map((t) => t[0].toUpperCase() + t.substring(1)).join(', '),
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
