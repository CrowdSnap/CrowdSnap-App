import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GoogleSignUpView extends ConsumerStatefulWidget {
  const GoogleSignUpView({super.key});

  @override
  _GoogleSignUpScreenState createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends ConsumerState<GoogleSignUpView> {
  late Future<void> _initializeUserFuture = Future.value();

  @override
  void initState() {
    super.initState();
    _initializeUserFuture =
        ref.read(googleSignUpNotifierProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(googleSignUpNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Google Sign Up'),
        ),
        body: FutureBuilder(
          future: _initializeUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final formState = ref.watch(googleSignUpNotifierProvider);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: formState.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) => ref
                          .read(googleSignUpNotifierProvider.notifier)
                          .updateNombre(value),
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      initialValue: formState.userName,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (value) => ref
                          .read(googleSignUpNotifierProvider.notifier)
                          .updateUserName(value),
                      keyboardType: TextInputType.name,
                    ),
                    TextFormField(
                      initialValue: formState.age.toString(),
                      decoration: const InputDecoration(labelText: 'Age'),
                      onChanged: (value) => ref
                          .read(googleSignUpNotifierProvider.notifier)
                          .updateAge(int.parse(value)),
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                        onPressed: () => context.go('/'),
                        child: const Text('Go to Home')),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
