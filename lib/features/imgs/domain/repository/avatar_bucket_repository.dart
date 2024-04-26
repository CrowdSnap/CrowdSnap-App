import 'dart:io';

abstract class AvatarBucketRepository {
  Future<String> uploadUserAvatar(File image, {String? userName});
  Future<File> getUserAvatar(String userName);
  Future<String> deleteUserAvatar(String imageUrl);
  Future<String> updateUserAvatar(File image, String imageUrl);
}