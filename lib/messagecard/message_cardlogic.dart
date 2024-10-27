import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class MessageCardLogic {
  InterstitialAd? _interstitialAd;

  // Solicita as permissões necessárias e retorna se foram concedidas
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // Para outras plataformas (iOS, Web), as permissões não são necessárias
  }

  // Método para limpar todos os favoritos
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');
  }

  // Carrega um anúncio intersticial
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-1040656265404217/3100521307', // Substitua pelo seu ID de anúncio intersticial
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
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

  // Exibe o anúncio intersticial e, após o fechamento, compartilha a imagem e o texto
  void showInterstitialAdAndShare(
      String imageUrl, String message, BuildContext context) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          shareImageAndText(imageUrl, message, context);
          loadInterstitialAd(); // Carrega outro anúncio após o fechamento
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Ad failed to show: $error');
          ad.dispose();
          shareImageAndText(imageUrl, message, context);
        },
      );
      _interstitialAd!.show();
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
