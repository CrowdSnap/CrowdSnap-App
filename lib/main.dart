import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crowd_snap/features/auth/presentation/provider/auth_redirect_provider.dart';
import 'firebase_options.dart';

void main() async {
  // Inicializa Firebase antes de ejecutar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // El widget ProviderScope permitirá que toda tu aplicación tenga acceso a los proveedores de Riverpod.
    ProviderScope(
      child: Consumer(
        builder: (context, ref, child) {
          ref.watch(authRedirectProvider);
          return const MyApp();
        }, 
      )
    ),
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('No user is signed in.');
    } else {
      print('User is signed in. User details: $user');
    }
  });
}