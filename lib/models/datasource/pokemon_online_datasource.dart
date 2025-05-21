import 'dart:convert';

import 'package:g_62_test/models/entities/pokemon_entity.dart';
import 'package:http/http.dart' as http;

class PokemonOnlineDatasource {
  static Future<List<PokemonEntity>> fetchPokemonList() async {
    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50'),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load pokemon list');
      }

      final data = json.decode(response.body);
      return List<PokemonEntity>.from(
        data['results'].map((pokemon) => PokemonEntity.fromJson(pokemon)),
      );
    } catch (e) {
      print("Error fetching pokemon list: $e");
      rethrow;
    }
  }

  static Future<PokemonDetails> fetchPokemonDetails(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to load pokemon details');
      }
      return PokemonDetails.fromJson(json.decode(response.body));
    } catch (e) {
      print("Error fetching pokemon details: $e");
      rethrow;
    }
  }

  static Future<List<PokemonEntity>> fetchCompletePokemonData() async {
    final pokemonList = await fetchPokemonList();
    
    final List<Future<void>> detailFutures = [];
    
    for (var pokemon in pokemonList) {
      detailFutures.add(
        fetchPokemonDetails(pokemon.url).then((details) {
          pokemon.details = details;
        },
      )
      );
    }
    
    await Future.wait(detailFutures);
    return pokemonList;
  }
}