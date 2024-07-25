import 'package:flutter/material.dart';
import 'category_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7, // Atualize o comprimento do TabController
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.favorite),
        ),
        appBar: AppBar(
          title: const Text('Mensagens Bíblicas'),
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: 'Fé'),
              Tab(text: 'Bom dia'),
              Tab(text: 'Boa Tarde'),
              Tab(text: 'Boa noite'),
              Tab(text: 'Esperança'),
              Tab(text: 'Amor'),
              Tab(text: 'Paz'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            CategoryView(category: 'Fé'),
            CategoryView(category: 'Bom dia'),
            CategoryView(category: 'Boa Tarde'),
            CategoryView(category: 'Boa noite'),
            CategoryView(category: 'Esperança'),
            CategoryView(category: 'Amor'),
            CategoryView(category: 'Paz'),
          ],
        ),
      ),
    );
  }
}
