import 'dart:io';

abstract class ImageBucketRepository {
  Future<String> uploadImage(File image, {String? userName, Function(int, int)? onSendProgress});
  Future<File> getImage(String imageName, {Function(int, int)? onReceiveProgress});
  Future<void> deleteImage(String imageName);
  Future<String> updateImage(File image, String imageName);
}
