import 'package:flutter/material.dart';
import 'package:myapp/bannerads.dart';
import 'package:myapp/messagecard/message.dart';
import 'package:myapp/messagecard/message_cardlogic.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MessageCardLogic logic = MessageCardLogic();
  late Future<List<Map<String, dynamic>>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    favoritesFuture = logic.getFavorites(); // Inicializa a lista de favoritos
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      favoritesFuture = logic.getFavorites(); // Atualiza a lista de favoritos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_sharp,
              color: Colors.pinkAccent,
            ),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Quer mesmo limpar os favoritos?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancela a ação
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Limpar',
                          style: TextStyle(color: Colors.pink),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirma a ação
                        },
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await logic.clearFavorites(); // Limpa todos os favoritos
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(6), // Define o padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Define a borda arredondada
                    ),
                    behavior:
                        SnackBarBehavior.floating, // Comportamento flutuante
                    duration:
                        Duration(seconds: 3), // Define a duração (4 segundos)
                    content: Text(
                      'Favoritos limpos com sucesso!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );

                _refreshFavorites(); // Atualiza a lista de favoritos
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: favoritesFuture, // Usa o Future atualizado
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: Colors.pink, size: 50),
                        SizedBox(height: 15),
                        Text(
                          'Nada encontrado, \n as mensagens favoritas irão aparecer aqui.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final favorites = snapshot.data!;

                return ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MessageCard(
                        imageUrl: favorite['imageUrl'],
                        message: favorite['message'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          BannerAdWidget(), // Adiciona o BannerAdWidget no fim da tela
        ],
      ),
    );
  }
}
