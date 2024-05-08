import 'dart:io';
import 'package:crowd_snap/features/imgs/data/repositories_impl/image_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_compress_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload_use_case.g.dart';

class ImageUploadUseCase {
  final ImageCompressUseCase _imageCompressUseCase;
  final ImageBucketRepositoryImpl _imageBucketRepositoryImpl;

  ImageUploadUseCase(this._imageCompressUseCase, this._imageBucketRepositoryImpl);

  Future<String> execute(File image, {String? userName}) async {
    final File imageCompressed;
    imageCompressed = await _imageCompressUseCase.execute(image, userName!, 65, false);
    try {
      return await _imageBucketRepositoryImpl.uploadImage(imageCompressed, userName);
    } catch (e) {
      throw Exception(e);
    }
  }
}

@riverpod
ImageUploadUseCase imageUploadUseCase(ImageUploadUseCaseRef ref) {
  final imageCompress = ref.watch(imageCompressUseCaseProvider);
  final imageBucketRepository = ref.watch(imageBucketRepositoryProvider);
  return ImageUploadUseCase(imageCompress, imageBucketRepository);
}
