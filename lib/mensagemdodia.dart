import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/bannerads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/messagecard/message.dart'; // Importe o MessageCard

class MensagemDoDiaScreen extends StatefulWidget {
  const MensagemDoDiaScreen({super.key});

  @override
  _MensagemDoDiaScreenState createState() => _MensagemDoDiaScreenState();
}

class _MensagemDoDiaScreenState extends State<MensagemDoDiaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _imagemUrl = '';
  String _message = ''; // Variável para armazenar a mensagem
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarMensagemDoDia();
  }

  Future<void> _carregarMensagemDoDia() async {
    final prefs = await SharedPreferences.getInstance();

    // Obtém a data salva no formato "yyyy-MM-dd"
    final String? ultimaData = prefs.getString('ultimaData');
    final String hoje = DateTime.now().toString().split(' ')[0]; // Pega "yyyy-MM-dd"

    if (ultimaData == hoje) {
      // Se a data for a mesma, carrega os dados salvos
      final String? ultimaImagemUrl = prefs.getString('ultimaImagemUrl');
      final String? ultimaMensagem = prefs.getString('ultimaMensagem');

      if (ultimaImagemUrl != null && ultimaMensagem != null) {
        setState(() {
          _imagemUrl = ultimaImagemUrl;
          _message = ultimaMensagem;
          _isLoading = false;
        });
        return;
      }
    }

    // Se a data for diferente ou não houver mensagem, busca uma nova
    await _buscarNovaMensagemDoDia(prefs, hoje);
  }

  Future<void> _buscarNovaMensagemDoDia(SharedPreferences prefs, String hoje) async {
    try {
      // Busca todas as mensagens da coleção 'mensagens'
      final QuerySnapshot snapshot = await _firestore.collection('mensagens').get();

      if (snapshot.docs.isNotEmpty) {
        // Seleciona uma mensagem aleatória
        final randomIndex = DateTime.now().millisecondsSinceEpoch % snapshot.docs.length;
        final DocumentSnapshot doc = snapshot.docs[randomIndex];
        final String novaImagemUrl = doc['imageUrl'];
        final String novaMensagem = doc['message'];

        // Salva os novos dados
        await prefs.setString('ultimaImagemUrl', novaImagemUrl);
        await prefs.setString('ultimaMensagem', novaMensagem);
        await prefs.setString('ultimaData', hoje); // Salva a nova data

        setState(() {
          _imagemUrl = novaImagemUrl;
          _message = novaMensagem;
          _isLoading = false;
        });
      } else {
        setState(() {
          _imagemUrl = '';
          _message = 'Nenhuma mensagem encontrada.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _imagemUrl = '';
        _message = 'Erro ao carregar a mensagem do dia.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagem do Dia'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                _imagemUrl.isEmpty
                    ? Center(child: Text(_message))
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            child: MessageCard(
                              imageUrl: _imagemUrl,
                              message: _message, // Passa a mensagem para o MessageCard
                            ),
                          ),
                        ),
                      ),
                const Spacer(),
                const BannerAdWidget(),
              ],
            ),
    );
  }
}
