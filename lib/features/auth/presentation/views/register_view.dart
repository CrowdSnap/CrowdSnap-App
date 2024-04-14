import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password_input.dart';
import 'package:crowd_snap/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: formValues.email,
              decoration: const InputDecoration(
                labelText: email,
              ),
              onChanged: (value) => formState.updateEmail(value),
            ),
            const PasswordInput(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  formValues.isPasswordValid && formValues.email.isNotEmpty
                      ? () {
                          authNotifier.signUp(
                              formValues.email, formValues.password);
                        }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: formValues.isPasswordValid &&
                        formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                foregroundColor: formValues.isPasswordValid &&
                        formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
              ),
              child: const Text('Register'),
            ),
            GoogleSignInButton(onPressed: () {
              // Call signInWithGoogle method
              authNotifier.signInWithGoogle();
            }),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
