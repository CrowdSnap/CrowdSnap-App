import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AgeInputGoogleSignUp extends ConsumerWidget {
  const AgeInputGoogleSignUp({super.key});

  InputBorder _getBorder(
      BuildContext context, formValues,
      {bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (formValues.age == 0) {
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
    } else if (isError || !formValues.isAgeValid) {
      return theme.inputDecorationTheme.errorBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.error),
          );
    } else {
      return theme.inputDecorationTheme.focusedBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outline),
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(googleSignUpNotifierProvider.notifier);
    final formValues = ref.watch(googleSignUpNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Edad',
            enabledBorder: _getBorder(context, formValues),
            focusedBorder: _getBorder(context, formValues),
            errorBorder: _getBorder(context, formValues, isError: true),
            focusedErrorBorder: _getBorder(context, formValues, isError: true),
          ),
          onChanged: (value) {
            formState.updateAge(int.tryParse(value) ?? 0);
            formState.validateAgeVisual();
          },
          keyboardType: TextInputType.number,
        ),
        Visibility(
          visible: formValues.age > 0 && !formValues.isAgeValid,
          child: const Column(
            children: [
              SizedBox(height: 12),
              Text(
                '✗  Debes tener al menos 18 años para registrarte',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
