import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_notifier.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AvatarUploadView extends ConsumerWidget {
  const AvatarUploadView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageStateProvider);
    final imagesValue = ref.watch(imageStateProvider.notifier);
    final authState = ref.watch(authStateProvider.notifier);
    final imageNotifier = ref.watch(imageNotifierProvider.notifier);

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
                  ElevatedButton.icon(
                    onPressed: () {
                      imageNotifier.getCamera();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      imageNotifier.getGallery();
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
                          imageNotifier.saveAvatar(imageState);
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
