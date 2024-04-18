import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crowd_snap/global/navbar/providers/navbar_provider.dart';

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
        ref.read(navBarIndexNotifierProvider.notifier).updateIndex(index);
        context.push(
          index == 0
              ? '/'
              : index == 1
                  ? '/settings'
                  : '/profile',
        );
      },
    );
  }
}
