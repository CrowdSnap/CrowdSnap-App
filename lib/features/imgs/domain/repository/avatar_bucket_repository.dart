import 'dart:io';

// Interfaz `AvatarBucketRepository` que define un contrato para interactuar con el almacenamiento de avatares de usuario.
abstract class AvatarBucketRepository {
  // Sube una imagen de avatar del usuario al almacenamiento.
  // Opcionalmente, recibe un nombre de usuario para nombrar la imagen.
  Future<String> uploadUserAvatar(File image, {String? userName});

  // Descarga una imagen de avatar del usuario del almacenamiento dada su URL o nombre de usuario.
  Future<File> getUserAvatar(String userName);

  // Elimina una imagen de avatar del usuario del almacenamiento dada su URL.
  Future<void> deleteUserAvatar(String imageUrl);

  // Actualiza una imagen de avatar existente del usuario eliminándola primero y luego cargando una nueva.
  Future<String> updateUserAvatar(File image, String imageUrl);
}
