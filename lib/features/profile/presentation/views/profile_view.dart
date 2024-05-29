import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/store_user_use_case.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/user_posts_repository_impl.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late PageController _pageController;
  late Future<void> _initializationFuture;
  late List<PostModel> userPosts;
  late UserModel localUser;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializationFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    localUser = await ref.read(getUserLocalUseCaseProvider).execute();
    final userPosts = await ref
        .read(userPostsRepositoryProvider)
        .getUserPosts(localUser.userId);
    final updatedUser =
        await ref.read(usersRepositoryProvider).getUser(localUser.userId);

    if (mounted) {
      ref.read(profileNotifierProvider.notifier).updatePosts(userPosts);
      ref
          .read(profileNotifierProvider.notifier)
          .updateConnectionsCount(updatedUser.connectionsCount);
    }

    // Actualiza el usuario de Shared Preferences.
    await ref.read(storeUserUseCaseProvider).execute(
          UserModel(
            userId: updatedUser.userId,
            username: updatedUser.username,
            name: updatedUser.name,
            email: updatedUser.email,
            joinedAt: updatedUser.joinedAt,
            birthDate: updatedUser.birthDate,
            firstTime: updatedUser.firstTime,
            connectionsCount: updatedUser.connectionsCount,
            statusString: updatedUser.statusString,
            avatarUrl: updatedUser.avatarUrl,
            blurHashImage: updatedUser.blurHashImage,
            city: updatedUser.city,
          ),
        );

    await ref.read(userRepositoryProvider).savePosts(userPosts);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGridSelected(int index, ProfileNotifier profileNotifier) {
    profileNotifier.updateIndex(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/'); // Redirige a la ruta raíz.
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(
        0); // Actualiza el índice de la barra de navegación inferior a 0.
  }

  double _calculateHeight(ProfileState profileValues, int index) {
    const width = 411.42857142857144;
    final double height =
        profileValues.posts.sublist(0, index).fold(0, (previousValue, post) {
      final aspectRatio = post.aspectRatio;
      return previousValue + (width / aspectRatio);
    });

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final profileValues = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _goHome(context, ref);
      },
      child: FutureBuilder<void>(
          future: _initializationFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Consumer(
                builder: (context, ref, child) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(profileValues.userName),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            ref.read(appRouterProvider).push('/settings');
                          },
                        ),
                      ],
                    ),
                    body: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Center(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: profileValues.image != null
                                  ? FileImage(profileValues.image!)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileValues.name,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Text(
                                  profileValues.connectionsCount.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'Conexiones',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.grid_on),
                              color: profileValues.index == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              onPressed: () =>
                                  _onGridSelected(0, profileNotifier),
                            ),
                            IconButton(
                              icon: const Icon(Icons.person),
                              color: profileValues.index == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              onPressed: () =>
                                  _onGridSelected(1, profileNotifier),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              profileNotifier.updateIndex(index);
                            },
                            children: [
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount: profileValues.posts.length,
                                itemBuilder: (context, index) {
                                  final post = profileValues.posts[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: CachedNetworkImageProvider(
                                          post.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount:
                                    0, // Reemplaza con el número real de posts etiquetados
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
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Scaffold(
                appBar: AppBar(
                  title: Text(profileValues.userName),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        ref.read(appRouterProvider).push('/settings');
                      },
                    ),
                  ],
                ),
                body: Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Center(
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: profileValues.image != null
                                  ? FileImage(profileValues.image!)
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileValues.name,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Text(
                                  profileValues.connectionsCount.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  'Conexiones',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.grid_on),
                              color: profileValues.index == 0
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              onPressed: () =>
                                  _onGridSelected(0, profileNotifier),
                            ),
                            IconButton(
                              icon: const Icon(Icons.person),
                              color: profileValues.index == 1
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              onPressed: () =>
                                  _onGridSelected(1, profileNotifier),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              profileNotifier.updateIndex(index);
                            },
                            children: [
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount: profileValues.posts.length,
                                itemBuilder: (context, index) {
                                  final post = profileValues.posts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      ref.read(appRouterProvider).push(
                                        '/posts-list',
                                        extra: {
                                          'posts': profileValues.posts,
                                          'height': _calculateHeight(
                                              profileValues, index),
                                        },
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: CachedNetworkImageProvider(
                                            post.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                ),
                                itemCount:
                                    0, // Reemplaza con el número real de posts etiquetados
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
                        ),
                      ],
                    );
                  },
                ));
          }),
    );
  }
}
