import 'package:crowd_snap/app/theme/notifier/theme_notifier.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_get_use_case.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _goHome() {
    context.go('/');
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(0);
  }

  void _getUser() {
    final getUserUseCase = ref.read(getUserUseCaseProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    getUserUseCase.execute().then((user) {
      profileNotifier.updateUserId(user.userId);
      profileNotifier.updateName(user.name);
      profileNotifier.updateEmail(user.email);
      profileNotifier.updateUserName(user.username);
      profileNotifier.updateAge(user.birthDate);
      _getAvatarUser(user.username);
    });
  }

  void _getAvatarUser(String userName) {
    final getAvatarUseCase = ref.read(avatarGetUseCaseProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    getAvatarUseCase.execute(userName).then((avatar) {
      print('Avatar from local storage: $avatar');
      profileNotifier.updateImage(avatar);
    });
  }

  void _deleteUser() async {
    final userId = ref.read(profileNotifierProvider).userId;
    final userModel = await ref.read(getUserUseCaseProvider).execute();
    print('Deleting user: $userModel');
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await ref.read(firestoreRepositoryProvider).deleteUser(userId);
      ref.read(signOutUseCaseProvider).execute();
      await ref
          .read(avatarBucketRepositoryProvider)
          .deleteUserAvatar(userModel.avatarUrl!);
    } catch (e) {
      print('Error deleting user: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to delete user. $e'),
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
  Widget build(BuildContext context) {
    final profileNotifier = ref.watch(profileNotifierProvider);
    final isDarkMode = ref.watch(darkModeProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        _goHome();
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
          Text('Age: ${profileNotifier.birthDate}'),
          ElevatedButton(
            onPressed: _deleteUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete User'),
          ),
          ElevatedButton(
              onPressed: () {
                isDarkMode.toggleDarkMode();
              },
              child: const Text('Cambiar Modo'),
            ),
            ElevatedButton(
              onPressed: () {
                authNotifier.signOut();
              },
              child: const Text('Logout'),
            ),
        ])),
      ),
    );
  }
}
