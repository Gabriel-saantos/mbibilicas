import 'package:flutter/material.dart';
import 'package:myapp/bannerads.dart';
import 'package:myapp/messagecard/message.dart';
import 'package:myapp/messagecard/message_cardlogic.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final MessageCardLogic _logic = MessageCardLogic();
  late Future<List<Map<String, dynamic>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = _logic.getFavorites();
    });
  }

  Future<void> _refreshFavorites() async {
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [_buildClearFavoritesButton()],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyFavorites();
                }

                return _buildFavoritesList(snapshot.data!);
              },
            ),
          ),
          BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Map<String, dynamic>> favorites) {
    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        return Dismissible(
          key: Key(favorite['message']),
          direction: DismissDirection.endToStart,
          background: Container(
            color: const Color.fromARGB(255, 246, 110, 101),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete_sharp, color: Colors.white),
          ),
          onDismissed: (_) async {
            await _logic.removeFavorite(
                favorite['imageUrl'], favorite['message']);
            _showSnackBar('Mensagem removida dos favoritos!');
            _refreshFavorites();
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: MessageCard(
              imageUrl: favorite['imageUrl'],
              message: favorite['message'],
            ),
          ),
        );
      },
    );
  }

  IconButton _buildClearFavoritesButton() {
    return IconButton(
      icon: const Icon(Icons.delete_sharp, color: Colors.pinkAccent),
      onPressed: () async {
        final confirm = await _showConfirmationDialog();
        if (confirm == true) {
          await _logic.clearFavorites();
          _showSnackBar('Favoritos limpos com sucesso!');
          _refreshFavorites();
        }
      },
    );
  }

  Future<bool?> _showConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('Quer mesmo limpar os favoritos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Limpar', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  Widget _buildEmptyFavorites() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, color: theme.colorScheme.secondary, size: 50),
          const SizedBox(height: 15),
          Text(
            'Nada encontrado,\nas mensagens favoritas irão aparecer aqui.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
