import 'dart:io';

import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_upload_notifier.dart';
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
    ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(true);
    final userModel = await ref.watch(getUserUseCaseProvider).execute();
    final userName = userModel.username;
    try {
      await ref
          .watch(imageUploadUseCaseProvider)
          .execute(imageState!, userName: userName);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    final isLoading = ref.watch(imageUploadNotifierProvider).isLoading;

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
                  ))
          ],
        ),
      ),
    );
  }
}
