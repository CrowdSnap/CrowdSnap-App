import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/'); // Redirige a la ruta raíz.
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(
        0); // Actualiza el índice de la barra de navegación inferior a 0.
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('¿Que buscas?'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (_searchQuery.isEmpty)
                    ? FirebaseFirestore.instance
                        .collection('users')
                        .limit(6)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('users')
                        .where('username', isGreaterThanOrEqualTo: _searchQuery)
                        .where('username',
                            isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                        .limit(6)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }
                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                              '/users/${user['userId']}',
                              extra: {
                                'username': user['username'] as String,
                                'avatarUrl': user['avatarUrl'] as String,
                                'blurHashImage':
                                    user['blurHashImage'] as String,
                              },
                            );
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
                                  imageUrl: user['avatarUrl'],
                                  placeholder: (context, url) => ClipOval(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: BlurHash(
                                        hash: user['blurHashImage'],
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
                                  Text(user['username']),                                  
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['name']),
                                  Text(
                                    '${user['connectionsCount']} conexiones',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                              )
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
