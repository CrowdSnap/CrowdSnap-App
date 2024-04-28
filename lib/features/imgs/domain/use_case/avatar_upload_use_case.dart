import 'dart:io';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_compress_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_upload_use_case.g.dart';

class AvatarUploadUseCase {
  final AvatarBucketRepository _bucketRepository;
  final AvatarLocalRepository _localRepository;
  final ImageCompressUseCase _imageCompressUseCase;

  AvatarUploadUseCase(this._bucketRepository, this._localRepository, this._imageCompressUseCase);

  Future<String> execute(File image, {String? userName}) async {
    await _localRepository.saveAvatar(image, userName: userName);
    print('Avatar saved locally without compressing');
    final imageCompressed = await _imageCompressUseCase.execute(image, userName!);
    print('Avatar compressed');
    return await _bucketRepository.uploadUserAvatar(imageCompressed, userName: userName);
  }
}

@riverpod
AvatarUploadUseCase avatarUploadUseCase(AvatarUploadUseCaseRef ref) {
  final bucketRepository = ref.watch(avatarBucketRepositoryProvider);
  final localRepository = ref.watch(avatarLocalRepositoryProvider);
  final imagecompress = ref.watch(imageCompressUseCaseProvider);
  return AvatarUploadUseCase(bucketRepository, localRepository, imagecompress);
}