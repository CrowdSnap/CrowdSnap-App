import 'dart:io';

import 'package:crowd_snap/core/data/repository_impl/shared_preferences/avatar_local_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/avatar_local_repository.dart';
import 'package:crowd_snap/features/imgs/data/repositories_impl/avatar_bucket_repository_impl.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_get_use_case.g.dart';

// Clase `AvatarGetUseCase` que se encarga de obtener la imagen de avatar del usuario.
class AvatarGetUseCase {
  // Instancia del repositorio de almacenamiento local de avatares.
  final AvatarLocalRepository _localRepository;

  // Instancia del repositorio de almacenamiento en la nube de avatares (generalmente Firebase Storage).
  final AvatarBucketRepository _bucketRepository;

  // Constructor que recibe las instancias de los repositorios local y en la nube.
  AvatarGetUseCase(this._localRepository, this._bucketRepository);

  // Método `execute` que se encarga de obtener la imagen de avatar del usuario.
  // Toma un `String imageName` como parámetro (opcionalmente utilizado para identificar la imagen localmente).
  Future<File> execute(String imageName) async {
    try {
      // Intenta obtener la imagen del avatar del almacenamiento local.
      final image = await _localRepository.getAvatar();

      // Si se encuentra la imagen localmente, imprime un mensaje e inmediatamente devuelve el archivo de imagen local.
      print('Avatar from local storage: $image');
      return image;
    } catch (e) {
      // Si hay un error al obtener la imagen del almacenamiento local (por ejemplo, la imagen no existe),
      // imprime un mensaje de error.
      print('Error getting avatar from local storage: $e');

      // Intenta obtener la imagen del avatar del almacenamiento en la nube utilizando el repositorio `_bucketRepository`.
      final avatar = await _bucketRepository.getUserAvatar(imageName);

      // Si se descarga la imagen del almacenamiento en la nube exitosamente,
      // guarda la imagen descargada en el almacenamiento local utilizando el repositorio `_localRepository`.
      await _localRepository.saveAvatar(avatar);

      // Devuelve el archivo de imagen descargado del almacenamiento en la nube.
      return avatar;
    }
  }
}

// Proveedor de Riverpod que crea una instancia de `AvatarGetUseCase`.
@riverpod
AvatarGetUseCase avatarGetUseCase(AvatarGetUseCaseRef ref) {
  // Obtiene una referencia al proveedor `avatarLocalRepositoryProvider` para acceder al repositorio local.
  final localRepository = ref.watch(avatarLocalRepositoryProvider);

  // Obtiene una referencia al proveedor `avatarBucketRepositoryProvider` para acceder al repositorio en la nube.
  final bucketRepository = ref.watch(avatarBucketRepositoryProvider);

  // Devuelve una instancia de `AvatarGetUseCase` inyectando las referencias a los repositorios local y en la nube.
  return AvatarGetUseCase(localRepository, bucketRepository);
}
