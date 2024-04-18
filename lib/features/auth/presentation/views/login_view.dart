import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password_input.dart';
import 'package:crowd_snap/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:logging/logging.dart';

final _logger = Logger('LoginView');

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
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
                    const PasswordInput(showPasswordRequirements: false),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          formValues.isPasswordValid && formValues.email.isNotEmpty
                              ? () {
                                  authNotifier.signIn(
                                      formValues.email, formValues.password);
                                }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formValues.isPasswordValid &&
                                formValues.email.isNotEmpty
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                        foregroundColor: formValues.isPasswordValid &&
                                formValues.email.isNotEmpty
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.38),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 22),
                    GoogleSignInButton(onPressed: () {
                      // Call signInWithGoogle method
                      authNotifier.signInWithGoogle();
                    }),
                    const SizedBox(height: 40),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider()),
                        Text('   O   ', style: TextStyle(fontSize: 14)),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        router.push('/forgot-password');
                      },
                      child: const Text('¿Has olvidado tu contraseña?'),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        router.push('/register');
                      },
                      child: const Text('Regístrate'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
