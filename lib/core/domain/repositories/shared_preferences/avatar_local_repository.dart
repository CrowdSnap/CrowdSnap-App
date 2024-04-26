import 'dart:io';

abstract class AvatarLocalRepository {
  Future<void> saveAvatar(File avatar, {String? userName});
  Future<File> getAvatar();
  Future<void> deleteAvatar();
}