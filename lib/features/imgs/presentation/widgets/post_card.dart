import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
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

  @override
  void initState() {
    super.initState();
    _checkIfUserLikedPost();
    _likeCount = widget.post.likedUserIds?.length ?? 0;
  }

  Future<void> _checkIfUserLikedPost() async {
    final getUserUseCase = ref.read(getUserUseCaseProvider);
    final userId = (await getUserUseCase.execute()).userId;
    if (mounted) {
      setState(() {
        _isLiked = widget.post.likedUserIds?.contains(userId) ?? false;
      });
    }
  }

  void _toggleLike() {
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
      final postAddLikeUseCase = ref.read(postAddLikeUseCaseProvider);
      postAddLikeUseCase.execute(widget.post.mongoId!);
    } else {
      final postRemoveLikeUseCase = ref.read(postRemoveLikeUseCaseProvider);
      postRemoveLikeUseCase.execute(widget.post.mongoId!);
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
                      padding: const EdgeInsets.all(8.0), // Ajusta este valor según tus necesidades
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.post.likedUserIds?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          final userId = widget.post.likedUserIds![index];
                          return FutureBuilder<UserModel>(
                            future: ref
                                .read(firestoreRepositoryProvider)
                                .getUser(userId),
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
                                title: Text(user.name),
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
                  CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(widget.post.userAvatarUrl),
                      onBackgroundImageError: (exception, stackTrace) =>
                          const Icon(Icons.person)),
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
                      child: Text('$_likeCount likes'),
                    ),
                  ],
                ),
                // Add other action buttons like comment, share, etc.
              ],
            ),
          ],
        ),
      ),
    );
  }
}
