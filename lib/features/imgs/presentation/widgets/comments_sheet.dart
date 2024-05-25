import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final PostModel post;
  final TextEditingController commentController;
  final Function(String) addComment;
  final Function(DateTime) getElapsedTime;
  final Function(BuildContext, CommentModel, String) showPopupMenu;
  final ScrollController scrollController;

  const CommentsSheet({
    super.key,
    required this.post,
    required this.commentController,
    required this.addComment,
    required this.showPopupMenu,
    required this.getElapsedTime,
    required this.scrollController,
  });

  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  String _commentText = '';
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void dispose() {
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentsNotifierProvider(widget.post.mongoId!));

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: comments.isEmpty
                ? const Center(
                    child: Text(
                      'No hay comentarios',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    controller: widget.scrollController,
                    itemCount: comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      final comment = comments[index];
                      return FutureBuilder<UserModel>(
                        future: ref
                            .read(firestoreRepositoryProvider)
                            .getUser(comment.userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Skeletonizer(
                              enabled: true,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Theme.of(context).hoverColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    leading: ClipOval(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: BlurHash(
                                          hash: widget.post.blurHashAvatar,
                                          imageFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Container(
                                      width: 100,
                                      height: 10,
                                      color: Colors.grey[300],
                                    ),
                                    subtitle: Container(
                                      width: 150,
                                      height: 10,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final user = snapshot.data;
                          if (user == null) {
                            return const Text('User not found');
                          }
                          return GestureDetector(
                            onLongPress: () {
                              widget.showPopupMenu(context, comment, user.userId);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              color: Theme.of(context).hoverColor,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: user.avatarUrl!,
                                    placeholder: (context, url) => ClipOval(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: BlurHash(
                                          hash: widget.post.blurHashAvatar,
                                          imageFit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      backgroundImage: imageProvider,
                                    ),
                                    fadeInDuration:
                                        const Duration(milliseconds: 400),
                                    fadeOutDuration:
                                        const Duration(milliseconds: 400),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(user.username),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.getElapsedTime(comment.createdAt),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                subtitle: Text(comment.text),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.commentController,
                  onChanged: (value) {
                    _commentText = value;
                    _isButtonEnabled.value = _commentText.isNotEmpty;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Añade un comentario...',
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: isEnabled
                        ? () {
                            widget.addComment(_commentText);
                            _scrollToBottom();
                            widget.commentController.clear();
                            _commentText = '';
                            _isButtonEnabled.value = false;
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }
}