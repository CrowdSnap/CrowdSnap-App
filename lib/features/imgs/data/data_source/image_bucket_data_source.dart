import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'image_bucket_data_source.g.dart';

abstract class ImageBucketDataSource {
  Future<String> uploadImage(File image, {String? userName});
  Future<File> getImage(String userName);
  Future<void> deleteImage(String imageUrl);
  Future<String> updateImage(File image, String imageUrl);
}

@Riverpod(keepAlive: true)
ImageBucketDataSource imageBucketDataSource(ImageBucketDataSourceRef ref) {
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return ImageBucketDataSourceImpl(getUserUseCase);
}

class ImageBucketDataSourceImpl implements ImageBucketDataSource {
  final GetUserUseCase _getUserUseCase;
  final Dio _dio = Dio();

  final String _r2Url = Platform.environment['R2_URL']!;
  final String _accessKey = Platform.environment['R2_ACCESS_KEY']!;
  final String _secretAccessKey = Platform.environment['R2_SECRET_ACCESS_KEY']!;

  ImageBucketDataSourceImpl(this._getUserUseCase);

  @override
  Future<File> getImage(String imageName) async {
    // Get the app's directory for storing files
    final directory = await getApplicationDocumentsDirectory();

    // Create a new file in the app's directory
    final localFile = File('${directory.path}/$imageUrl');

    // Download the image file from the URL
    await _dio.download(
      imageUrl,
      localFile.path,
      options: Options(
        headers: {
          'Authorization': 'AWS $_accessKey:$_secretAccessKey',
        },
      ),
    );
    return localFile;
  }

  @override
  Future<String> uploadImage(File image, {String? userName}) async {
    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }
    final imageName = '$userName-${DateTime.now()}.jpeg';

    // Upload image to Cloudflare R2
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: imageName),
    });
    final response = await _dio.post(
        '$_r2Url$imageName',
        data: formData);

    final imageUrl = response.data['url'];
    return imageUrl;
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      await _dio.delete(imageUrl);
    } on Exception catch (e) {
      print('Error deleting image: $e');
      throw Exception(
          'Error deleting image from Cloudflare R2 ${e.toString()}');
    }
  }

  @override
  Future<String> updateImage(File image, String imageUrl) async {
    await deleteImage(imageUrl);
    final newImageUrl = await uploadImage(image);
    return newImageUrl;
  }
}
