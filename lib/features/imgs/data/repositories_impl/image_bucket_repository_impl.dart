import 'dart:io';
import 'package:crowd_snap/features/imgs/data/data_source/image_bucket_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/image_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


final imageBucketRepositoryProvider = Provider<ImageBucketRepositoryImpl>((ref) {
  final imageBucketDataSource = ref.watch(imageBucketDataSourceProvider);
  return ImageBucketRepositoryImpl(imageBucketDataSource);
});

class ImageBucketRepositoryImpl implements ImageBucketRepository {
  final ImageBucketDataSource _imageBucketDataSource;

  ImageBucketRepositoryImpl(this._imageBucketDataSource);

  @override
  Future<String> uploadImage(File image, {String? userName, Function(int, int)? onSendProgress}) {
    return _imageBucketDataSource.uploadImage(image, userName: userName, onSendProgress: onSendProgress);
  }

  @override
  Future<File> getImage(String imageName, {Function(int, int)? onReceiveProgress}) {
    return _imageBucketDataSource.getImage(imageName, onReceiveProgress: onReceiveProgress);
  }

  @override
  Future<void> deleteImage(String imageName) {
    return _imageBucketDataSource.deleteImage(imageName);
  }

  @override
  Future<String> updateImage(File image, String imageName) {
    return _imageBucketDataSource.updateImage(image, imageName);
  }
}
