import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:octo_image/octo_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';

class PostWidget extends ConsumerStatefulWidget {
  final PostModel post;
  final Function() showLikedUserSheet;
  final Function() showCommentSheet;
  final Function() toggleLike;
  final Function(BuildContext context) showPopupMenu;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  const PostWidget({
    super.key,
    required this.post,
    required this.showLikedUserSheet,
    required this.showCommentSheet,
    required this.toggleLike,
    required this.showPopupMenu,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.userAvatarUrl,
                    placeholder: (context, url) => ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: BlurHash(
                          hash: widget.post.blurHashAvatar,
                          imageFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutDuration: const Duration(milliseconds: 400),
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    widget.showPopupMenu(context);
                  },
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              const maxHeight = 650.0;
              const minHeight = 200.0;
              final height =
                  (maxWidth / widget.post.aspectRatio).clamp(minHeight, maxHeight);

              final likesAndComments = Center(
                child: IntrinsicWidth(
                  child: Container(
                     decoration: BoxDecoration(
                      color: height < 300 ? Colors.transparent : Colors.grey[800]?.withOpacity(0.85), // Fondo semitransparente o transparente
                      borderRadius: BorderRadius.circular(15.0), // Borde redondeado
                      boxShadow: height >= 300
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 3), // Sombra
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                widget.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.isLiked ? Colors.red : null,
                              ),
                              onPressed: widget.toggleLike,
                            ),
                            GestureDetector(
                              onTap: widget.showLikedUserSheet,
                              child: Text(widget.likeCount == 1
                                  ? '${widget.likeCount} Like'
                                  : '${widget.likeCount} Likes'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0),
                        GestureDetector(
                          onTap: widget.showCommentSheet,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.comment),
                                onPressed: widget.showCommentSheet,
                              ),
                              Text(widget.commentCount == 1
                                  ? '${widget.commentCount} Comentario  '
                                  : '${widget.commentCount} Comentarios  '),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              return Column(
                children: [
                  GestureDetector(
                    onDoubleTap: widget.toggleLike,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: height,
                              width: maxWidth,
                              child: OctoImage(
                                image: CachedNetworkImageProvider(widget.post.imageUrl),
                                placeholderBuilder: (context) => SizedBox.expand(
                                  child: Image(
                                    image: BlurHashImage(widget.post.blurHashImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(milliseconds: 400),
                                fadeOutDuration: const Duration(milliseconds: 400),
                              ),
                            ),
                            if (height >= 300)
                              Positioned(
                                bottom: 8.0,
                                left: 0.0,
                                right: 0.0,
                                child: likesAndComments,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (height < 300) likesAndComments,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _getElapsedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks semana${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${difference.inSeconds} segundo${difference.inSeconds > 1 ? 's' : ''}';
    }
  }
}