import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/connections_modal_bottom_sheet.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/user_posts_repository_impl.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/add_connection_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/remove_connection_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/models/connection_status.dart';

class UsersView extends ConsumerStatefulWidget {
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
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends ConsumerState<UsersView> {
  late PageController pageController;
  late Future<void> _initializationFuture;
  late UserModel localUser;
  late UserModel user;
  late List<PostModel> userPosts;
  int index = 0;
  ConnectionStatus connectionStatus = ConnectionStatus.none;
  int connectionsCount = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _initializationFuture = _initializeData();
  }

  Future<void> _initializeData() async {
    final localUser = await ref.read(getUserLocalUseCaseProvider).execute();
    final user = await ref.read(usersRepositoryProvider).getUser(widget.userId);
    final userPosts =
        await ref.read(userPostsRepositoryProvider).getUserPosts(widget.userId);
    final connectionStatus = await ref
        .read(usersRepositoryProvider)
        .checkConnection(localUser.userId, widget.userId);

    if (mounted) {
      setState(() {
        this.localUser = localUser;
        this.user = user;
        this.userPosts = userPosts;
        this.connectionStatus = connectionStatus;
        connectionsCount = user.connectionsCount;
      });
    }
  }

  void _toggleConnection() {
    if (connectionStatus == ConnectionStatus.connected) {
      try {
        ref
            .read(removeConnectionUseCaseProvider)
            .execute(localUser.userId, widget.userId);

        setState(() {
          connectionsCount--;
          connectionStatus = ConnectionStatus.none;
        });
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                Text('No se pudo desconectar, inténtalo de nuevo: $e'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref
                      .read(removeConnectionUseCaseProvider)
                      .execute(localUser.userId, widget.userId),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      }
    } else if (connectionStatus == ConnectionStatus.none) {
      try {
        ref
            .read(addConnectionUseCaseProvider)
            .execute(localUser.userId, widget.userId);
        setState(() {
          connectionStatus = ConnectionStatus.waitingForAcceptance;
        });
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                Text('No se pudo conectar, inténtalo de nuevo: $e'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref
                      .read(addConnectionUseCaseProvider)
                      .execute(localUser.userId, widget.userId),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      }
    } else if (connectionStatus == ConnectionStatus.pending) {
      try {
        ref
            .read(usersRepositoryProvider)
            .acceptConnection(localUser.userId, widget.userId);
        setState(() {
          connectionStatus = ConnectionStatus.connected;
          connectionsCount++;
        });
      } on Exception catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              children: [
                Text('No se pudo conectar, inténtalo de nuevo: $e'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref
                      .read(removeConnectionUseCaseProvider)
                      .execute(localUser.userId, widget.userId),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  void _showConnectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          maxChildSize: 0.7,
          minChildSize: 0.25,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return ConnectionsModalBottomSheet(
              userId: widget.userId,
              pageController: scrollController,
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  double _calculateHeight(List<PostModel> userPosts, int index) {
    const width = 411.42857142857144;
    const otherHeights = 20 + 40 + 18;
    final double height =
        userPosts.sublist(0, index).fold(0, (previousValue, post) {
      final aspectRatio = post.aspectRatio;
      return previousValue + (width / aspectRatio);
    });

    return height + (index * otherHeights);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
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
                          hash: widget.blurHashImage,
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Skeletonizer(
                      enabled: true,
                      effect: ShimmerEffect(
                        highlightColor: Colors.grey[700]!,
                        baseColor: Colors.grey[500]!,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'User Name',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              Text(
                                '230',
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
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Desconectar'),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.grid_on),
                          color: Theme.of(context).colorScheme.primary,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.person),
                          color: Colors.grey,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        this.index = index;
                      });
                    },
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: true,
                            effect: ShimmerEffect(
                              highlightColor: Colors.grey[700]!,
                              baseColor: Colors.grey[500]!,
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                    12.0), // Bordes redondeados
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Skeletonizer(
                            enabled: true,
                            effect: ShimmerEffect(
                              highlightColor: Colors.grey[700]!,
                              baseColor: Colors.grey[500]!,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                              ),
                              title: Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Bordes redondeados
                                ),
                              ),
                              subtitle: Container(
                                width: 100,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Bordes redondeados
                                ),
                              ),
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
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
            ),
            body: _buildUserProfile(context),
          );
        }
      },
    );
  }

  Widget _buildUserProfile(BuildContext context) {
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
        Center(
          child: Text(
            user.name,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _showConnectionSheet();
              },
              child: Column(
                children: [
                  Text(
                    connectionsCount.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    connectionsCount == 1 ? 'Conexión' : 'Conexiones',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (localUser.userId != user.userId)
              if (connectionStatus == ConnectionStatus.connected)
                ElevatedButton(
                  onPressed: _toggleConnection,
                  child: const Text('Desconectar'),
                )
              else if (connectionStatus == ConnectionStatus.none)
                ElevatedButton(
                  onPressed: _toggleConnection,
                  child: const Text('Conectar'),
                )
              else if (connectionStatus == ConnectionStatus.pending)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleConnection,
                      child: const Text('Aceptar conexión'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: _toggleConnection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor:
                              Theme.of(context).colorScheme.onError,
                        ),
                        child: const Text('Rechazar')),
                  ],
                )
              else if (connectionStatus ==
                  ConnectionStatus.waitingForAcceptance)
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.38),
                  ),
                  child: const Text('Esperando aceptación'),
                )
              else if (connectionStatus == ConnectionStatus.rejected)
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.38),
                  ),
                  child: const Text('Rechazado'),
                ),
            const SizedBox(height: 16),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.grid_on),
              color: index == 0
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () => _onGridSelected(0),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: index == 1
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              onPressed: () => _onGridSelected(1),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                this.index = index;
              });
            },
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(appRouterProvider).push(
                        '/posts-list',
                        extra: {
                          'posts': userPosts,
                          'height': _calculateHeight(userPosts, index),
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        image: CachedNetworkImageProvider(post.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
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
        ),
      ],
    );
  }

  void _onGridSelected(int index) {
    setState(() {
      this.index = index;
    });
    pageController.animateToPage(
      this.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
