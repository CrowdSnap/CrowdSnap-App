import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart'
    as form_notifier;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextPasswordRequirements extends ConsumerWidget {
  const TextPasswordRequirements({super.key});

  String _checkOrX(bool condition) {
    return condition ? '✓' : '✗';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formValues = ref.watch(form_notifier.formNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Requisitos de la contraseña: ',
              style: TextStyle(fontSize: 14)),
        ),
        Text(
          '${_checkOrX(formValues.password.length >= 6)}  Al menos 6 caracteres',
          style: formValues.password.length >= 6
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green)
              : Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
        ),
        // Letra mayúscula y minúscula
        Text(
          '${_checkOrX(formValues.password.contains(RegExp(r'[A-Z]')) && formValues.password.contains(RegExp(r'[a-z]')))}  Incluye una letra mayúscula y una minúscula',
          style: formValues.password.contains(RegExp(r'[A-Z]')) &&
                  formValues.password.contains(RegExp(r'[a-z]'))
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green)
              : Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
        ),
        Text(
          '${_checkOrX(formValues.password.contains(RegExp(r'[0-9]')))}  Incluye un número (0-9)',
          style: formValues.password.contains(RegExp(r'[0-9]'))
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green)
              : Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
        ),
        Text(
          '${_checkOrX(formValues.password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')))}  Incluye un carácter especial',
          style: formValues.password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.green)
              : Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red),
        )
      ],
    );
  }
}
