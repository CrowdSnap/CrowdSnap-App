import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchView extends ConsumerWidget {
  // Constructor para la vista de búsqueda.
  const SearchView({super.key});

  // Navega a la pantalla de inicio.
  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/'); // Redirige a la ruta raíz.
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(
        0); // Actualiza el índice de la barra de navegación inferior a 0.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      // Deshabilita el botón de retroceso del hardware.
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Search') // Título de la barra de aplicaciones.
            ),
        body: const Center(
          child: Text(
              'Search View'), // Texto de marcador de posición para la vista.
        ),
      ),
    );
  }
}
