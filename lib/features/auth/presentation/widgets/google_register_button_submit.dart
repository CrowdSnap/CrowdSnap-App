import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleRegisterButtonSubmit extends ConsumerWidget {
  const GoogleRegisterButtonSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(googleSignUpNotifierProvider.notifier);
    final formValues = ref.watch(googleSignUpNotifierProvider);
    final authState = ref.watch(authStateProvider.notifier);

    return ElevatedButton(
      onPressed: () async {
        formState.updateIsLoading(true);
        final signUpResult = await authNotifier.signUpWithGoogle(
          formValues.name,
          formValues.userName,
          formValues.birthDate!,
          formValues.userImage,
        );
        if (signUpResult == SignUpResult.success) {
          print('Sign up success');
          authState.loggedIn();
        }
        print('Sign up result: $signUpResult');
        formState.updateIsLoading(false);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: formValues.name.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.isBirthDateValid
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        foregroundColor: formValues.name.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.isBirthDateValid
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
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
          const Text('Completa tu cuenta'),
        ],
      ),
    );
  }
}
