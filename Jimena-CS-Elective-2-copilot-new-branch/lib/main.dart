import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/pokedex_page.dart';
import 'pages/pokemon_detail_page.dart';
import 'theme/app_theme.dart';

void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
    Widget build(BuildContext context) => ProviderScope(
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
