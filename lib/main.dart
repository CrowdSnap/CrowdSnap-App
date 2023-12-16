import 'package:crowd_snap/config/router/router.dart';
import 'package:crowd_snap/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  // Asegura que los servicios de Flutter estén inicializados antes de cualquier otra cosa
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Riverpod
  const ProviderScope(
    child: MyApp(),
  );
  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provee el router de la aplicación
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'CrowdSnap',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme(isDarkMode: true).getTheme(),
    );
  }
}
