import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_create_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_upload_notifier.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/tagged_user_ids_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/after_image_loaded.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/before_image_loaded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploadView extends ConsumerWidget {
  const ImageUploadView({super.key});

  Future<void> _getCamera(WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
            reversible: true,
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-cropped.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref.read(imageStateProvider.notifier).setImage(croppedImage);
      }
    }
  }

  Future<void> _getGallery(WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List imageData = await pickedFile.readAsBytes();
      final editedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageCropper(
            image: imageData, // <-- Uint8List of image
            reversible: true,
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        ref.read(imageStateProvider.notifier).incrementCounter();
        final counter = ref.read(imageStateProvider.notifier).counter;
        File file = File('$tempPath/$counter-cropped.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref.read(imageStateProvider.notifier).setImage(croppedImage);
      }
    }
  }

  Future<void> _saveImage(
      File? imageState, WidgetRef ref, BuildContext context) async {
    ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(true);
    try {
      await ref
          .read(createPostUseCaseProvider)
          .execute(imageState!, ref.watch(taggedUserIdsProviderProvider));
      ref.watch(imageStateProvider.notifier).clearImage();
      ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(false);
      // ignore: use_build_context_synchronously
      _goHome(context, ref);
    } catch (e) {
      ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(false);
      rethrow;
    }
  }

  void _goHome(BuildContext context, WidgetRef ref) {
    context.go('/');
    ref.read(navBarIndexNotifierProvider.notifier).updateIndex(0);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    final isLoading = ref.watch(imageUploadNotifierProvider).isLoading;
    bool isSelecting = false;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        ref.watch(imageStateProvider.notifier).clearImage();
        _goHome(context, ref);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Publica una foto'),
        ),
        body: GestureDetector(
          onVerticalDragUpdate: (details) async {
            if (details.primaryDelta! < -5 &&
                !isSelecting &&
                imageState == null) {
              isSelecting = true;
              await _getGallery(ref, context);
              isSelecting = false;
            }
          },
          behavior: HitTestBehavior.translucent,
          child: imageState == null
              ? BeforeImageLoaded(
                  onCameraPressed: () => _getCamera(ref, context),
                  onGallerySwipe: () => _getGallery(ref, context),
                )
              : AfterImageLoaded(
                  image: imageState,
                  onSavePressed: () {
                    try {
                      _saveImage(imageState, ref, context);
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
                  onCancelPressed: () {
                    ref.watch(imageStateProvider.notifier).clearImage();
                  },
                  isLoading: isLoading,
                ),
        ),
      ),
    );
  }
}
