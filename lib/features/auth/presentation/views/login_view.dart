import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password_input.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              initialValue: formValues.email,
                              decoration: const InputDecoration(
                                labelText: email,
                              ),
                              onChanged: (value) =>
                                  formState.updateEmail(value),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const PasswordInput(
                                showPasswordRequirements: false),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: formValues.isPasswordValid &&
                                      formValues.email.isNotEmpty
                                  ? () async {
                                      formState.startLoading();
                                      final signInSuccess =
                                          await authNotifier.signIn(
                                              formValues.email,
                                              formValues.password);
                                      if (signInSuccess) {
                                        authState.profileComplete();
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar( SnackBar(
                                                content: Row(
                                                  children: [
                                                    const Text(
                                                      'Error al iniciar sesión'
                                                    ),
                                                    TextButton(onPressed: () => context.push('/register'), child: const Text('Regístrate'))
                                                  ],
                                                )));
                                      }
                                      formState.stopLoading();
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
                                  const Text('Login'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Divider()),
                                Text('   O   ', style: TextStyle(fontSize: 14)),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 30),
                            GoogleSignInButton(onPressed: () {
                              // Call signInWithGoogle method
                              authNotifier.signInWithGoogle();
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => context.go('/avatar-upload'),
                child: const Text('Avatar Upload')),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta?'),
                TextButton(
                    onPressed: () {
                      router.push('/register');
                    },
                    child: const Text('Regístrate'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
