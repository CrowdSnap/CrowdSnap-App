import 'dart:io';

abstract class AvatarBucketRepository {
  Future<String> uploadUserAvatar(File image, {String? userName});
  Future<File> getUserAvatar(String userName);
  Future<void> deleteUserAvatar(String imageUrl);
  Future<String> updateUserAvatar(File image, String imageUrl);
}