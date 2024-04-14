import 'package:crowd_snap/features/auth/presentation/views/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/features/auth/presentation/views/login_view.dart';
import 'package:crowd_snap/features/auth/presentation/views/register_view.dart';
import 'package:crowd_snap/features/home/presentation/views/home_view.dart';
import 'package:crowd_snap/features/profile/presentation/views/profile_view.dart';
import 'package:crowd_snap/features/settings/presentation/views/settings_view.dart';
import 'package:crowd_snap/global/navbar/widgets/navbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
class AppRouter extends _$AppRouter {
  @override
  GoRouter build() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterView(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPassword()
        ),
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              bottomNavigationBar: const NavBar(),
            );
          },
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeView(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsView(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    );
  }
}
