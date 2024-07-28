import 'package:flutter/material.dart';
import 'package:myapp/compartilhar.dart';
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
      length: 9, // Atualize o comprimento do TabController
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Compartilhar()),
          );
          },
          child: const Icon(Icons.share_rounded),
        ),
        appBar: AppBar(
          title: const Text('Mensagens Bíblicas'),
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Bom dia'),
              Tab(text: 'Boa Tarde'),
              Tab(text: 'Boa noite'),
              Tab(text: 'Fé'),
              Tab(text: 'Esperança'),
              Tab(text: 'Amor'),
              Tab(text: 'Paz'),
              Tab(text: 'Salmos'),
              Tab(text: 'Provérbios'),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            const TabBarView(
              children: <Widget>[
                CategoryView(category: 'Bom dia'),
                CategoryView(category: 'Boa Tarde'),
                CategoryView(category: 'Boa noite'),
                CategoryView(category: 'Fé'),
                CategoryView(category: 'Esperança'),
                CategoryView(category: 'Amor'),
                CategoryView(category: 'Paz'),
                CategoryView(category: 'Salmos'),
                CategoryView(category: 'Provérbios'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
