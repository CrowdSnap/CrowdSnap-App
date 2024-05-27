import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LikesSheet extends ConsumerStatefulWidget {
  final PostModel post;
  final ScrollController scrollController;
  final Function(DateTime) getElapsedTime;

  const LikesSheet({
    super.key,
    required this.post,
    required this.scrollController,
    required this.getElapsedTime,
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
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                        )),
                                    subtitle: Container(
                                        width: 100,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {}
                          final user = snapshot.data;
                          if (user == null) {
                            return Container();
                          }
                          return GestureDetector(
                            onTap: () {
                              context.push('/users/${user.userId}', extra: {
                                'username': user.username,
                                'avatarUrl': user.avatarUrl!,
                                'blurHashImage': widget.post.blurHashAvatar,
                              });
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
                                      widget.getElapsedTime(like.createdAt),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                subtitle: Text(user.name),
                              ),
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
}
