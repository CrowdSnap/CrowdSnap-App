import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/auth/data/data_sources/firestore_data_source.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/');
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(0);
  }

  void _getUser(BuildContext context, WidgetRef ref) {
    final getUserUseCase = ref.read(getUserUseCaseProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    getUserUseCase.execute().then((user) {
      profileNotifier.updateUserId(user.userId);
      profileNotifier.updateName(user.name);
      profileNotifier.updateEmail(user.email);
      profileNotifier.updateUserName(user.username);
      profileNotifier.updateAge(user.age);
    });
  }

  void _getAvatarUser(BuildContext context, WidgetRef ref) {
    final getAvatarUseCase = ref.read(avatarGetUseCaseProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    getAvatarUseCase.execute().then((avatar) {
      profileNotifier.updateImage(avatar);
    });
  }

  void _deleteUser(BuildContext context, WidgetRef ref) async {
    final userId = ref.read(profileNotifierProvider).userId;
    try {
      await ref.read(firestoreRepositoryProvider).deleteUser(userId);
      await FirebaseAuth.instance.currentUser?.delete();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to delete user. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileNotifier = ref.watch(profileNotifierProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: profileNotifier.image != null
                ? FileImage(profileNotifier.image!)
                : null,
            child: profileNotifier.image == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          Text('Profile ${profileNotifier.userId}'),
          Text('Name: ${profileNotifier.name}'),
          Text('Email: ${profileNotifier.email}'),
          Text('Username: ${profileNotifier.userName}'),
          Text('Age: ${profileNotifier.age}'),
          ElevatedButton(
              onPressed: () {
                _getUser(context, ref);
                _getAvatarUser(context, ref);
              },
              child: const Text('Get User')),
          ElevatedButton(
            onPressed: () {
              _deleteUser(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete User'),
          ),
        ])),
      ),
    );
  }
}
