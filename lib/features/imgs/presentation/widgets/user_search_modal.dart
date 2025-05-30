import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowd_snap/features/profile/data/models/user_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/tagged_user_ids_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchModal extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final File image;

  const UserSearchModal(
      {super.key, required this.scrollController, required this.image});

  @override
  _UserSearchModalState createState() => _UserSearchModalState();
}

class _UserSearchModalState extends ConsumerState<UserSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  late UserModel localUser;
  bool added = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final getUserLocal = ref.read(getUserLocalUseCaseProvider);
      UserModel user = await getUserLocal.execute();
      setState(() {
        localUser = user;
      });
    });

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
    final selectedUserIds = ref.watch(taggedUserIdsProviderProvider);
    final selectedUserIdsNotifier =
        ref.read(taggedUserIdsProviderProvider.notifier);

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
                      .where(FieldPath.documentId,
                          isNotEqualTo: localUser.userId)
                      .limit(6)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isGreaterThanOrEqualTo: _searchText)
                      .where('username',
                          isLessThanOrEqualTo: '$_searchText\uf8ff')
                      .where(FieldPath.documentId,
                          isNotEqualTo: localUser.userId)
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
                    final isSelected = selectedUserIds.contains(user.id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: GestureDetector(
                        onTap: () {
                          if (!isSelected) {
                            selectedUserIdsNotifier.addUserId(user.id);
                          } else {
                            selectedUserIdsNotifier.removeUserId(user.id);
                          }
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
                            trailing: Icon(
                              isSelected ? Icons.remove : Icons.add,
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
        ],
      ),
    );
  }
}
