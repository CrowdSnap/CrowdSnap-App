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
  // Constructor para la vista de perfil.
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  // Llamado cuando se inicializa el estado de la vista.
  @override
  void initState() {
    super.initState();
    _getUser(); // Obtiene la información del usuario al iniciar la vista.
  }

  // Navega a la pantalla de inicio.
  void _goHome() {
    context
        .go('/'); // Redirige a la ruta raíz (generalmente pantalla de inicio).
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(
        0); // Actualiza el índice del bottom navigation bar a 0 (usualmente pantalla de inicio).
  }

  // Obtiene la información del usuario utilizando un caso de uso.
  void _getUser() {
    final getUserUseCase = ref.read(
        getUserUseCaseProvider); // Obtiene el proveedor del caso de uso para obtener el usuario.
    final profileNotifier = ref.read(profileNotifierProvider
        .notifier); // Obtiene el notificador del estado del perfil.

    getUserUseCase.execute().then((user) {
      // Actualiza el estado del perfil con la información del usuario obtenida.
      profileNotifier.updateUserId(user.userId);
      profileNotifier.updateName(user.name);
      profileNotifier.updateEmail(user.email);
      profileNotifier.updateUserName(user.username);
      profileNotifier.updateAge(user.birthDate);
      _getAvatarUser(user.username); // Obtiene el avatar del usuario.
    });
  }

  // Obtiene el avatar del usuario utilizando un caso de uso.
  void _getAvatarUser(String userName) {
    final getAvatarUseCase = ref.read(
        avatarGetUseCaseProvider); // Obtiene el proveedor del caso de uso para obtener el avatar.
    final profileNotifier = ref.read(profileNotifierProvider
        .notifier); // Obtiene el notificador del estado del perfil.
    getAvatarUseCase.execute(userName).then((avatar) {
      print(
          'Avatar from local storage: $avatar'); // Imprime el avatar obtenido.
      profileNotifier
          .updateImage(avatar); // Actualiza el estado del perfil con el avatar.
    });
  }

  // Elimina el usuario actual.
  void _deleteUser() async {
    final userId = ref
        .read(profileNotifierProvider)
        .userId; // Obtiene el ID del usuario del estado del perfil.
    final userModel = await ref
        .read(getUserUseCaseProvider)
        .execute(); // Obtiene la información del usuario actual.
    print(
        'Deleting user: $userModel'); // Imprime información del usuario a eliminar (opcional para debug).
    try {
      // Elimina el usuario de Firebase Auth y Firestore.
      await FirebaseAuth.instance.currentUser?.delete();
      await ref.read(firestoreRepositoryProvider).deleteUser(userId);
      ref
          .read(signOutUseCaseProvider)
          .execute(); // Cierra la sesión del usuario.
      // Elimina el avatar del usuario del bucket de almacenamiento (opcional, dependiendo de la implementación).
      await ref
          .read(avatarBucketRepositoryProvider)
          .deleteUserAvatar(userModel.avatarUrl!);
    } catch (e) {
      print(
          'Error deleting user: $e'); // Imprime el error al eliminar el usuario (opcional para debug).
      if (mounted) {
        // Muestra un diálogo de error si la vista aún está activa.
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

  // Construye la interfaz de la vista del perfil.
  @override
  Widget build(BuildContext context) {
    final profileNotifier = ref.watch(profileNotifierProvider);
    final isDarkMode = ref.watch(darkModeProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    return PopScope(
      // Deshabilita la acción de retroceder por hardware.
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        _goHome();
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Profile')), // Título de la barra superior.
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Muestra el avatar del usuario como un círculo.
          CircleAvatar(
            radius: 50,
            backgroundImage: profileNotifier.image != null
                ? FileImage(profileNotifier.image!)
                : null,
            child: profileNotifier.image == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          // Muestra la información del usuario obtenida del estado del perfil.
          Text('Profile ${profileNotifier.userId}'),
          Text('Name: ${profileNotifier.name}'),
          Text('Email: ${profileNotifier.email}'),
          Text('Username: ${profileNotifier.userName}'),
          Text('Age: ${profileNotifier.birthDate}'),
          // Botón para eliminar el usuario.
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
