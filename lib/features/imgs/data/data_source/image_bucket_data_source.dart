import 'dart:convert';
import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:crypto/crypto.dart';

part 'image_bucket_data_source.g.dart';

abstract class ImageBucketDataSource {
  Future<String> uploadImage(File image,
      {String? userName, Function(int, int)? onSendProgress});
  Future<File> getImage(String imageName,
      {Function(int, int)? onReceiveProgress});
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
  final Dio _dio = Dio();

  late final String _r2Url;
  late final String _accessKey;
  late final String _secretAccessKey;

  ImageBucketDataSourceImpl(this._getUserUseCase);

  Future<void> _loadEnvVariables() async {
    // Load environment variables from .env file
    await dotenv.load();

    // Access environment variables using dotenv.env
    _r2Url = dotenv.env['R2_URL'] ?? '';
    _accessKey = dotenv.env['R2_ACCESS_KEY'] ?? '';
    _secretAccessKey = dotenv.env['R2_SECRET_ACCESS_KEY'] ?? '';
  }

  @override
  Future<File> getImage(String imageName,
      {Function(int, int)? onReceiveProgress}) async {
    await _loadEnvVariables();

    // Get the app's directory for storing files
    final directory = await getApplicationDocumentsDirectory();

    // Create a new file in the app's directory
    final localFile = File('${directory.path}/$imageName');

    // Download the image file from the URL
    await _dio.download(
      '$_r2Url$imageName',
      localFile.path,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_accessKey:$_secretAccessKey',
        },
      ),
      onReceiveProgress: onReceiveProgress,
    );
    return localFile;
  }

  @override
  Future<void> checkConnection() async {
    // await _loadEnvVariables();

    // final now = DateTime.now().toUtc();
    // final amzDate = now.toString().split(' ')[0].replaceAll('-', '');
    // final amzDateTime =
    //     '${amzDate}T${now.toString().split(' ')[1].split('.')[0].replaceAllMapped(RegExp(r'(\d):(\d)'), (match) => '${match.group(1)}${match.group(2)}')}Z';

    // var data = '''''';

    // final contentHash = sha256.convert(utf8.encode(data.toString())).toString();

    // var headers = {
    //   'X-Amz-Content-Sha256': contentHash,
    //   'X-Amz-Date': amzDateTime,
    //   'Authorization':
    //       'AWS4-HMAC-SHA256 Credential=$_accessKey/$amzDate/auto/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=$_secretAccessKey'
    // };
    // var dio = Dio();
    // var response = await dio.request(
    //   _r2Url,
    //   options: Options(
    //     method: 'GET',
    //     headers: headers,
    //   ),
    //   data: data,
    // );

    // if (response.statusCode == 200) {
    //   print(json.encode(response.data));
    // } else {
    //   print(response.statusMessage);
    // }

    var headers = {
      'X-Amz-Content-Sha256':
          'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855',
      'X-Amz-Date': '20240430T121206Z',
      'Authorization':
          'AWS4-HMAC-SHA256 Credential=ef098e1e3c84a4b4f23da81212bfa087/20240430/auto/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=f5a42a91bf2dbdc1947ac0397461f085228f8f4256dd9e96dd9bafc92aef6af8'
    };
    var data = '''''';
    var dio = Dio();
    var response = await dio.request(
      'https://c3f9252496fef01a2039f9cd3297880c.eu.r2.cloudflarestorage.com',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
    } else {
      print(response.statusMessage);
    }
  }

  @override
  Future<String> uploadImage(File image,
      {String? userName, Function(int, int)? onSendProgress}) async {
    await _loadEnvVariables();

    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }

    print('Image path: ${image.path}');
    final imageName = '$userName-${DateTime.now().millisecondsSinceEpoch}.jpeg';
    print('Image name: $imageName');

    // Create the request URL
    final url = '$_r2Url/$imageName';

    // Get the current date in the required format
    // Get the current date in the required format
    final now = DateTime.now().toUtc();
    final amzDate = now.toString().split(' ')[0].replaceAll('-', '');
    final amzDateTime =
        '${amzDate}T${now.toString().split(' ')[1].split('.')[0].replaceAllMapped(RegExp(r'(\d):(\d)'), (match) => '${match.group(1)}${match.group(2)}')}Z';

    // Create the form data
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path, filename: imageName),
    });

    // Calculate the SHA-256 hash of the form data
    final contentHash =
        sha256.convert(utf8.encode(formData.toString())).toString();

    // Create the request headers
    final headers = {
      'x-amz-content-sha256': contentHash,
      'Content-Type': 'image/jpeg',
      'X-Amz-Date': amzDateTime,
      'Authorization':
          'AWS4-HMAC-SHA256 Credential=$_accessKey/$amzDate/auto/s3/aws4_request, SignedHeaders=content-length;content-type;host;x-amz-content-sha256;x-amz-date, Signature=$_secretAccessKey'
    };

    print('Request Headers:');
    headers.forEach((key, value) {
      print('$key: $value');
    });
    print('Request Payload: ${formData.toString()}');

    // Enviar la solicitud PUT usando Dio
    final response = await _dio.put(
      url,
      data: formData,
      options: Options(headers: headers),
      onSendProgress: onSendProgress,
    );

    print('Upload response status code: ${response.statusCode}');
    print('Upload response headers: ${response.headers}');
    print('Upload response data: ${response.data}');

    return imageName;
  }

  @override
  Future<void> deleteImage(String imageName) async {
    await _loadEnvVariables();

    try {
      await _dio.delete(
        '$_r2Url$imageName',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessKey:$_secretAccessKey',
          },
        ),
      );
    } on Exception catch (e) {
      print('Error deleting image: $e');
      throw Exception(
          'Error deleting image from Cloudflare R2 ${e.toString()}');
    }
  }

  @override
  Future<String> updateImage(File image, String imageName) async {
    await deleteImage(imageName);
    final newImageUrl = await uploadImage(image);
    return newImageUrl;
  }
}
