import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/theme/notifier/theme_notifier.dart';
import 'package:crowd_snap/app/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);
    final appRouter = ref.read(appRouterProvider);

    return MaterialApp.router(
      title: 'Mi Aplicación',
      theme: AppTheme(isDarkMode: isDarkMode).getTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
