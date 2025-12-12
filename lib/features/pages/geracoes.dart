import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokemon/core/constants/app_strings.dart';
import 'package:pokemon/features/pages/home_page.dart';

/// Page for selecting Pokemon generations
class GeracoesPokemonPage extends StatelessWidget {
  const GeracoesPokemonPage({super.key});

  void _selecionarGeracao(BuildContext context, int geracao) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.generationSelected(geracao)),
        backgroundColor: Colors.greenAccent,
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomePage(title: AppStrings.appTitle, geracao: geracao),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(
          AppStrings.generationsTitle,
          style: GoogleFonts.pressStart2p(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(3, (index) {
            final geracao = index + 1;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: Colors.greenAccent),
                    ),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.greenAccent,
                  ),
                  onPressed: () => _selecionarGeracao(context, geracao),
                  child: Text(
                    '${AppStrings.generation} $geracao',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 24,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
