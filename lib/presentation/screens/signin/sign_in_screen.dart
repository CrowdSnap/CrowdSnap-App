import 'package:crowd_snap/presentation/providers/auth/google/auth_google_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authGoogle = ref.watch(authGoogleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          child: authGoogle.when(
            data: (_) => const Text('Sign in with Google'),
            loading: () => const CircularProgressIndicator(),
            error: (error, _) => Text('Error: $error'),
          ),
          onPressed: () {
            ref.read(authGoogleProvider);
          }
        ),
      ),
    );
  }
}