import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/get_user_posts_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/get_user_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/users_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UsersView extends ConsumerWidget {
  final String userId;
  final String username;
  final String avatarUrl;
  final String blurHashImage;

  const UsersView({
    super.key,
    required this.userId,
    required this.username,
    required this.avatarUrl,
    required this.blurHashImage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsyncValue = ref.watch(userProviderProvider(userId));
    final userPostsAsyncValue = ref.watch(userPostsProviderProvider(userId));

    return userProfileAsyncValue.when(
      data: (user) => Scaffold(
        appBar: AppBar(
          title: Text('@$username'), // Mostrar el nombre del usuario en el AppBar
        ),
        body: _buildUserProfile(context, user, userPostsAsyncValue, ref),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text('@$username'), // Mostrar el nombre del usuario en el AppBar
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: ClipOval(
                    child: BlurHash(
                      hash: blurHashImage,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Skeletonizer(
              enabled: true,
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'), // Título en caso de error
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserModel user, AsyncValue<List<PostModel>> userPostsAsyncValue, WidgetRef ref) {
    final userValues = ref.watch(usersNotifierProvider);
    final usersNotifier = ref.read(usersNotifierProvider.notifier);
    final pageController = PageController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: CachedNetworkImage(
                imageUrl: user.avatarUrl!,
                placeholder: (context, url) => ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: BlurHash(
                      hash: user.blurHashImage!,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: BlurHash(
                      hash: user.blurHashImage!,
                    ),
                  ),
                ),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  backgroundImage: imageProvider,
                ),
                fadeInDuration: const Duration(milliseconds: 400),
                fadeOutDuration: const Duration(milliseconds: 400),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.grid_on),
              color: userValues.index == 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
              onPressed: () => _onGridSelected(0, usersNotifier, pageController),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: userValues.index == 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
              onPressed: () => _onGridSelected(1, usersNotifier, pageController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: userPostsAsyncValue.when(
              data: (posts) => PageView(
                key: ValueKey('posts'),
                controller: pageController,
                onPageChanged: (index) {
                  usersNotifier.updateIndex(index);
                },
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: CachedNetworkImageProvider(post.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 0, // Reemplaza con el número real de posts etiquetados
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('Tagged Post ${index + 1}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              loading: () => PageView(
                key: ValueKey('loading'),
                controller: pageController,
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 9, // Número de placeholders que deseas mostrar
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Skeletonizer(
                          enabled: true,
                          effect: const ShimmerEffect(), // Añadir efecto shimmer
                          child: Container(
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: 9, // Número de placeholders que deseas mostrar
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Skeletonizer(
                          enabled: true,
                          effect: const ShimmerEffect(), // Añadir efecto shimmer
                          child: Container(
                            color: Colors.grey[800],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ),
      ],
    );
  }

  void _onGridSelected(int index, UsersNotifier usersNotifier, PageController pageController) {
    usersNotifier.updateIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
