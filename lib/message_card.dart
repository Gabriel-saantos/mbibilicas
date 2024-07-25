import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class MessageCard extends StatelessWidget {
  final String imageUrl;
  final String message;

  const MessageCard({
    required this.imageUrl,
    required this.message,
    super.key,
  });

  Future<void> _downloadImage(String url, BuildContext context) async {
    try {
      // Verifique e solicite permissões de armazenamento
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if (await Permission.storage.isGranted) {
        // Obtém o diretório "Downloads" do armazenamento externo
        final externalDir = await getExternalStorageDirectory();
        final directory = Directory('${externalDir!.path}/MyAppImages');

        // Crie o diretório "MyAppImages" se não existir
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final filePath =
            '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Faz o download da imagem
        final response = await Dio().download(url, filePath);

        if (response.statusCode == 200) {
          print('Imagem salva em: $filePath');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imagem salva em: $filePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao baixar imagem')),
          );
        }
      } else {
        print('Permissão de armazenamento não concedida');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permissão de armazenamento não concedida')),
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao baixar imagem: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () => _downloadImage(imageUrl, context),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Adicione lógica para compartilhar a imagem
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Adicione lógica para favoritar a mensagem
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
