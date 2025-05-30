import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConnectionsModalBottomSheet extends ConsumerStatefulWidget {
  final String userId;
  final ScrollController pageController;
  final UserModel user;
  final String localUserId;

  const ConnectionsModalBottomSheet({
    super.key,
    required this.userId,
    required this.pageController,
    required this.user,
    required this.localUserId,
  });

  @override
  _ConnectionsModalBottomSheetState createState() =>
      _ConnectionsModalBottomSheetState();
}

class _ConnectionsModalBottomSheetState
    extends ConsumerState<ConnectionsModalBottomSheet>
    with SingleTickerProviderStateMixin {
  late List<Map<String, DateTime>> acceptedConnections = [];
  late List<Map<String, DateTime>> rejectedConnections = [];
  late List<Map<String, DateTime>> pendingConnections = [];
  late List<Map<String, DateTime>> connections = [];
  bool _isLoading = false;
  String? _lastConnectionId;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadConnections();
    _animationController = AnimationController(vsync: this);
  }

  Future<void> _loadConnections() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    if (connections.length >= widget.user.connectionsCount) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final userConnections = await ref
        .read(usersRepositoryProvider)
        .getUserConnections(widget.userId, startAfter: _lastConnectionId);

    if (mounted) {
      setState(() {
        connections.addAll(userConnections);
        if (userConnections.isNotEmpty) {
          _lastConnectionId = userConnections.last.keys.first;
        }
        _isLoading = false;
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset(
              'assets/Secondary-Disco-Ball.json',
              controller: _animationController,
              onLoaded: (composition) {
                _animationController.duration = composition.duration *
                    (4 / 5); // Ajustar la duración para 1.5x velocidad
                _animationController.forward();
              },
              height: 75,
              width: 75,
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.user.connectionsCount == 0
                ? Center(
                    child: Text(
                      widget.user.userId == widget.localUserId
                          ? 'Aún no tienes conexiones'
                          : 'Se el primero en conectar con ${widget.user.name}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: connections.length,
                    controller: widget.pageController,
                    itemBuilder: (BuildContext context, int index) {
                      final connection = connections[index];
                      return FutureBuilder<UserModel>(
                        future: ref
                            .read(firestoreRepositoryProvider)
                            .getUser(connection.keys.first),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: Theme.of(context).hoverColor,
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                leading: Skeletonizer(
                                  enabled: true,
                                  effect: ShimmerEffect(
                                    highlightColor: Colors.grey[700]!,
                                    baseColor: Colors.grey[500]!,
                                  ),
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ),
                                ),
                                title: Skeletonizer(
                                  enabled: true,
                                  effect: ShimmerEffect(
                                    highlightColor: Colors.grey[700]!,
                                    baseColor: Colors.grey[500]!,
                                  ),
                                  child: const Row(
                                    children: [
                                      Text('User Name User'),
                                      SizedBox(width: 8),
                                      Text(
                                        'Hace 1 día',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Skeletonizer(
                                  enabled: true,
                                  effect: ShimmerEffect(
                                    highlightColor: Colors.grey[700]!,
                                    baseColor: Colors.grey[500]!,
                                  ),
                                  child: Container(
                                      width: 100,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      )),
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
                              HapticFeedback.lightImpact();
                              context.push('/users/${user.userId}', extra: {
                                'username': user.username,
                                'avatarUrl': user.avatarUrl!,
                                'blurHashImage': user.blurHashImage!,
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
                                          hash: user.blurHashImage!,
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
                                      _getElapsedTime(connection.values.first),
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
        _buildLoadingIndicator(),
      ],
    );
  }
}
