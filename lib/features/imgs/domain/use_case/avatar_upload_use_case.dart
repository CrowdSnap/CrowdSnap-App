import 'dart:io';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_upload_use_case.g.dart';

class AvatarUploadUseCase {
  final AvatarBucketRepository _repository;

  AvatarUploadUseCase(this._repository);

  Future<String> execute(File image) async {
    return await _repository.uploadUserAvatar(image);
  }
}

@riverpod
AvatarUploadUseCase avatarUploadUseCase(AvatarUploadUseCaseRef ref) {
  final repository = ref.watch(avatarBucketRepositoryProvider);
  return AvatarUploadUseCase(repository);
}