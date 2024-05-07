import 'dart:io';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUploadView extends ConsumerWidget {
  // Constructor para la vista de subida de avatar.
  const AvatarUploadView({super.key});

  // Método para obtener una imagen de la cámara del dispositivo.
  // Recibe una referencia a un widget como parámetro.
  Future<void> _getCamera(WidgetRef ref) async {
    // Crea un objeto ImagePicker para acceder a la cámara.
    final picker = ImagePicker();

    // Abre la cámara y permite al usuario seleccionar una imagen.
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    // Si se seleccionó una imagen (diferente de null), actualiza el estado de la imagen.
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  // Método para obtener una imagen de la galería del dispositivo.
  // Recibe una referencia a un widget como parámetro.
  Future<void> _getGallery(WidgetRef ref) async {
    // Crea un objeto ImagePicker para acceder a la galería.
    final picker = ImagePicker();

    // Abre la galería y permite al usuario seleccionar una imagen.
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // Si se seleccionó una imagen (diferente de null), actualiza el estado de la imagen.
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  // Método para guardar la imagen seleccionada.
  // Recibe el estado actual de la imagen y una referencia a un widget como parámetros.
  Future<void> _saveImage(File? imageState, WidgetRef ref) async {
    // Accede a los proveedores de casos de uso de subida de avatar, repositorio de Firestore y repositorio de usuarios.
    final avatarUpload = ref.watch(avatarUploadUseCaseProvider);
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final userRepository = ref.watch(userRepositoryProvider);

    // Obtiene el usuario actual del repositorio de usuarios.
    final userModel = await userRepository.getUser();

    // Comprime la imagen seleccionada utilizando el caso de uso de subida de avatar.
    // Proporciona el nombre de usuario del usuario actual como parámetro.
    final image =
        await avatarUpload.execute(imageState!, userName: userModel.username);

    // Actualiza el avatar del usuario en Firestore.
    firestoreRepository.updateUserAvatar(image);

    // Actualiza el avatar del usuario en el modelo de usuario local.
    userRepository.updateUserAvatar(image);
  }

  // Método build para construir el widget de la vista.
  // Recibe el contexto de construcción y una referencia a un widget como parámetros.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accede a los proveedores de estado para obtener el estado actual de la imagen y sus métodos de modificación.
    final imageState = ref.watch(imageStateProvider);
    final imagesValue = ref.watch(imageStateProvider.notifier);
    final authState = ref.watch(authStateProvider.notifier);

    // Crea un Scaffold con un AppBar titulado "Avatar Upload".
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Si hay una imagen seleccionada, muestra la imagen.
            // De lo contrario, muestra un ícono de cuenta circular.
            imageState != null
                ? Image.file(
                    imageState,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 200,
                  ),
            // Espacio entre la imagen o el ícono y los botones.
            const SizedBox(height: 20),

            // Si no hay una imagen seleccionada, muestra botones para abrir la cámara o la galería.
            if (imageState == null)
              Column(
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
              )
            else
              Column(
                children: [
                  const Text('Do you want to save this image?'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _saveImage(imageState, ref);
                          authState.loggedIn();
                        },
                        child: const Text('Yes'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          imagesValue.setImage(null);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
