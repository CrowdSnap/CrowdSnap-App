import 'dart:io';
import 'package:crowd_snap/features/auth/data/repositories_impl/firestore_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/avatar_upload_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/image_picker_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_notifier.g.dart';

@riverpod
class ImageNotifier extends _$ImageNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> getCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  Future<void> getGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ref.read(imageStateProvider.notifier).setImage(File(pickedFile.path));
    }
  }

  Future<void> saveAvatar(File? avatarState) async {
    final avatarUpload = ref.watch(avatarUploadUseCaseProvider);
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final avatar = await avatarUpload.execute(avatarState!);
    firestoreRepository.updateUserAvatar(avatar);
  }
}