import 'dart:io';
import 'package:crowd_snap/app/router/app_router.dart';
import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_register_button_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GoogleSignUpView extends ConsumerStatefulWidget {
  const GoogleSignUpView({super.key});

  @override
  _GoogleSignUpScreenState createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends ConsumerState<GoogleSignUpView> {
  late Future<void> _initializeUserFuture;

  @override
  void initState() {
    super.initState();
    _initializeUserFuture =
        ref.read(googleSignUpNotifierProvider.notifier).initialize();
  }

  Future<void> _getCamera(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      ref
          .read(googleSignUpNotifierProvider.notifier)
          .updateUserImage(pickedFile.path);
    }
  }

  Future<void> _getGallery(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref
          .read(googleSignUpNotifierProvider.notifier)
          .updateUserImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(googleSignUpNotifierProvider);
    final router = ref.watch(appRouterProvider);

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
            return Consumer(
              builder: (context, ref, _) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Camera'),
                                    onTap: () {
                                      _getCamera(ref);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Gallery'),
                                    onTap: () {
                                      _getGallery(ref);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: formState.userImage.isNotEmpty
                              ? FileImage(File(formState.userImage)) as ImageProvider<Object>?
                              : formState.googleImage.isNotEmpty
                                ? NetworkImage(formState.googleImage) as ImageProvider<Object>?
                                : null,
                            child: formState.userImage.isEmpty &&
                                    formState.googleImage.isEmpty
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: formState.name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          onChanged: (value) => ref
                              .read(googleSignUpNotifierProvider.notifier)
                              .updateNombre(value),
                        ),
                        TextFormField(
                          initialValue: formState.userName,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          onChanged: (value) => ref
                              .read(googleSignUpNotifierProvider.notifier)
                              .updateUserName(value),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Age'),
                          onChanged: (value) => ref
                              .read(googleSignUpNotifierProvider.notifier)
                              .updateAge(int.parse(value)),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        const GoogleRegisterButtonSubmit(),
                        ElevatedButton(
                          onPressed: () {
                            router.go('/');
                          },
                          child: const Text('Home'),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
