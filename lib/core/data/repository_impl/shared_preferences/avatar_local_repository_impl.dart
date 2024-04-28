import 'dart:io';
import 'package:crowd_snap/core/data/data_source/shared_preferences/avatar_local_data_source.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_local_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AvatarLocalRepository avatarLocalRepository(AvatarLocalRepositoryRef ref) {
  final avatarLocalDataSource = ref.watch(avatarLocalDataSourceProvider);
  return AvatarLocalRepositoryImpl(avatarLocalDataSource);
}

class AvatarLocalRepositoryImpl implements AvatarLocalRepository {
  final AvatarLocalDataSource _avatarLocalDataSource;

  AvatarLocalRepositoryImpl(this._avatarLocalDataSource);

  @override
  Future<void> deleteAvatar() async {
    await _avatarLocalDataSource.deleteAvatar();
  }

  @override
  Future<File> getAvatar() async {
    return await _avatarLocalDataSource.getAvatar();
  }

  @override
  Future<void> saveAvatar(File avatar, {String? userName}) async {
    await _avatarLocalDataSource.saveAvatar(avatar, userName: userName);
  }
}