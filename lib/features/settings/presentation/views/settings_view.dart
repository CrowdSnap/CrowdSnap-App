import 'package:crowd_snap/global/navbar/providers/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/');
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () => _goHome(context, ref), icon: const Icon(Icons.arrow_back)),
          title: const Text('Settings')
        ),
        body: const Center(
          child: Text('Settings View'),
        ),
      ),
    );
  }
}