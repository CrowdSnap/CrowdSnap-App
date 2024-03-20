import 'package:crowd_snap/presentation/providers/auth/auth_google_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign in with Google'),
          onPressed: () => ref.read(authGoogleRepositoryProvider).signInWithGoogle(),
        ),
      ),
    );
  }
}