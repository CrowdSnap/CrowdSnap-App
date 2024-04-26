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
        } else {
          authState.googleSignUp();
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
          if (formValues.isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Image(
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
