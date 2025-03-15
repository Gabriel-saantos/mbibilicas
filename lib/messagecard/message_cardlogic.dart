import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';


class MessageCardLogic {
  // Método para limpar todos os favoritos
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }

  // Compartilha uma imagem a partir de uma URL e um texto
  Future<void> shareImageAndText(
      String url, String text, BuildContext context) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      final imageBytes = response.data as Uint8List;

      final tempFile = await _createTempFile(imageBytes);

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text:
            '$text\n\nhttps://play.google.com/store/apps/details?id=com.tooapps.mensagensbiblicas',
      );

      await tempFile.delete();
    } catch (e) {
      _showSnackbar(context, 'Erro ao compartilhar imagem');
    }
  }

  // Exibe o anúncio intersticial antes do compartilhamento
  void showInterstitialAdAndShare(
      String imageUrl, String message, BuildContext context) {
    if (InterstitialAdManager.isAdLoaded()) {
      InterstitialAdManager.showAd(() async {
        await Future.delayed(const Duration(seconds: 2)); // Pequeno delay
        shareImageAndText(imageUrl, message, context);
      });
    } else {
      shareImageAndText(imageUrl, message, context);
    }
  }

  // Cria um arquivo temporário para a imagem
  Future<File> _createTempFile(Uint8List imageBytes) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final filePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return file;
  }

  // Exibe uma mensagem usando o Snackbar
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Método para adicionar um favorito localmente
  Future<void> addFavorite(String imageUrl, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.add({
      'imageUrl': imageUrl,
      'message': message,
    });
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  // Método para remover um favorito localmente
  Future<void> removeFavorite(String imageUrl, String message) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere(
        (fav) => fav['imageUrl'] == imageUrl && fav['message'] == message);
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  // Método para obter os favoritos salvos localmente
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      return List<Map<String, dynamic>>.from(
          jsonDecode(favoritesString) as List<dynamic>);
    }
    return [];
  }

  // Método para verificar se a mensagem já é favorita localmente
  Future<bool> isFavorite(String imageUrl, String message) async {
    final favorites = await getFavorites();
    return favorites
        .any((fav) => fav['imageUrl'] == imageUrl && fav['message'] == message);
  }
}
