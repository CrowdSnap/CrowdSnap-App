import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/app/theme/notifier/theme_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/auth_notifier.dart';

// Clase `HomeView` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class HomeView extends ConsumerWidget {
  // Constructor simple sin parámetros.
  const HomeView({super.key});

  // Método `build` que define la interfaz de usuario de la pantalla de inicio.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el estado del modo oscuro del proveedor.
    final isDarkMode = ref.watch(darkModeProvider);

    // Obtiene una referencia al proveedor de autenticación (solo para lectura).
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Estructura base del Scaffold con AppBar y cuerpo centrado.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // Título de la aplicación.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra el contenido verticalmente.
          children: [
            // Texto que muestra el estado actual del modo oscuro.
            Text(
              'Modo Oscuro: $isDarkMode',
              style:
                  Theme.of(context).textTheme.titleLarge, // Estilo del texto.
            ),
            ElevatedButton(
              // Botón para cambiar el modo oscuro.
              onPressed: () {
                // Llama al método `toggleDarkMode` del proveedor para cambiar el estado.
                ref.read(darkModeProvider.notifier).toggleDarkMode();
              },
              child: const Text('Cambiar Modo'), // Texto del botón.
            ),
            ElevatedButton(
              // Botón para cerrar sesión.
              onPressed: () {
                // Llama al método `signOut` del proveedor de autenticación.
                authNotifier.signOut();
              },
              child: const Text('Logout'), // Texto del botón.
            ),
          ],
        ),
      ),
    );
  }
}
