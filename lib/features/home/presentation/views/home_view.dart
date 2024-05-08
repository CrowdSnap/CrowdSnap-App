import 'package:crowd_snap/features/home/presentation/provider/post_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Clase `HomeView` que extiende `ConsumerWidget` para utilizar datos de proveedores.
class HomeView extends ConsumerWidget {
  
  // Constructor simple sin parámetros.
  const HomeView({super.key});

  // Método `build` que define la interfaz de usuario de la pantalla de inicio.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postListAsyncValue = ref.watch(postListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // Título de la aplicación.
      ),
      body: postListAsyncValue.when(
        data: (postList) {
          return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
              final post = postList[index];
              return PostCard(post: post);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
