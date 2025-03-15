import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:myapp/messagecard/message_cardlogic.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeFavoriteState();
  }

  Future<void> _initializeFavoriteState() async {
    isFavorite = await logic.isFavorite(widget.imageUrl, widget.message);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(),
          _buildMessageSection(),
          _buildActionsSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            //   height: 200, // Defina uma altura fixa
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: Icon(
                Icons.error,
                color: Colors.red,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.message,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
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
                  borderRadius: BorderRadius.circular(25.0),
                ),
                side: BorderSide(color: Colors.pink), // Borda personalizada
              ),
            ),
          ),
          const SizedBox(width: 2.0),
          IconButton(
            onPressed: () async {
              if (isFavorite) {
                await logic.removeFavorite(widget.imageUrl, widget.message);
              } else {
                await logic.addFavorite(widget.imageUrl, widget.message);
              }
              setState(() => isFavorite = !isFavorite);
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }
}
