import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_62_test/models/datasource/pokemon_online_datasource.dart';
import 'package:g_62_test/models/entities/pokemon_entity.dart';

// Provider para el índice de navegación
final currentIndexProvider = StateProvider<int>((ref) => 0);

// Provider para el estado de los Pokémon
final pokemonProvider = StateNotifierProvider<PokemonNotifier, AsyncValue<List<PokemonEntity>>>((ref) {
  return PokemonNotifier();
});

class PokemonNotifier extends StateNotifier<AsyncValue<List<PokemonEntity>>> {
  PokemonNotifier() : super(const AsyncValue.loading()) {
    loadPokemon();
  }

  Future<void> loadPokemon() async {
    state = const AsyncValue.loading();
    try {
      final pokemonList = await PokemonOnlineDatasource.fetchCompletePokemonData();
      state = AsyncValue.data(pokemonList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}