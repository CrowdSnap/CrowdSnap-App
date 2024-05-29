import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';

class PostsListView extends StatelessWidget {
  final List<PostModel> posts;
  final double height;

  const PostsListView({super.key, required this.posts, required this.height});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController(
      initialScrollOffset: height, // Ajusta este valor según la altura de tus elementos
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
      ),
      body: ListView.builder(
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