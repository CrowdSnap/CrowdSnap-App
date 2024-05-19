import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';

class CommentsSheet extends ConsumerStatefulWidget {
  final PostModel post;
  final TextEditingController commentController;
  final Function(String) addComment;
  final ScrollController scrollController;

  const CommentsSheet({
    super.key,
    required this.post,
    required this.commentController,
    required this.addComment,
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
                            return const SizedBox(
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(),
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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  CachedNetworkImageProvider(user.avatarUrl!),
                            ),
                            title: Row(
                              children: [
                                Text(user.username),
                                const SizedBox(width: 8),
                                Text(
                                  _getElapsedTime(comment.createdAt),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            subtitle: Text(comment.text),
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
                    hintText: 'Add a comment...',
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
