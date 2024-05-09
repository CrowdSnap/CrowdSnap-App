import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/comment_repository_impl.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/like_repository_impl.dart';
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
    final isLiked = widget.post.likedUserIds.contains(userId);
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

  void _showLikedUserSheet() {
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
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<LikeModel>>(
                        future: ref
                            .read(likeRepositoryProvider)
                            .getLikesByPostId(widget.post.mongoId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final likes = snapshot.data;
                          if (likes == null || likes.isEmpty) {
                            return const Text('No likes found');
                          }
                          return ListView.builder(
                            controller: scrollController,
                            itemCount: likes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final like = likes[index];
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
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              user.avatarUrl!),
                                    ),
                                    title: Text(user.name),
                                    subtitle: Text(user.username),
                                  );
                                },
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

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List<CommentModel>>(
                        future: ref
                            .read(commentRepositoryProvider)
                            .getCommentsByPost(widget.post.mongoId!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          final comments = snapshot.data;
                          if (comments == null || comments.isEmpty) {
                            return const Text('No comments found');
                          }
                          return ListView.builder(
                            controller: scrollController,
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
                                          CachedNetworkImageProvider(
                                              user.avatarUrl!),
                                    ),
                                    title: Text(user.name),
                                    subtitle: Text(comment.text),
                                  );
                                },
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
                              print('Comment text: $_commentText');
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

  void _addComment(String value) {
    final createCommentUseCase = ref.read(createCommentUseCaseProvider);
    createCommentUseCase.execute(value, widget.post.mongoId!);
    if (mounted) {
      setState(() {
        _commentCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Container(
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
                ],
              ),
            ),
            CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
