import 'package:crowd_snap/app/theme/notifier/theme_notifier.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsView extends ConsumerWidget {
  // Constructor para la vista de búsqueda.
  const SettingsView({super.key});

  void _deleteUser(BuildContext context, WidgetRef ref) async {
    final userId = ref
        .read(profileNotifierProvider)
        .userId; // Obtiene el ID del usuario del estado del perfil.
    final userModel = await ref
        .read(getUserLocalUseCaseProvider)
        .execute(); // Obtiene la información del usuario actual.
    print(
        'Deleting user: $userModel'); // Imprime información del usuario a eliminar (opcional para debug).

    try {
      // Elimina el avatar del usuario del bucket de almacenamiento (opcional, dependiendo de la implementación).
      await ref
          .read(avatarBucketRepositoryProvider)
          .deleteUserAvatar(userModel.avatarUrl!);
      // Elimina el usuario de Firestore.
      await ref.read(firestoreRepositoryProvider).deleteUser(userId);
      // Elimina el usuario de Firebase Auth.
      await FirebaseAuth.instance.currentUser?.delete();
      // Cierra la sesión del usuario.
      ref.read(signOutUseCaseProvider).execute();
    } catch (e) {
      print(
          'Error deleting user: $e'); // Imprime el error al eliminar el usuario (opcional para debug).

      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          bool isPasswordProvider = false;
          for (var info in user.providerData) {
            if (info.providerId == 'password') {
              isPasswordProvider = true;
              break;
            }
          }

          if (isPasswordProvider) {
            // Muestra un diálogo para que el usuario ingrese su contraseña.
            String? password;
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reautenticación requerida'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Por favor, ingrese su contraseña para continuar.'),
                    TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, password),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
            );

            if (password != null) {
              try {
                // Reautenticar al usuario
                AuthCredential credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: password!,
                );

                await user.reauthenticateWithCredential(credential);

                // Intentar eliminar al usuario nuevamente
                await FirebaseAuth.instance.currentUser?.delete();
                ref.read(signOutUseCaseProvider).execute();
              } catch (reauthError) {
                print('Error reautenticando usuario: $reauthError');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content:
                        Text('Failed to reauthenticate user. $reauthError'),
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
          } else {
            // Reautenticar al usuario con Google
            try {
              GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
              if (googleUser != null) {
                GoogleSignInAuthentication googleAuth =
                    await googleUser.authentication;
                AuthCredential credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );

                await user.reauthenticateWithCredential(credential);

                // Intentar eliminar al usuario nuevamente
                await FirebaseAuth.instance.currentUser?.delete();
                ref.read(signOutUseCaseProvider).execute();
              }
            } catch (reauthError) {
              print('Error reautenticando usuario: $reauthError');
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Failed to reauthenticate user. $reauthError'),
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
      } else {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider.notifier);
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final profileValues = ref.read(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings') // Título de la barra de aplicaciones.
          ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _deleteUser(context, ref),
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
            Text('Profile ${profileValues.userId}'),
          ],
        ),
      ),
    );
  }
}
