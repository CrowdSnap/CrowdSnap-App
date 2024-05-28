import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/user_posts_repository_impl.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/add_connection_use_case.dart';
import 'package:crowd_snap/features/profile/domain/use_cases/remove_connection_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
  bool isConnected = false;
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
    final userPosts = await ref.read(userPostsRepositoryProvider).getUserPosts(widget.userId);
    final isConnected = await ref.read(usersRepositoryProvider).checkConnection(localUser.userId, widget.userId);

    if (mounted) {
      setState(() {
        this.localUser = localUser;
        this.user = user;
        this.userPosts = userPosts;
        this.isConnected = isConnected;
        connectionsCount = user.connectionsCount;
      });
    }
  }

  void _toggleConnection() {
    if (isConnected) {
      ref.read(removeConnectionUseCaseProvider).execute(localUser.userId, widget.userId);
      setState(() {
        connectionsCount--;
        isConnected = false;
      });
    } else {
      ref.read(addConnectionUseCaseProvider).execute(localUser.userId, widget.userId);
      setState(() {
        connectionsCount++;
        isConnected = true;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
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
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('@${widget.username}'), // Mostrar el nombre del usuario en el AppBar
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
        Text(user.name, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Conexiones: $connectionsCount',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            if (localUser.userId != user.userId)
            ElevatedButton(
              onPressed: _toggleConnection,
              child: Text(isConnected ? 'Desconectar' : 'Conectar'),
            ),
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
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(post.imageUrl),
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