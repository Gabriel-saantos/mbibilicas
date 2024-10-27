import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Compartilhar extends StatefulWidget {
  const Compartilhar({super.key});

  @override
  State<Compartilhar> createState() => _CompartilharState();
}

class _CompartilharState extends State<Compartilhar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _compartilharLink() {
    _controller.forward();
    Share.share(
        'Confira o aplicativo Mensagens Bíblicas, baixe já: \n \n https://play.google.com/store/apps/details?id=com.tooapps.mensagensbiblicas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Compartilhar aplicativo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Imagem de fundo com opacidade
          Opacity(
            opacity: 0.3, // Controla a opacidade da imagem
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Conteúdo principal
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 18),
                Image.asset(
                  'images/logobg.png',
                  width: 120,
                  height: 120,
                ),
                const Text(
                  'Mensagens Bíblicas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Espalhe a palavra!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Compartilhe o aplicativo Mensagens Bíblicas com seus amigos e familiares.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: ElevatedButton.icon(
                      onPressed: _compartilharLink,
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.pink,
                      ),
                      label: const Text(
                        'COMPARTILHAR',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
