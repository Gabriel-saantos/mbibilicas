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
        'Confira o aplicativo Mensagens Bíblicas, onde você pode compartilhar mensagens bíblicas com seus amigos e familiares! Junte-se a nós no Mensagens Bíblicas, ✨ BAIXE JÁ!  \n \n https://play.google.com/store/apps/details?id=com.tooapps.mensagensbiblicas');
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
          'Compartilhar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
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
              decoration: const BoxDecoration(
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
                // Logo do aplicativo
                Image.asset(
                  'images/logobg.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                // Título principal
                const Text(
                  'Mensagens Bíblicas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 8),
                // Subtítulo
                const Text(
                  'Espalhe a palavra!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 24),
                // Descrição
                const Text(
                  'Compartilhe o aplicativo com seus amigos e familiares.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 40),
                // Botão de compartilhamento
                Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: ElevatedButton(
                      onPressed: _compartilharLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'COMPARTILHAR',
                        style: TextStyle(color: Colors.white),
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
