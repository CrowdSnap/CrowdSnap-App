import 'dart:io';
import 'package:crowd_snap/app/router/redirect/auth_state_provider.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/google_user_repository_impl.dart';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class GoogleSignUpView extends ConsumerWidget {
  const GoogleSignUpView({super.key});

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
    final authState = ref.watch(authStateProvider.notifier);
    final googleUser = ref.watch(googleUserRepositoryProvider);

    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () async {
          final googleUserModel = await googleUser.getGoogleUser();
          print(googleUserModel.toString());
        }, child: Text('Get GoogleUser')),
      ),
    );
  }
}
