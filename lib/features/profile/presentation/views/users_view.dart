import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/add_connection_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/get_user_posts_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/get_user_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/remove_connection_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/connection_status_provider.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/connections_counter.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/is_connected_provider.dart';
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
    final connectionStatusAsyncValue =
        ref.watch(connectionStatusProviderProvider(userId));

    return userProfileAsyncValue.when(
      data: (user) {
        // Inicializar el contador de conexiones con el valor del usuario
        ref.read(connectionsCounterProvider(user.connectionsCount).notifier);

        return Scaffold(
          appBar: AppBar(
            title: Text(
                '@$username'), // Mostrar el nombre del usuario en el AppBar
          ),
          body: _buildUserProfile(context, user, userPostsAsyncValue,
              connectionStatusAsyncValue, ref),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title:
              Text('@$username'), // Mostrar el nombre del usuario en el AppBar
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipOval(
                    child: BlurHash(
                      hash: blurHashImage,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Skeletonizer(
              enabled: true,
              child: Container(
                width: 300,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'), // Título en caso de error
        ),
        body: const Center(
            child: Text('Usuario no encontrado probablemente se eliminó')),
      ),
    );
  }

  Future<UserModel> getLocalUser(WidgetRef ref) async {
    final getUserUseCase = ref.read(getUserLocalUseCaseProvider);
    return await getUserUseCase.execute();
  }

  Widget _buildUserProfile(
      BuildContext context,
      UserModel user,
      AsyncValue<List<PostModel>> userPostsAsyncValue,
      AsyncValue<bool> connectionStatusAsyncValue,
      WidgetRef ref) {
    final userValues = ref.watch(usersNotifierProvider);
    final usersNotifier = ref.read(usersNotifierProvider.notifier);
    final pageController = PageController();
    final counterState =
        ref.watch(connectionsCounterProvider(user.connectionsCount));
    final isconnectedState =
        ref.watch(connectionStatusProviderProvider(user.userId));

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
        Text(user.name, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Conexiones: ${counterState.count}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<UserModel>(
              future: getLocalUser(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Skeletonizer(
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final localUser = snapshot.data!;
                  if (localUser.userId == user.userId) {
                    return Container(); // No mostrar el botón si es el mismo usuario
                  } else {
                    return connectionStatusAsyncValue.when(
                      data: (isFollowing) => ElevatedButton(
                        onPressed: () {
                          if (isFollowing) {
                            ref
                                .read(removeConnectionUseCaseProvider)
                                .execute(localUser.userId, user.userId);
                            ref
                                .read(connectionsCounterProvider(
                                        user.connectionsCount)
                                    .notifier)
                                .decrement();
                            ref
                                .read(isConnectedProvider(isFollowing).notifier)
                                .setDisconnected();
                          } else {
                            ref
                                .read(addConnectionUseCaseProvider)
                                .execute(localUser.userId, user.userId);
                            ref
                                .read(connectionsCounterProvider(
                                        user.connectionsCount)
                                    .notifier)
                                .increment();
                            ref
                                .read(isConnectedProvider(isFollowing).notifier)
                                .setDisconnected();
                          }
                        },
                        child: Text(isFollowing
                            ? 'Desconectar'
                            : 'Conectar con ${user.name.split(' ')[0]}'),
                      ),
                      loading: () => Container(),
                      error: (error, stack) => Text('Error: $error'),
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.grid_on),
              color: userValues.index == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () =>
                  _onGridSelected(0, usersNotifier, pageController),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: userValues.index == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () =>
                  _onGridSelected(1, usersNotifier, pageController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: userPostsAsyncValue.when(
              data: (posts) => PageView(
                key: const ValueKey('posts'),
                controller: pageController,
                onPageChanged: (index) {
                  usersNotifier.updateIndex(index);
                },
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                  ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(post.imageUrl),
                        ),
                        title: Text(post.userName),
                        subtitle: Text(post.description ?? ''),
                      );
                    },
                  ),
                ],
              ),
              loading: () => PageView(
                key: const ValueKey('loading'),
                controller: pageController,
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          effect:
                              const ShimmerEffect(), // Añadir efecto shimmer
                          child: Container(
                            color: Colors.grey[800],
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
                    itemCount: 9, // Número de placeholders que deseas mostrar
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Skeletonizer(
                          enabled: true,
                          effect:
                              const ShimmerEffect(), // Añadir efecto shimmer
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

  void _onGridSelected(
      int index, UsersNotifier usersNotifier, PageController pageController) {
    usersNotifier.updateIndex(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
