import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/login_button_form_submit.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/password/password_input.dart';
import 'package:crowd_snap/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);

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
                            const LoginButtonFormSubmit(),
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
                            const GoogleSignInButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => context.push('/avatar-upload'),
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
