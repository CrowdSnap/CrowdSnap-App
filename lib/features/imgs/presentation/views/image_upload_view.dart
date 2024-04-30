import 'dart:io';

import 'package:crowd_snap/features/imgs/data/data_source/image_bucket_data_source.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/image_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadView extends ConsumerWidget {
  const ImageUploadView({super.key});

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
    print(imageState!.path);
    final image =
        await ref.watch(imageBucketRepositoryProvider).uploadImage(imageState!);
    print(image);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Upload'),
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
                  ElevatedButton.icon(
                    onPressed: () => _getCamera(ref),
                    icon: const Icon(Icons.camera),
                    label: const Text('Camera'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _getGallery(ref),
                    icon: const Icon(Icons.photo),
                    label: const Text('Gallery'),
                  ),
                ],
              ),
            if (imageState != null)
              ElevatedButton.icon(
                onPressed: () => _saveImage(imageState, ref),
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ElevatedButton(
                onPressed: () async {
                  await ref
                      .watch(imageBucketDataSourceProvider)
                      .checkConnection();
                },
                child: const Text('Check Connection'))
          ],
        ),
      ),
    );
  }
}
