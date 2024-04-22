import 'dart:io';

abstract class AvatarBucketRepository {
  Future<String> uploadUserAvatar(File image);
  Future<String> deleteUserAvatar(String imageUrl);
  Future<String> updateUserAvatar(File image, String imageUrl);
}