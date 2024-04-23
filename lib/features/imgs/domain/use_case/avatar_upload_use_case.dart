import 'dart:io';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_upload_use_case.g.dart';

class AvatarUploadUseCase {
  final AvatarBucketRepository _bucketRepository;
  final AvatarLocalRepository _localRepository;

  AvatarUploadUseCase(this._bucketRepository, this._localRepository);

  Future<String> execute(File image) async {
    await _localRepository.saveAvatar(image);
    return await _bucketRepository.uploadUserAvatar(image);
  }
}

@riverpod
AvatarUploadUseCase avatarUploadUseCase(AvatarUploadUseCaseRef ref) {
  final bucketRepository = ref.watch(avatarBucketRepositoryProvider);
  final localRepository = ref.watch(avatarLocalRepositoryProvider);
  return AvatarUploadUseCase(bucketRepository, localRepository);
}