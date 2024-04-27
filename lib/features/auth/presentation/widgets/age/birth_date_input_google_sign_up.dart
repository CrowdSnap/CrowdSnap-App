import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BirthDateInputGoogleSignUp extends ConsumerWidget {
  const BirthDateInputGoogleSignUp({super.key});

  InputBorder _getBorder(BuildContext context, formValues,
      {bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (formValues.birthDate == null) {
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
    } else if (isError || !formValues.isBirthDateValid) {
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
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: formValues.birthDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              formState.updateBirthDate(selectedDate);
              formState.validateBirthDateVisual();
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Fecha de nacimiento',
              hintText: 'dd/mm/yyyy',
              enabledBorder: _getBorder(context, formValues),
              focusedBorder: _getBorder(context, formValues),
              errorBorder: _getBorder(context, formValues, isError: true),
              focusedErrorBorder:
                  _getBorder(context, formValues, isError: true),
            ),
            child: Text(
              formValues.birthDate != null
                  ? DateFormat('dd/MM/yyyy').format(formValues.birthDate!)
                  : '',
            ),
          ),
        ),
        Visibility(
          visible: formValues.birthDate != null && !formValues.isBirthDateValid,
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
