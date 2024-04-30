import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:crowd_snap/app/router/redirect/auth_redirect_provider.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';

void main() async {
  final logger = Logger('main');
  await dotenv.load(fileName: '.env');
  dotenv.env.forEach((key, value) {
    print('$key: $value');
  });
  // Inicializa Firebase antes de ejecutar la aplicación.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // El widget ProviderScope permitirá que toda tu aplicación tenga acceso a los proveedores de Riverpod.
    ProviderScope(child: Consumer(
      builder: (context, ref, child) {
        ref.watch(authRedirectProvider);
        return const MyApp();
      },
    )),
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      logger.info('No user is signed in.');
    } else {
      logger.info('User is signed in. User details: $user');
    }
  });
}
