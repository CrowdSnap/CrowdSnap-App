import 'dart:io';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AvatarUploadView extends ConsumerWidget {
  const AvatarUploadView({super.key});

  Future<void> _getCamera(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  Future<void> _getGallery(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  Future<void> _saveImage(File? imageState, WidgetRef ref) async {
    final avatarUpload = ref.watch(avatarUploadUseCaseProvider);
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final image = await avatarUpload.execute(imageState!);
    firestoreRepository.updateUserAvatar(image);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    final imagesValue = ref.watch(imageStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            const SizedBox(height: 20),
            if (imageState == null)
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _getCamera(ref),
                    child: const Text('Camera'),
                  ),
                  ElevatedButton(
                    onPressed: () => _getGallery(ref),
                    child: const Text('Gallery'),
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
                          context.go('/');
                          _saveImage(imageState, ref);
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
