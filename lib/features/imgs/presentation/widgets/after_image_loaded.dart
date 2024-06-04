import 'dart:io';
import 'package:crowd_snap/features/imgs/presentation/notifier/tagged_user_ids_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AfterImageLoaded extends StatefulWidget {
  final File image;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;
  final bool isLoading;

  const AfterImageLoaded({
    super.key,
    required this.image,
    required this.onSavePressed,
    required this.onCancelPressed,
    required this.isLoading,
  });

  @override
  _AfterImageLoadedState createState() => _AfterImageLoadedState();
}

class _AfterImageLoadedState extends State<AfterImageLoaded>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showUserSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.4,
          maxChildSize: 0.7,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return UserSearchModal(scrollController: scrollController);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -5) {
          _showUserSearchModal(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Image.file(
                      widget.image,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animation.value),
                            child: Transform.rotate(
                              angle: 1.5708,
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text(
                          'Desliza hacia arriba para etiquetar usuarios'),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: widget.onSavePressed,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isLoading)
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            const Icon(Icons.upload),
                            const Text('Subir Post'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: widget.onCancelPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserSearchModal extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const UserSearchModal({super.key, required this.scrollController});

  @override
  _UserSearchModalState createState() => _UserSearchModalState();
}

class _UserSearchModalState extends ConsumerState<UserSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedUserIds = ref.read(taggedUserIdsProviderProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Usuarios',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: (_searchText.isEmpty)
                  ? FirebaseFirestore.instance
                      .collection('users')
                      .limit(6)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isGreaterThanOrEqualTo: _searchText)
                      .where('username',
                          isLessThanOrEqualTo:
                              '$_searchText\uf8ff')
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
                  controller: widget.scrollController,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedUserIds.addUserId(user.id);
                          });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          color: Theme.of(context).hoverColor,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user['avatarUrl']),
                            ),
                            title: Text(user['username']),
                            subtitle: Text(user['name']),
                            trailing: const Icon(
                              Icons.add,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Guardar Etiquetas'),
          ),
        ],
      ),
    );
  }
}
