import 'dart:io';
import 'package:crowd_snap/features/auth/presentation/notifier/google_sign_up_notifier.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/age/birth_date_input_google_sign_up.dart';
import 'package:crowd_snap/features/auth/presentation/widgets/google_register_button_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GoogleSignUpView extends ConsumerStatefulWidget {
  const GoogleSignUpView({super.key});

  @override
  _GoogleSignUpScreenState createState() => _GoogleSignUpScreenState();
}

class _GoogleSignUpScreenState extends ConsumerState<GoogleSignUpView>
    with SingleTickerProviderStateMixin {
  late Future<void> _initializeUserFuture;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;
  bool _isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeUserFuture =
        ref.read(googleSignUpNotifierProvider.notifier).initialize();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_animationController);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.5),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose(); // Disponer el AnimationController
    super.dispose();
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

  void _toggleImageExpansion() {
    setState(() {
      _isImageExpanded = !_isImageExpanded;
      if (_isImageExpanded) {
        _animationController.stop();
      } else {
        _animationController.repeat(reverse: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(googleSignUpNotifierProvider);
    final formValues = ref.watch(googleSignUpNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${formState.name.split(' ')[0]}'),
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
                      const Text('Para continuar, por favor completa tu perfil'),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _toggleImageExpansion,
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isImageExpanded ? 1.0 : _scaleAnimation.value,
                              child: Transform.translate(
                                offset: _isImageExpanded ? Offset.zero : _offsetAnimation.value,
                                child: CircleAvatar(
                                  radius: _isImageExpanded ? 100 : 50,
                                  backgroundImage: formState.userImage.isNotEmpty
                                      ? FileImage(File(formState.userImage)) as ImageProvider<Object>?
                                      : formState.googleImage.isNotEmpty
                                          ? NetworkImage(formState.googleImage) as ImageProvider<Object>?
                                          : null,
                                  child: formState.userImage.isEmpty && formState.googleImage.isEmpty
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (_isImageExpanded) 
                        const SizedBox(height: 20),
                      if (_isImageExpanded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _getCamera(ref);
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                _getGallery(ref);
                              },
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                          ],
                        ),
                      if (!_isImageExpanded)
                        const SizedBox(height: 20),
                      if (!_isImageExpanded)
                        const Text('Pulsando encima de la imagen puedes cambiarla'),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: formState.name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        onChanged: (value) => formValues.updateNombre(value),
                      ),
                      TextFormField(
                        initialValue: formState.userName,
                        decoration: const InputDecoration(labelText: 'Username'),
                        onChanged: (value) => formValues.updateUserName(value),
                      ),
                      const BirthDateInputGoogleSignUp(),
                      const SizedBox(height: 16),
                      const GoogleRegisterButtonSubmit(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
