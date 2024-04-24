import 'dart:io';

abstract class AvatarLocalRepository {
  Future<void> saveAvatar(File avatar);
  Future<File> getAvatar();
  Future<void> deleteAvatar();
}