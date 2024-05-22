import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.person),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
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
          GestureDetector(
            onDoubleTap: widget.toggleLike,
            child: CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              placeholder: (context, url) => const SizedBox(
                height: 548,
                width: 600,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: widget.isLiked ? Colors.red : null,
                    ),
                    onPressed: widget.toggleLike,
                  ),
                  GestureDetector(
                    onTap: widget.showLikedUserSheet,
                    child: Text(widget.likeCount == 1
                        ? '${widget.likeCount} like'
                        : '${widget.likeCount} likes'),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: widget.showCommentSheet,
                  ),
                  GestureDetector(
                    onTap: widget.showCommentSheet,
                    child: Text(widget.commentCount == 1
                        ? '${widget.commentCount} comment'
                        : '${widget.commentCount} comments'),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Subido hace ${_getElapsedTime(widget.post.createdAt)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
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
