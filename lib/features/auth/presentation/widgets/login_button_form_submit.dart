import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButtonFormSubmit extends ConsumerWidget {
  const LoginButtonFormSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authStateProvider.notifier);

    return ElevatedButton(
      onPressed: formValues.isPasswordValid && formValues.email.isNotEmpty
          ? () async {
              formState.startLoading();
              final signInSuccess = await authNotifier.signIn(
                  formValues.email, formValues.password);
              if (signInSuccess) {
                authState.profileComplete();
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error al iniciar sesión'),
                    TextButton(
                        onPressed: () => router.push('/register'),
                        child: const Text('Regístrate'))
                  ],
                )));
              }
              formState.stopLoading();
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            formValues.isPasswordValid && formValues.email.isNotEmpty
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        foregroundColor:
            formValues.isPasswordValid && formValues.email.isNotEmpty
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
          const Text('Login'),
        ],
      ),
    );
  }
}
