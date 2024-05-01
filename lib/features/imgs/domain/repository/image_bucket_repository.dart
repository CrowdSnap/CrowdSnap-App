import 'dart:io';

abstract class ImageBucketRepository {
  Future<String> uploadImage(File image, String userName);
  Future<void> deleteImage(String imageName);
  Future<String> updateImage(File image, String imageName);
}
