import 'package:flutter/material.dart';
import 'package:pokemon/core/styles/appstyle.dart';
import 'package:pokemon/features/pages/geracoes.dart';
import 'features/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: AppStyle.theme,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const GeracoesPokemonPage(),
        '/homePage': (BuildContext context) =>
            const HomePage(title: 'Pokédex', geracao: 1),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
