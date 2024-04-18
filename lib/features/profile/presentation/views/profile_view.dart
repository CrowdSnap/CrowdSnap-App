import 'package:crowd_snap/global/navbar/providers/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/');
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        print('PopScope invoked');
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => _goHome(context, ref), icon: const Icon(Icons.arrow_back)),
          title: const Text('Profile')
        ),
        body: const Center(
          child: Text('Profile View'),
        ),
      ),
    );
  }
}