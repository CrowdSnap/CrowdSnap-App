import 'dart:io';
import 'dart:typed_data';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_upload_notifier.dart';
import 'package:crowd_snap/features/profile/presentation/notifier/profile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AvatarUploadView extends ConsumerWidget {
  // Constructor para la vista de subida de avatar.
  const AvatarUploadView({super.key});

  // Método para obtener una imagen de la cámara del dispositivo.
  // Recibe una referencia a un widget como parámetro.
  Future<void> _getCamera(WidgetRef ref, BuildContext context) async {
    // Crea un objeto ImagePicker para acceder a la cámara.
    final picker = ImagePicker();

    // Abre la cámara y permite al usuario seleccionar una imagen.
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    // Si se seleccionó una imagen (diferente de null), actualiza el estado de la imagen.
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-avatar.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref.read(imageStateProvider.notifier).setImage(File(croppedImage.path));
      }
    }
  }

  // Método para obtener una imagen de la galería del dispositivo.
  // Recibe una referencia a un widget como parámetro.
  Future<void> _getGallery(WidgetRef ref, BuildContext context) async {
    // Crea un objeto ImagePicker para acceder a la galería.
    final picker = ImagePicker();

    // Abre la galería y permite al usuario seleccionar una imagen.
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // Si se seleccionó una imagen (diferente de null), actualiza el estado de la imagen.
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-avatar.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref.read(imageStateProvider.notifier).setImage(File(croppedImage.path));
      }
    }
  }

  // Método para guardar la imagen seleccionada.
  // Recibe el estado actual de la imagen y una referencia a un widget como parámetros.
  Future<void> _saveImage(File? imageState, WidgetRef ref) async {
    // Accede a los proveedores de casos de uso de subida de avatar, repositorio de Firestore y repositorio de usuarios.
    ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(true);

    final avatarUpload = ref.watch(avatarUploadUseCaseProvider);
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final userRepository = ref.watch(userRepositoryProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    final getUserUseCase = ref.read(getUserUseCaseProvider);

    // Obtiene el usuario actual del repositorio de usuarios.
    final userModel = await userRepository.getUser();

    // Comprime la imagen seleccionada utilizando el caso de uso de subida de avatar.
    // Proporciona el nombre de usuario del usuario actual como parámetro.
    final (imageUrl, blurHash) =
        await avatarUpload.execute(imageState!, userName: userModel.username);

    // Actualiza el avatar del usuario en Firestore.
    firestoreRepository.updateUserAvatar(imageUrl, blurHash);

    // Actualiza el avatar del usuario en el modelo de usuario local.
    userRepository.updateUserAvatar(imageUrl, blurHash);

    getUserUseCase.execute().then((user) {
      profileNotifier.updateUserId(user.userId);
      profileNotifier.updateName(user.name);
      profileNotifier.updateEmail(user.email);
      profileNotifier.updateUserName(user.username);
      profileNotifier.updateAge(user.birthDate);
    });

    profileNotifier.updateImage(imageState);

    ref.watch(imageStateProvider.notifier).clearImage();

    ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(false);
    ref.watch(authStateProvider.notifier).loggedIn();
  }

  // Método build para construir el widget de la vista.
  // Recibe el contexto de construcción y una referencia a un widget como parámetros.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    final imagesValue = ref.watch(imageStateProvider.notifier);
    bool isSelecting = false;
    final isLoading = ref.watch(imageUploadNotifierProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Upload'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          final animationController = AnimationController(
            vsync: Scaffold.of(context),
            duration: const Duration(milliseconds: 1500),
          )..repeat(reverse: true);

          final animation = Tween<double>(begin: 0, end: -20).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOut,
            ),
          );

          return GestureDetector(
            onVerticalDragUpdate: (details) async {
              if (details.primaryDelta! < -5 && !isSelecting) {
                isSelecting = true;
                await _getGallery(ref, context);
                isSelecting = false;
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (imageState != null)
                          Expanded(
                            child: Image.file(
                              imageState,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          )
                        else
                          const Icon(
                            Icons.people_alt_sharp,
                            size: 200,
                          ),
                        const SizedBox(height: 20),
                        if (imageState != null)
                          ElevatedButton(
                            onPressed: () {
                              try {
                                _saveImage(imageState, ref);
                              } on Exception catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error uploading image: $e'),
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isLoading)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                const Icon(Icons.upload),
                                const Text('Upload Image'),
                              ],
                            ),
                          ),
                        if (imageState != null)
                          ElevatedButton(
                            onPressed: () {
                              imagesValue.clearImage();
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete),
                                Text('Delete Image'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (imageState == null)
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => _getCamera(ref, context),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding:
                              const EdgeInsets.all(10), // Text and icon color
                        ),
                        child: const Icon(Icons.camera_outlined,
                            color: Colors.red, size: 50),
                      ),
                      const SizedBox(height: 50),
                      AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, animation.value),
                            child: Transform.rotate(
                              angle: 1.5708,
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Text('Desliza hacia arriba para abrir la galería'),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
