import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crowd_snap/core/navbar/providers/navbar_provider.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_create_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_upload_notifier.dart';
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
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/cropped.jpeg');
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
          ),
        ),
      );
      if (editedImage != null) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/cropped.jpeg');
        final croppedImage = await file.writeAsBytes(editedImage);
        ref.read(imageStateProvider.notifier).setImage(croppedImage);
      }
    }
  }

  Future<void> _saveImage(
      File? imageState, WidgetRef ref, BuildContext context) async {
    ref.watch(imageUploadNotifierProvider.notifier).updateIsLoading(true);
    try {
      await ref.read(createPostUseCaseProvider).execute(imageState!);
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

    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          _goHome(context, ref);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Picture Upload'),
            ),
            body: GestureDetector(
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
                          imageState != null
                              ? Image.file(
                                imageState,
                                width: double.infinity,
                                height: 600,
                                fit: BoxFit.contain,
                              )
                              : const Icon(
                                  Icons.people_alt_sharp,
                                  size: 200,
                                ),
                          const SizedBox(height: 20),
                          if (imageState != null)
                            ElevatedButton(
                                onPressed: () {
                                  try {
                                    _saveImage(imageState, ref, context);
                                  } on Exception catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Error uploading image: $e'),
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
                                )),
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
                        const Text(
                            'Desliza hacia arriba para abrir la galería'),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            )));
  }
}
