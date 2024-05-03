import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navBarIndex = ref.watch(navBarIndexNotifierProvider);

    return NavigationBar(
      selectedIndex: navBarIndex,
      elevation: 0,
      onDestinationSelected: (index) {
        if (navBarIndex == index) {
          return;
        }
        ref.read(navBarIndexNotifierProvider.notifier).updateIndex(index);
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.push('/search');
            break;
          case 2:
            context.push('/picture-upload');
            break;
          case 3:
            context.push('/chats');
            break;
          case 4:
            context.push('/profile');
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          tooltip: 'Inicio de usuario',
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          tooltip: 'Buscar usuarios',
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Buscar',
        ),
        NavigationDestination(
          tooltip: 'Publicar imagen',
          icon: Icon(Icons.add_box_outlined),
          selectedIcon: Icon(Icons.add_box),
          label: 'Publicar',
        ),
        NavigationDestination(
          tooltip: 'Chats de usuario',
          icon: Icon(Icons.message_outlined),
          selectedIcon: Icon(Icons.message),
          label: 'Chats',
        ),
        NavigationDestination(
          tooltip: 'Perfil de usuario',
          icon: Icon(Icons.person_outlined),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
