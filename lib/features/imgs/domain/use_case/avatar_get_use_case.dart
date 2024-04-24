import 'dart:io';

import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_get_use_case.g.dart';

class AvatarGetUseCase {
  final AvatarLocalRepository _localRepository;
  final AvatarBucketRepository _bucketRepository;

  AvatarGetUseCase(this._localRepository, this._bucketRepository);

  Future<File> execute() async {
    try {
      return await _localRepository.getAvatar();
    } catch (e) {
      print('Error getting avatar from local storage: $e');
      // If the avatar is not found in local storage, try to get it from the bucket and save it locally
      final avatar = await _bucketRepository.getUserAvatar();
      await _localRepository.saveAvatar(avatar);
      return avatar;
    }
  }
}

@riverpod
AvatarGetUseCase avatarGetUseCase(AvatarGetUseCaseRef ref) {
  final localRepository = ref.watch(avatarLocalRepositoryProvider);
  final bucketRepository = ref.watch(avatarBucketRepositoryProvider);
  return AvatarGetUseCase(localRepository, bucketRepository);
}