import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/pokedex_page.dart';
import 'pages/pokemon_detail_page.dart';
import 'providers/pokemon_provider.dart';
import 'theme/app_theme.dart';

void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => PokemonProvider(),
        child: MaterialApp(
          title: 'Pokédex',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const PokedexPage(),
          routes: {
            '/detail': (context) => const PokemonDetailPage(),
          },
        ),
      );
}
