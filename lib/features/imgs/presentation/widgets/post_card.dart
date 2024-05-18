import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/comment_create_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_add_like_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_remove_like_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  String _commentText = '';
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfUserLikedPost();
    _likeCount = widget.post.likeCount;
    _commentCount = widget.post.commentCount;
  }

  Future<void> _checkIfUserLikedPost() async {
    final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
    final userId = getUserUseCase.userId;
    final isLiked = widget.post.likes.any((like) => like.userId == userId);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  void _toggleLike() async {
    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _likeCount++;
        } else {
          _likeCount--;
        }
      });
    }
    if (_isLiked) {
      final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
      final userId = getUserUseCase.userId;
      ref
          .read(postAddLikeUseCaseProvider)
          .execute(widget.post.mongoId!, userId);
    } else {
      final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
      final userId = getUserUseCase.userId;
      ref
          .read(postRemoveLikeUseCaseProvider)
          .execute(widget.post.mongoId!, userId);
    }
  }

  void _addComment(String value) {
    final createCommentUseCase = ref.read(createCommentUseCaseProvider);
    createCommentUseCase.execute(value, widget.post.mongoId!);
    if (mounted) {
      setState(() {
        _commentCount++;
      });
    }
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

  void _showLikedUserSheet() {
    if (_likeCount == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: DraggableScrollableSheet(
              initialChildSize: 0.15,
              maxChildSize: 0.15,
              minChildSize: 0.1,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return const Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Se el primero en dar like',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              maxChildSize: 0.7,
              minChildSize: 0.15,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.post.likes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final like = widget.post.likes[index];
                            return FutureBuilder<UserModel>(
                              future: ref
                                  .read(firestoreRepositoryProvider)
                                  .getUser(like.userId),
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
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.avatarUrl!),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(user.name),
                                      const SizedBox(width: 8),
                                      Text(
                                        _getElapsedTime(like.createdAt),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(user.username),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

  void _showCommentSheet() {
    if (_commentCount == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: DraggableScrollableSheet(
              initialChildSize: 0.25,
              maxChildSize: 0.25,
              minChildSize: 0.1,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Se el primero en comentar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              onChanged: (value) {
                                setState(() {
                                  _commentText = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              _addComment(_commentText);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: DraggableScrollableSheet(
              initialChildSize: 0.3,
              maxChildSize: 0.6,
              minChildSize: 0.2,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.post.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final comment = widget.post.comments[index];
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
                                    backgroundImage: CachedNetworkImageProvider(
                                        user.avatarUrl!),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(user.name),
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
                              controller: _commentController,
                              onChanged: (value) {
                                setState(() {
                                  _commentText = value;
                                });
                              },
                              decoration: const InputDecoration(
                                hintText: 'Add a comment...',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              _addComment(_commentText);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      );
    }
  }

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
                  onPressed: () {},
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: _toggleLike,
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
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : null,
                    ),
                    onPressed: _toggleLike,
                  ),
                  GestureDetector(
                    onTap: _showLikedUserSheet,
                    child: Text(_likeCount == 1
                        ? '$_likeCount like'
                        : '$_likeCount likes'),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: _showCommentSheet,
                  ),
                  GestureDetector(
                    onTap: _showCommentSheet,
                    child: Text(_commentCount == 1
                        ? '$_commentCount comment'
                        : '$_commentCount comments'),
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
}
