import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_card.dart';

class CategoryView extends StatelessWidget {
  final String category;

  const CategoryView({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mensagens')
          .where('category', isEqualTo: category)
          .orderBy('timestamp',
              descending: true) // Certifique-se de que o campo existe
          .snapshots(),
      builder: (context, snapshot) {
        // Log de conexão
        print('Connection State: ${snapshot.connectionState}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Log de erro
        if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(
              child: Text('Erro ao carregar mensagens: ${snapshot.error}'));
        }

        // Log de dados
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print('No Data');
          return Center(
            child: Text(
              'Nada Encontrado',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final messages = snapshot.data!.docs;

        // Log de documentos recebidos
        print('Documents: ${messages.length}');
        for (var doc in messages) {
          print('Document ID: ${doc.id}, Data: ${doc.data()}');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return MessageCard(
              imageUrl:
                  message['imageUrl'] ?? 'https://via.placeholder.com/600x400',
              message: message['message'] ?? 'Mensagem não disponível',
            );
          },
        );
      },
    );
  }
}
