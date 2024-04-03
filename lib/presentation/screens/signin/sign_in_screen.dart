import 'package:crowd_snap/presentation/providers/auth/google/auth_google_repo_provider.dart';
import 'package:crowd_snap/presentation/widgets/GoogleSignInButton.dart';
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
        child: authGoogle.when(
          data: (_) => GoogleSignInButton(
            onPressed: () => ref.read(authGoogleProvider),
          ),
          loading: () => GoogleSignInButton(
            isLoading: true,
            onPressed: () {},
          ),
          error: (error, _) => Text('Error: $error'),
        ),
      ),
    );
  }
}
