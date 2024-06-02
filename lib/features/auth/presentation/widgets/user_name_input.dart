import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart'
    as form_notifier;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNameInput extends ConsumerStatefulWidget {
  const UserNameInput({
    super.key,
  });

  @override
  _UserNameInputState createState() => _UserNameInputState();
}

class _UserNameInputState extends ConsumerState<UserNameInput> {
  bool _hasInteracted = false;

  InputBorder _getBorder(
      BuildContext context, form_notifier.FormState formValues, String userName,
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
    final formState = ref.watch(form_notifier.formNotifierProvider.notifier);
    final formValues = ref.watch(form_notifier.formNotifierProvider);

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
            setState(() {
              _hasInteracted = true;
            });
            formState.updateUserName(value);
            formState.validateUserNameVisual();
            formState.setUserNamesExists(false);
          },
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 8.0),
        Visibility(
          visible: _hasInteracted && (!formValues.isUserNameValid || formValues.userNamesExists),
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