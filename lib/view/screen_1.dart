import 'package:flutter/material.dart';
import 'package:g_62_test/models/entities/pokemon_entity.dart';

class PokemonList extends StatelessWidget {
  final List<PokemonEntity> pokemonList;
  
  const PokemonList({
    super.key,
    required this.pokemonList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        return GestureDetector(
          onTap: () {
            if (pokemon.details != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                ),
              );
            }
          },
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildPokemonImage(pokemon.details),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (pokemon.details != null) ...[
                          const SizedBox(height: 8),
                          Text('ID: #${pokemon.details!.id}'),
                          Text('Tipo: ${pokemon.details!.primaryType}'),
                          Text('Altura: ${pokemon.details!.height} dm'),
                          Text('Peso: ${pokemon.details!.weight} hg'),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPokemonImage(PokemonDetails? details) {
    if (details == null || details.spriteUrl.isEmpty) {
      return Container(
        height: 100,
        width: 100,
        color: Colors.grey[300],
        child: const CircularProgressIndicator(),
      );
    }
    
    return Image.network(
      details.spriteUrl,
      height: 100,
      width: 100,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 100,
        width: 100,
        color: Colors.grey[300],
        child: const Icon(Icons.error),
      ),
    );
  }
}
class PokemonDetailScreen extends StatelessWidget {
  final PokemonEntity pokemon;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    final details = pokemon.details!;
    
    return Scaffold(
      appBar: AppBar(title: Text(pokemon.name.toUpperCase())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'pokemon-image-${details.id}',
              child: Image.network(
                details.spriteUrl,
                height: 200,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.error, size: 100),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDetailRow('ID', '#${details.id}'),
                    _buildDetailRow('Tipo principal', details.primaryType),
                    _buildDetailRow('Altura', '${details.height} dm'),
                    _buildDetailRow('Peso', '${details.weight} hg'),
                    if (details.secondaryType != null)
                      _buildDetailRow('Tipo secundario', details.secondaryType!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}