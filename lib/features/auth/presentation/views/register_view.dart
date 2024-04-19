import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password_input.dart';
import 'package:crowd_snap/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              initialValue: formValues.name,
                              decoration: const InputDecoration(
                                labelText: name,
                              ),
                              onChanged: (value) =>
                                  formState.updateNombre(value),
                              keyboardType: TextInputType.name,
                            ),
                            TextFormField(
                              initialValue: formValues.name,
                              decoration: const InputDecoration(
                                labelText: userName,
                              ),
                              onChanged: (value) =>
                                  formState.updateNombre(value),
                              keyboardType: TextInputType.name,
                            ),
                            TextFormField(
                              initialValue: formValues.email,
                              decoration: const InputDecoration(
                                labelText: email,
                              ),
                              onChanged: (value) =>
                                  formState.updateEmail(value),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const PasswordInput(),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: formValues.isPasswordValid &&
                                      formValues.email.isNotEmpty
                                  ? () {
                                      authNotifier.signUp(formValues.email,
                                          formValues.password, formValues.userName);
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
                              child: const Text('Registro'),
                            ),
                            const SizedBox(height: 30),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Divider()),
                                Text('   O   ',
                                    style: TextStyle(fontSize: 14)),
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                    onPressed: () {
                      router.go('/login');
                    },
                    child: const Text('Inicia Sesión'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
