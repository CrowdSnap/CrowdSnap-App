import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileValues = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    final _pageController = PageController();

    void _onGridSelected(int index) {
      profileNotifier.updateIndex(index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Navega a la pantalla de inicio.
    void _goHome(BuildContext context, WidgetRef ref) {
      context.go('/'); // Redirige a la ruta raíz.
      ref.read(navBarIndexNotifierProvider.notifier).updateIndex(
          0); // Actualiza el índice de la barra de navegación inferior a 0.
    }

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
          title: Text(profileValues.userName),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                ref.read(appRouterProvider).push('/settings');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 200,
              child: Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: profileValues.image != null
                      ? FileImage(profileValues.image!)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.grid_on),
                  color: profileValues.index == 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
                  onPressed: () => _onGridSelected(0),
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  color: profileValues.index == 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
                  onPressed: () => _onGridSelected(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  profileNotifier.updateIndex(index);
                },
                children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: profileValues.posts.length,
                    itemBuilder: (context, index) {
                      final post = profileValues.posts[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: CachedNetworkImageProvider(post.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount:
                        0, // Reemplaza con el número real de posts etiquetados
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text('Tagged Post ${index + 1}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
