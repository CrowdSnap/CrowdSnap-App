import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LikesSheet extends ConsumerStatefulWidget {
  final PostModel post;
  final ScrollController scrollController;

  const LikesSheet({
    super.key,
    required this.post,
    required this.scrollController,
  });

  @override
  _LikesSheetState createState() => _LikesSheetState();
}

class _LikesSheetState extends ConsumerState<LikesSheet> {
  @override
  Widget build(BuildContext context) {
    final likes = ref.watch(likesNotifierProvider(widget.post.mongoId!));

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: likes.isEmpty
                ? const Center(
                    child: Text(
                      'Se el primero en darle like',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: likes.length,
                    controller: widget.scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      final like = likes[index];
                      return FutureBuilder<UserModel>(
                        future: ref
                            .read(firestoreRepositoryProvider)
                            .getUser(like.userId),
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
                          return Card(
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
                                    _getElapsedTime(like.createdAt),
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              subtitle: Text(user.name),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
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
