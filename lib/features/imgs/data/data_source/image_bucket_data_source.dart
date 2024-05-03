import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'image_bucket_data_source.g.dart';

abstract class ImageBucketDataSource {
  Future<String> uploadImage(File image, String userName);
  Future<void> deleteImage(String imageName);
  Future<String> updateImage(File image, String imageName);
  Future<void> loadEnvVariables();
}

@Riverpod(keepAlive: true)
ImageBucketDataSource imageBucketDataSource(ImageBucketDataSourceRef ref) {
  return ImageBucketDataSourceImpl();
}

class ImageBucketDataSourceImpl implements ImageBucketDataSource {
  final dio = Dio();

  String? _accessKey;
  String? _secretKey;
  String? _endpointUrl;

  ImageBucketDataSourceImpl();

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _accessKey = dotenv.env['R2_ACCESS_KEY'];
    _secretKey = dotenv.env['R2_SECRET_ACCESS_KEY'];
    _endpointUrl = dotenv.env['R2_URL'];
  }

  @override
  Future<String> uploadImage(File image, String userName) async {
    final fileName = '$userName-${DateTime.now().millisecondsSinceEpoch}.jpeg';

    final bytes = await image.readAsBytes();

    final response = await dio.put(
      '$_endpointUrl/$fileName',
      data: Stream.fromIterable(bytes.map((e) => [e])),
      options: Options(
        headers: {
          'Content-Type': 'image/jpeg',
          'X-Access-Key': _accessKey,
          'X-Secret-Key': _secretKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      return fileName;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  @override
  Future<void> deleteImage(String imageName) async {
    final response = await dio.delete(
      '$_endpointUrl/$imageName',
      options: Options(
        headers: {
          'X-Access-Key': _accessKey,
          'X-Secret-Key': _secretKey,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete image');
    }
  }

  @override
  Future<String> updateImage(File image, String imageName) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: imageName),
    });

    final response = await dio.put(
      '$_endpointUrl/$imageName',
      data: formData,
      options: Options(
        headers: {
          'X-Access-Key': _accessKey,
          'X-Secret-Key': _secretKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      return imageName;
    } else {
      throw Exception('Failed to update image');
    }
  }
}
