import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'image_compress_use_case.g.dart';

class ImageCompressUseCase {
  Future<File> execute(File image, String userName) async {
    final directory = await getApplicationDocumentsDirectory();

    // Obtener el tamaño de la imagen original
    final originalSize = await image.length();
    print('Tamaño original: ${originalSize} bytes');

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      '${directory.path}/compressed-avatar-$userName${DateTime.now().millisecondsSinceEpoch}.webp',
      format: CompressFormat.webp,
      keepExif: false,
      quality: 20,
    );

    // Obtener el tamaño de la imagen comprimida
    final compressedSize = await File(result!.path).length();
    print('Tamaño comprimido: ${compressedSize} bytes');

    return File(result.path);
  }
}

@riverpod
ImageCompressUseCase imageCompressUseCase(ImageCompressUseCaseRef ref) {
  return ImageCompressUseCase();
}
