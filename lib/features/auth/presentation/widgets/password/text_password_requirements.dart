import 'package:crowd_snap/features/auth/presentation/notifier/form_notifier.dart'
    as form_notifier;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `TextPasswordRequirements` que extiende `ConsumerWidget` para utilizar datos de un proveedor.
class TextPasswordRequirements extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const TextPasswordRequirements({super.key});

  // Método privado que devuelve un check (✓) o una X (✗) según una condición.
  String _checkOrX(bool condition) {
    return condition ? '✓' : '✗';
  }

  // Método `build` que define la interfaz de usuario del widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene los valores del formulario utilizando el proveedor `formNotifierProvider`.
    final formValues = ref.watch(form_notifier.formNotifierProvider);

    // Columna con los requisitos de contraseña.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto fijo que indica el título de la sección.
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Requisitos de la contraseña: ',
              style: TextStyle(fontSize: 14)),
        ),
        // Requisito de longitud mínima (al menos 6 caracteres).
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
        // Requisito de mayúscula y minúscula.
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
        // Requisito de incluir un número.
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
        // Requisito de incluir un carácter especial.
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
