import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart'
    as form_notifier;
import 'package:crowd_snap/features/auth/presentation/widgets/text_password_requirements.dart';
import 'package:crowd_snap/global/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordInput extends ConsumerWidget {

  final bool showPasswordRequirements;

  const PasswordInput({
    super.key,
    this.showPasswordRequirements = true,
  });

  InputBorder _getBorder(
      BuildContext context, form_notifier.FormState formValues,
      {bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (formValues.password.isEmpty) {
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
    } else if (isError || !formValues.isPasswordValid) {
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
    final formState = ref.watch(form_notifier.formNotifierProvider.notifier);
    final formValues = ref.watch(form_notifier.formNotifierProvider);

    return Column(
      children: [
        TextFormField(
          initialValue: formValues.password,
          decoration: InputDecoration(
            labelText: password,
            suffixIcon: IconButton(
                icon: Icon(formState.getPasswordIcon()),
                onPressed: () => formState.togglePasswordVisibility()),
            enabledBorder: _getBorder(context, formValues),
            focusedBorder: _getBorder(context, formValues),
            errorBorder: _getBorder(context, formValues, isError: true),
            focusedErrorBorder: _getBorder(context, formValues, isError: true),
          ),
          obscureText: !formValues.showPassword,
          onChanged: (value) {
            formState.updatePassword(value);
            formState.validatePasswordVisual();
          },
        ),
        const SizedBox(height: 16),
        Visibility(
          visible: showPasswordRequirements,
          child: const TextPasswordRequirements()
        ),
      ],
    );
  }
}
