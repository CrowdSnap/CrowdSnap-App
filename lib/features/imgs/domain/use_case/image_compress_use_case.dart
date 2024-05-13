import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

part 'image_compress_use_case.g.dart';

class ImageCompressUseCase {
  // Método que se encarga de comprimir una imagen.
  Future<File> execute(File image, String userName, int quality, bool isAvatar) async {
    // Obtener el directorio de documentos de la aplicación para almacenar la imagen comprimida.
    final directory = await getApplicationDocumentsDirectory();

    // Obtener el tamaño de la imagen original
    final originalSize = await image.length();
    print('Tamaño original: ${originalSize} bytes');

    // Comprimir la imagen utilizando la librería FlutterImageCompress.
    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      isAvatar
          ? '${directory.path}/compressed-avatar-$userName.jpeg'
          : '${directory.path}/compressed-image-$userName.jpeg',
      keepExif: false,
      quality: quality,
      minHeight: 800,
      minWidth: 600,
    );

    // Obtener el tamaño de la imagen comprimida
    final compressedSize = await File(result!.path).length();
    print('Tamaño comprimido: ${compressedSize} bytes');

    // Devolver la imagen comprimida.
    return File(result.path);
  }
}

// Proveedor de Riverpod que crea una instancia de ImageCompressUseCase.
@riverpod
ImageCompressUseCase imageCompressUseCase(ImageCompressUseCaseRef ref) {
  return ImageCompressUseCase();
}
