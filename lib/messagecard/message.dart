import 'package:flutter/material.dart';
import 'package:myapp/messagecard/message_cardlogic.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share_plus/share_plus.dart'; // Certifique-se de que este import está presente

class MessageCard extends StatefulWidget {
  final String imageUrl;
  final String message;

  const MessageCard({
    required this.imageUrl,
    required this.message,
    super.key,
  });

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final MessageCardLogic logic = MessageCardLogic();
  bool isFavorite = false;
  bool _isImageLoaded = false; // Adiciona o controle do carregamento da imagem

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    isFavorite = await logic.isFavorite(widget.imageUrl, widget.message);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(17.0),
              topRight: Radius.circular(17.0),
            ),
            child: Stack(
              children: [
                // Exibe o shimmer enquanto a imagem não carrega
                if (!_isImageLoaded)
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 200,
                      color: Colors.grey[300],
                    ),
                  ),
                // Exibe a imagem e controla o shimmer
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // A imagem terminou de carregar
                      _isImageLoaded = true;
                      return child;
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.pink[100]!,
                      child: Container(
                        height: 200,
                        color: Colors.grey[300],
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Divider(
            color: Colors.grey.shade400,
            thickness: 1,
            indent: 12.0,
            endIndent: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      // Chama a função de compartilhamento
                      await logic.shareImageAndText(
                          widget.imageUrl, widget.message, context);
                    },
                    icon: const Icon(
                      Icons.share,
                      color: Colors.pink,
                    ),
                    label: const Text("COMPARTILHAR"),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    key: ValueKey<bool>(isFavorite),
                    onPressed: () async {
                      if (isFavorite) {
                        await logic.removeFavorite(
                            widget.imageUrl, widget.message);
                        setState(() {
                          isFavorite = false;
                        });
                      } else {
                        await logic.addFavorite(
                            widget.imageUrl, widget.message);
                        setState(() {
                          isFavorite = true;
                        });
                      }
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
