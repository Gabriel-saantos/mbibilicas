import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Compartilhar extends StatefulWidget {
  const Compartilhar({super.key});

  @override
  State<Compartilhar> createState() => _CompartilharState();
}

class _CompartilharState extends State<Compartilhar> {
  void _compartilharLink() {
    Share.share(
        'Confira o aplicativo Mensagens Bíblicas: https://play.google.com/store/apps/details?id=com.seuapp.mensagensbiblicas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartilhar Aplicativo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/images/share_icon.png'), // Substitua pelo caminho da sua imagem
            ),
            const SizedBox(height: 20),
            const Text(
              'Compartilhe o aplicativo Mensagens Bíblicas com seus amigos e familiares!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _compartilharLink,
              icon: const Icon(Icons.share),
              label: const Text(' COMPARTILHAR '),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagens Bíblicas'),
      ),
      body: Center(
        child: const Text('Conteúdo principal aqui'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Compartilhar()),
          );
        },
        child: const Icon(Icons.share_rounded),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensagens Bíblicas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TelaPrincipal(),
    );
  }
}
