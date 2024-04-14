import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart';
import 'package:crowd_snap/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPassword extends ConsumerWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authNotifierProvider.notifier);
    final formState = ref.watch(formNotifierProvider.notifier);
    final formValues = ref.watch(formNotifierProvider);
    final router = ref.watch(appRouterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Recover Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: formValues.email,
              decoration: const InputDecoration(
                labelText: email,
              ),
              onChanged: (value) => formState.updateEmail(value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: formValues.email.isNotEmpty
                  ? () {
                      authNotifier.recoverPassword(formValues.email);
                      router.go('/login');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                foregroundColor: formValues.email.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onPrimary.withOpacity(0.38),
              ),
              child: const Text('Recover Password'),
            ),
          ],
        ),
      ),
    );
  }
}
