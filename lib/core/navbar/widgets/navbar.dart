import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navBarIndex = ref.watch(navBarIndexNotifierProvider);

    return BottomNavigationBar(
      currentIndex: navBarIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        if (navBarIndex == index) {
          return;
        }
        ref.read(navBarIndexNotifierProvider.notifier).updateIndex(index);
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.push('/settings');
            break;
          case 2:
            context.push('/profile');
            break;
        }
      },
    );
  }
}
