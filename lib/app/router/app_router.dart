import 'package:crowd_snap/features/auth/presentation/views/forgot_password_view.dart';
import 'package:crowd_snap/features/auth/presentation/views/google_sign_up_view.dart';
import 'package:crowd_snap/features/imgs/presentation/views/avatar_upload_view.dart';
import 'package:crowd_snap/features/imgs/presentation/views/image_upload_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/features/auth/presentation/views/login_view.dart';
import 'package:crowd_snap/features/auth/presentation/views/register_view.dart';
import 'package:crowd_snap/features/home/presentation/views/home_view.dart';
import 'package:crowd_snap/features/profile/presentation/views/profile_view.dart';
import 'package:crowd_snap/features/search/presentation/views/search_view.dart';
import 'package:crowd_snap/core/navbar/widgets/navbar.dart';
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
          builder: (context, state) => const ForgotPasswordView()
        ),
        GoRoute(
          path:'/avatar-upload',
          builder: (context, state) => const AvatarUploadView()
        ),
        GoRoute(
          path: '/google-sign-up',
          builder: (context, state) => const GoogleSignUpView(),

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
              path: '/search',
              builder: (context, state) => const SearchView(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileView(),
            ),
            GoRoute(
              path: '/chats',
              builder: (context, state) => const Center(
                child: Text('Chats View'),
              ),
            ),
            GoRoute(
              path: '/picture-upload',
              builder: (context, state) => const ImageUploadView()
            )
          ],
        ),
      ],
      
    );
  }
}
