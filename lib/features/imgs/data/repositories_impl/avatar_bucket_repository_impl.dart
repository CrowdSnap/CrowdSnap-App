import 'dart:io';

import 'package:crowd_snap/features/imgs/data/data_source/avatar_bucket_data_source.dart';
import 'package:crowd_snap/features/imgs/domain/repository/avatar_bucket_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_bucket_repository_impl.g.dart';

// Proveedor de Riverpod que crea una instancia única de `AvatarBucketRepositoryImpl`.
@Riverpod(keepAlive: true)
AvatarBucketRepositoryImpl avatarBucketRepository(
    AvatarBucketRepositoryRef ref) {
  // Obtiene una referencia al proveedor `avatarBucketDataSourceProvider` para acceder a las operaciones del bucket de avatares.
  final avatarBucketDataSource = ref.watch(avatarBucketDataSourceProvider);

  // Devuelve una implementación concreta de `AvatarBucketRepositoryImpl`.
  return AvatarBucketRepositoryImpl(avatarBucketDataSource);
}

// Implementación concreta de la interfaz `AvatarBucketRepository`.
class AvatarBucketRepositoryImpl implements AvatarBucketRepository {
  final AvatarBucketDataSource _avatarBucketDataSource;

  AvatarBucketRepositoryImpl(this._avatarBucketDataSource);

  // Sube una imagen de avatar del usuario a Firebase Storage.
  // Opcionalmente, recibe un nombre de usuario para nombrar la imagen.
  @override
  Future<String> uploadUserAvatar(File image, {String? userName}) {
    // Delega la operación al `AvatarBucketDataSource`.
    return _avatarBucketDataSource.uploadImage(image, userName: userName);
  }

  // Descarga una imagen de avatar del usuario del almacenamiento de Firebase Storage dada su URL o nombre de usuario.
  @override
  Future<File> getUserAvatar(String userName) {
    // Delega la operación al `AvatarBucketDataSource`.
    return _avatarBucketDataSource.getImage(userName);
  }

  // Elimina una imagen de avatar del usuario del almacenamiento de Firebase Storage dada su URL.
  @override
  Future<void> deleteUserAvatar(String imageUrl) {
    // Delega la operación al `AvatarBucketDataSource`.
    return _avatarBucketDataSource.deleteImage(imageUrl);
  }

  // Actualiza una imagen de avatar existente del usuario eliminándola primero y luego cargando una nueva.
  @override
  Future<String> updateUserAvatar(File image, String imageUrl) {
    // Delega la operación al `AvatarBucketDataSource`.
    return _avatarBucketDataSource.updateImage(image, imageUrl);
  }
}
