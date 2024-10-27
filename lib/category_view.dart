import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/messagecard/message.dart';
import 'dart:math';

class CategoryView extends StatefulWidget {
  final String category;

  const CategoryView({required this.category, super.key});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<QueryDocumentSnapshot>? messages;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      QuerySnapshot snapshot;

      if (widget.category == 'Descobrir') {
        // Puxar todas as mensagens sem filtrar por categoria
        snapshot = await FirebaseFirestore.instance
            .collection('mensagens')
            .limit(50)
            .get();
      } else {
        // Puxar mensagens baseadas na categoria
        snapshot = await FirebaseFirestore.instance
            .collection('mensagens')
            .where('category', isEqualTo: widget.category)
            .limit(50)
            .get();
      }

      final docs = snapshot.docs;

      // Log de documentos recebidos
      print('Documents: ${docs.length}');
      for (var doc in docs) {
        print('Document ID: ${doc.id}, Data: ${doc.data()}');
      }

      // Embaralha a lista de mensagens
      docs.shuffle(Random());

      setState(() {
        messages = docs;
        isLoading = false;
      });
    } catch (e) {
      print('Erro: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar mensagens: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(
        color: Colors.pink,
      ));
    }

    if (messages == null || messages!.isEmpty) {
      return Center(
        child: Text(
          'Nada Encontrado',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: messages!.length,
      itemBuilder: (context, index) {
        final message = messages![index];
        return MessageCard(
          imageUrl:
              message['imageUrl'] ?? 'https://via.placeholder.com/600x400',
          message: message['message'] ?? '',
        );
      },
    );
  }
}
