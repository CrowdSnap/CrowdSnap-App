import 'dart:io';
import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/image_compress_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image/image.dart' as img;


part 'avatar_upload_use_case.g.dart';

// Clase `AvatarUploadUseCase` que gestiona la subida de imágenes de avatar del usuario.
class AvatarUploadUseCase {
  // Instancia del repositorio de almacenamiento en la nube de avatares (generalmente Firebase Storage).
  final AvatarBucketRepository _bucketRepository;

  // Instancia del repositorio de almacenamiento local de avatares.
  final AvatarLocalRepository _localRepository;

  // Instancia del caso de uso para comprimir imágenes.
  final ImageCompressUseCase _imageCompressUseCase;

  // Constructor que recibe las instancias de los repositorios local y en la nube, y del caso de uso de compresión.
  AvatarUploadUseCase(this._bucketRepository, this._localRepository,
      this._imageCompressUseCase);

  // Método `execute` que se encarga de subir una imagen de avatar del usuario.
  // Toma los siguientes parámetros:
  //   - `image`: Archivo de imagen que se quiere subir.
  //   - `userName` (opcional): Nombre de usuario para nombrar la imagen en el almacenamiento en la nube.
  //   - `googleAvatar` (opcional): Booleano que indica si la imagen proviene de Google (ya comprimida).
  Future<(String, String)> execute(File image,
      {String? userName, bool? googleAvatar}) async {

    final data = image.readAsBytesSync();

    // Usar compute para ejecutar la tarea en un hilo separado
    final blurHash = await compute(_encodeBlurHash, data); 

    // Guarda la imagen original en el almacenamiento local.
    await _localRepository.saveAvatar(image, userName: userName);

    // Determina si se debe comprimir la imagen.
    final File imageCompressed;
    print('Avatar saved locally without compressing');
    if (googleAvatar != null) {
      imageCompressed =
          image; // Evita compresión innecesaria de imágenes de Google.
    } else {
      imageCompressed =
          await _imageCompressUseCase.execute(image, userName!, 30, true);
    }
    print('Avatar compressed');
    // Sube la imagen comprimida (o la original si proviene de Google) al almacenamiento en la nube.
    return (await _bucketRepository.uploadUserAvatar(imageCompressed,
        userName: userName), blurHash);
  }

  String _encodeBlurHash(Uint8List data) {
    final imageBlur = img.decodeImage(data);
    final blurHash = BlurHash.encode(imageBlur!, numCompX: 4, numCompY: 3);
    return blurHash.hash;
  }
}

// Proveedor de Riverpod que crea una instancia de `AvatarUploadUseCase`.
@riverpod
AvatarUploadUseCase avatarUploadUseCase(AvatarUploadUseCaseRef ref) {
  // Obtiene referencias a los proveedores de los repositorios local y en la nube, y del caso de uso de compresión.
  final bucketRepository = ref.watch(avatarBucketRepositoryProvider);
  final localRepository = ref.watch(avatarLocalRepositoryProvider);
  final imagecompress = ref.watch(imageCompressUseCaseProvider);

  // Devuelve una instancia de `AvatarUploadUseCase` inyectando las referencias obtenidas.
  return AvatarUploadUseCase(bucketRepository, localRepository, imagecompress);
}
