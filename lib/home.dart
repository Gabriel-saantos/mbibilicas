import 'package:flutter/material.dart';
import 'package:myapp/bannerads.dart';
import 'package:myapp/compartilhar.dart';
import 'package:myapp/favoritos.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 11, // Atualize o comprimento do TabController para 10
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoritesScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.pink,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Compartilhar()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ],
          title: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                child: Image.asset("images/logobg.png"),
              ),
              SizedBox(width: 10),
              const Text('Mensagens Bíblicas'),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.pink,
            labelStyle: TextStyle(
              color: Colors.pink,
            ),
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.explore), // Ícone de descobrir
              ),
              Tab(text: 'Bom dia'),
              Tab(text: 'Boa Tarde'),
              Tab(text: 'Boa noite'),
              Tab(text: 'Gratidão'),
              Tab(text: 'Salmos'),
              Tab(text: 'Esperança'),
              Tab(text: 'Amor'),
              Tab(text: 'Paz'),
              Tab(text: 'Fé'),
              Tab(text: 'Provérbios'),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            const TabBarView(
              children: <Widget>[
                CategoryView(category: 'Descobrir'),

                CategoryView(category: 'Bom dia'),
                CategoryView(category: 'Boa Tarde'),
                CategoryView(category: 'Boa noite'),
                CategoryView(category: 'Gratidão'),
                CategoryView(category: 'Salmos'),
                CategoryView(category: 'Esperança'),
                CategoryView(category: 'Amor'),
                CategoryView(category: 'Paz'),
                CategoryView(category: 'Fé'),
                CategoryView(category: 'Provérbios'),
                // Adiciona a nova categoria
              ],
            ),
            BannerAdWidget(), // Adicione o BannerAdWidget aqui
          ],
        ),
      ),
    );
  }
}
