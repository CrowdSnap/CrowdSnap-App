import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoogleUserNameInput extends ConsumerStatefulWidget {
  const GoogleUserNameInput({
    super.key,
  });

  @override
  _GoogleUserNameInputState createState() => _GoogleUserNameInputState();
}

class _GoogleUserNameInputState extends ConsumerState<GoogleUserNameInput> {

  InputBorder _getBorder(
      BuildContext context, GoogleSignUpState formValues, String userName,
      {bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (formValues.userName.isEmpty) {
      return theme.inputDecorationTheme.enabledBorder ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: colorScheme.onSurfaceVariant),
          );
    } else if (isError || !formValues.isUserNameValid) {
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
  Widget build(BuildContext context) {
    final formState = ref.watch(googleSignUpNotifierProvider.notifier);
    final formValues = ref.watch(googleSignUpNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: formValues.userName,
          decoration: InputDecoration(
            labelText: 'Nombre de usuario',
            enabledBorder: _getBorder(context, formValues, formValues.userName),
            focusedBorder: _getBorder(context, formValues, formValues.userName),
            errorBorder: _getBorder(context, formValues, formValues.userName,
                isError: true),
            focusedErrorBorder: _getBorder(
                context, formValues, formValues.userName,
                isError: true),
          ),
          onChanged: (value) {
            formState.updateUserName(value);
            formState.validateUserNameVisual();
            formState.setUserNamesExists(false);
            print('User name: ${formValues.userName}');
            print('User name exists: ${formValues.userNamesExists}');
            print('Is user name valid: ${formValues.isUserNameValid}');
          },
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 8.0),
        Visibility(
          visible: formValues.userNamesExists || !formValues.isUserNameValid,
          child: Text(
            formValues.userNamesExists
                ? '✗  El nombre de usuario ya existe'
                : '✗  El nombre de usuario no es válido',
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        )
      ],
    );
  }
}