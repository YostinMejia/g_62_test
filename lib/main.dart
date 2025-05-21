import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_62_test/models/providers/providers.dart';
import 'package:g_62_test/view/screen_1.dart';
import 'package:g_62_test/view/screen_2.dart';
import 'package:g_62_test/view/screen_3.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon App con BUENAS prac',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  HomePage(),
    );
  }
}


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    final pokemonState = ref.watch(pokemonProvider);

    final List<Widget> screens = [
      pokemonState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (pokemonList) => PokemonList(pokemonList: pokemonList),
      ),
      const Screen2(),
      const Screen3(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon App con Riverpod'),
        actions: [
          if (currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(pokemonProvider.notifier).loadPokemon(),
            ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        actualIndex: currentIndex,
        onTap: (index) => ref.read(currentIndexProvider.notifier).state = index,
      ),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Esta es una aplicación con BUENAS prácticas!'),
                  ),
                );
              },
              child: const Icon(Icons.info),
            )
          : null,
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int actualIndex;
  
  const CustomBottomNavBar({
    super.key,
    required this.onTap,
    required this.actualIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: actualIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.catching_pokemon),
          label: 'Pokémon',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps), 
          label: 'Pantalla 2',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.videogame_asset),
          label: 'Pantalla 3',
        ),
      ],
    );
  }
}