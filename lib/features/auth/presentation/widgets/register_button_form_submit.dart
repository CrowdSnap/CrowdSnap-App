import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterButtonFormSubmit extends ConsumerWidget {
  const RegisterButtonFormSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authStateProvider.notifier);

    return ElevatedButton(
      onPressed: formValues.isPasswordValid &&
              formValues.email.isNotEmpty &&
              formValues.userName.isNotEmpty &&
              formValues.name.isNotEmpty
          ? () async {
              formState.startLoading();
              final signUpResult = await authNotifier.signUp(
                formValues.email,
                formValues.password,
                formValues.userName,
                formValues.name,
              );
              if (signUpResult == SignUpResult.success) {
                authState.loggedIn();
              } else {
                String errorMessage;
                switch (signUpResult) {
                  case SignUpResult.emailAlreadyInUse:
                    errorMessage = 'El correo ya está registrado';
                    break;
                  case SignUpResult.accountExistsWithGoogle:
                    errorMessage = 'La cuenta ya está registrada con Google';
                    break;
                  default:
                    errorMessage = 'Error al registrarse';
                }
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage),
                      if (signUpResult == SignUpResult.emailAlreadyInUse ||
                          signUpResult == SignUpResult.accountExistsWithGoogle)
                        TextButton(
                          onPressed: () => router.go('/login'),
                          child: const Text('Inicia sesión'),
                        ),
                    ],
                  )),
                );
              }
              formState.stopLoading();
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: formValues.isPasswordValid &&
                formValues.email.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.name.isNotEmpty
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
        foregroundColor: formValues.isPasswordValid &&
                formValues.email.isNotEmpty &&
                formValues.userName.isNotEmpty &&
                formValues.name.isNotEmpty
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
          const Text('Registro'),
        ],
      ),
    );
  }
}
