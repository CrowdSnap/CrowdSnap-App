import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/block_scroll.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostsListView extends ConsumerWidget {
  final List<PostModel> posts;
  final double height;

  const PostsListView({super.key, required this.posts, required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController scrollController = ScrollController(
      initialScrollOffset:
          height, // Ajusta este valor según la altura de tus elementos
    );
    final blockScroll = ref.watch(blockScrollProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
      ),
      body: ListView.builder(
        physics: blockScroll
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics(),
        controller: scrollController,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }
}
