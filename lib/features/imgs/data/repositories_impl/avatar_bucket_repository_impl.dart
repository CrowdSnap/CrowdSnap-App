import 'dart:io';

import 'package:crowd_snap/features/imgs/data/data_source/avatar_bucket_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'avatar_bucket_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AvatarBucketRepositoryImpl avatarBucketRepository(AvatarBucketRepositoryRef ref) {
  final avatarBucketDataSource = ref.watch(avatarBucketDataSourceProvider);
  return AvatarBucketRepositoryImpl(avatarBucketDataSource);
}

class AvatarBucketRepositoryImpl implements AvatarBucketRepository {
  final AvatarBucketDataSource _avatarBucketDataSource;

  AvatarBucketRepositoryImpl(this._avatarBucketDataSource);

  @override
  Future<String> uploadUserAvatar(File image, {String? userName}) {
    return _avatarBucketDataSource.uploadImage(image, userName: userName);
  }

  @override
  Future<File> getUserAvatar(String userName) {
    return _avatarBucketDataSource.getImage(userName);
  }


  @override
  Future<String> deleteUserAvatar(String imageUrl) {
    // TODO: implement deleteUserAvatar
    throw UnimplementedError();
  }

  @override
  Future<String> updateUserAvatar(File image, String imageUrl) {
    // TODO: implement updateUserAvatar
    throw UnimplementedError();
  }
}