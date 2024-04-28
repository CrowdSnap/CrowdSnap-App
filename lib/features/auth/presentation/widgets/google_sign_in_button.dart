import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider.notifier);
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);

    return ElevatedButton(
      onPressed: () async {
        formState.startGoogleLoading();
        final signInSuccess = await authNotifier.signInWithGoogle();
        if (signInSuccess == SignUpResult.success) {
          authState.loggedIn();
          formState.stopGoogleLoading();
        } else if (signInSuccess == SignUpResult.googleSignUp) {
          authState.googleSignUp();
          formState.stopGoogleLoading();
        } else {
          formState.stopGoogleLoading();
        }
        formState.stopGoogleLoading();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: formValues.isLoadingGoogle
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ))
                : const Image(
                    image: AssetImage('assets/icons/google_icon.png'),
                    height: 24,
                  ),
          ),
          const Text('Sign in with Google'),
        ],
      ),
    );
  }
}
