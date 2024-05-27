import 'dart:io';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/image_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_compress_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image/image.dart' as img;

part 'image_upload_use_case.g.dart';

class ImageUploadUseCase {
  final ImageCompressUseCase _imageCompressUseCase;
  final ImageBucketRepositoryImpl _imageBucketRepositoryImpl;

  ImageUploadUseCase(this._imageCompressUseCase, this._imageBucketRepositoryImpl);

  Future<(String, String, double)> execute(File image, {String? userName}) async {
    final File imageCompressed;
    imageCompressed = await _imageCompressUseCase.execute(image, userName!, 65, false);
    final data = imageCompressed.readAsBytesSync();

    // Usar compute para ejecutar la tarea en un hilo separado
    final blurHash = await compute(_encodeBlurHash, data);

    // Decodificar la imagen para obtener sus dimensiones
    final decodedImage = img.decodeImage(data);
    final width = decodedImage!.width;
    final height = decodedImage.height;
    final aspectRatio = width / height;

    final imageUrl = await _imageBucketRepositoryImpl.uploadImage(imageCompressed, userName);
    try {
      return (imageUrl, blurHash, aspectRatio);
    } catch (e) {
      throw Exception(e);
    }
  }

  String _encodeBlurHash(Uint8List data) {
    final imageBlur = img.decodeImage(data);
    final blurHash = BlurHash.encode(imageBlur!, numCompX: 4, numCompY: 3);
    return blurHash.hash;
  }
}

@riverpod
ImageUploadUseCase imageUploadUseCase(ImageUploadUseCaseRef ref) {
  final imageCompress = ref.watch(imageCompressUseCaseProvider);
  final imageBucketRepository = ref.watch(imageBucketRepositoryProvider);
  return ImageUploadUseCase(imageCompress, imageBucketRepository);
}
