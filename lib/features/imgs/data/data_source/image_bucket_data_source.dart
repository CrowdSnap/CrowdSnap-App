import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:simple_s3/simple_s3.dart';

part 'image_bucket_data_source.g.dart';

abstract class ImageBucketDataSource {
  Future<String> uploadImage(File image, {String? userName});
  Future<void> deleteImage(String imageName);
  Future<String> updateImage(File image, String imageName);
  Future<void> checkConnection();
}

@Riverpod(keepAlive: true)
ImageBucketDataSource imageBucketDataSource(ImageBucketDataSourceRef ref) {
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return ImageBucketDataSourceImpl(getUserUseCase);
}

class ImageBucketDataSourceImpl implements ImageBucketDataSource {
  final GetUserUseCase _getUserUseCase;
  final SimpleS3 _r2Client = SimpleS3();

  String? _accessKey;
  String? _secretKey;
  String? _endpointUrl;
  String? _bucketId;

  ImageBucketDataSourceImpl(this._getUserUseCase);

  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _accessKey = dotenv.env['R2_ACCESS_KEY'];
    _secretKey = dotenv.env['R2_SECRET_ACCESS_KEY'];
    _endpointUrl = dotenv.env['R2_URL'];
    _bucketId = dotenv.env['R2_BUCKET_ID'];
  }

  @override
  Future<void> checkConnection() async {
    try {
      await _s3Client.listObjects();
      print('Connection successful');
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  @override
  Future<String> uploadImage(File image, {String? userName}) async {
    final result = await _r2Client.uploadFile(image, _r2Client, _bucketId, 'eu');

    return imageName;
  }

  @override
  Future<void> deleteImage(String imageName) async {
    await _s3Client.deleteObject(imageName);
  }

  @override
  Future<String> updateImage(File image, String imageName) async {
    await deleteImage(imageName);
    final newImageName = await uploadImage(image);
    return newImageName;
  }
}
