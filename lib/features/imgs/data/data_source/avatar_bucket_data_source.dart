import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

part 'avatar_bucket_data_source.g.dart';

// Interfaz `AvatarBucketDataSource` que define un contrato para interactuar con el almacenamiento de avatares.
abstract class AvatarBucketDataSource {
  // Sube una imagen de avatar al almacenamiento de Firebase Storage.
  // Opcionalmente, recibe un nombre de usuario para nombrar la imagen.
  Future<String> uploadImage(File image, {String? userName});

  // Descarga una imagen de avatar del almacenamiento de Firebase Storage dada su URL.
  Future<File> getImage(String userName);

  // Elimina una imagen de avatar del almacenamiento de Firebase Storage dada su URL.
  Future<void> deleteImage(String imageUrl);

  // Actualiza una imagen de avatar existente eliminándola primero y luego cargando una nueva.
  Future<String> updateImage(File image, String imageUrl);
}

// Proveedor de Riverpod que crea una instancia única de `AvatarBucketDataSource`.
@Riverpod(keepAlive: true)
AvatarBucketDataSource avatarBucketDataSource(AvatarBucketDataSourceRef ref) {
  // Obtiene una instancia de Firebase Storage.
  final firebaseStorage = FirebaseStorage.instance;

  // Obtiene una referencia al proveedor `getUserLocalUseCaseProvider` para leer información del usuario.
  final getUserUseCase = ref.read(getUserLocalUseCaseProvider);

  // Devuelve una implementación concreta de `AvatarBucketDataSource`.
  return AvatarBucketDataSourceImpl(firebaseStorage, getUserUseCase);
}

// Implementación concreta de la interfaz `AvatarBucketDataSource`.
class AvatarBucketDataSourceImpl implements AvatarBucketDataSource {
  final FirebaseStorage _firebaseStorage;
  final GetUserLocalUseCase _getUserUseCase;

  AvatarBucketDataSourceImpl(this._firebaseStorage, this._getUserUseCase);

  // Implementación del método `getImage`.
  @override
  Future<File> getImage(String avatarUrl) async {
    // Crea una instancia de Dio para realizar peticiones HTTP.
    final dio = Dio();

    // Obtiene el directorio de la aplicación para almacenar archivos.
    final directory = await getApplicationDocumentsDirectory();

    // Crea un nuevo archivo en el directorio de la aplicación con el nombre de la URL del avatar.
    final localFile = File('${directory.path}/$avatarUrl');

    // Descarga el archivo de imagen desde la URL y lo guarda en el archivo local.
    await dio.download(avatarUrl, localFile.path);

    // Retorna el archivo local descargado.
    return localFile;
  }

  // Implementación del método `uploadImage`.
  @override
  Future<String> uploadImage(File image, {String? userName}) async {
    // Si no se proporciona un nombre de usuario, se obtiene el nombre de usuario actual.
    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }

    // Crea un nombre único para la imagen combinando el nombre de usuario y la fecha y hora actual con la extensión .jpeg.
    final imageName = '$userName-avatar.jpeg';

    // Obtiene una referencia al almacenamiento de Firebase Storage en la ruta "images/$imageName".
    final ref = _firebaseStorage.ref().child('images/$imageName');

    // Sube el archivo de imagen a la referencia.
    final uploadTask = ref.putFile(image);

    // Espera a que se complete la subida y luego obtiene la URL de descarga de la imagen subida.
    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();

    // Retorna la URL de descarga de la imagen subida.
    return imageUrl;
  }

  // Implementación del método `deleteImage`.
  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      // Obtiene una referencia a la imagen en Firebase Storage utilizando la URL.
      final ref = _firebaseStorage.refFromURL(imageUrl);

      // Elimina la imagen de la referencia.
      await ref.delete();
    } on Exception catch (e) {
      // Imprime el error de eliminación en la consola.
      print('Error deleting image: $e');

      // Re-lanza una excepción con un mensaje de error más informativo.
      throw Exception(
          'Error deleting image from Firebase Storage ${e.toString()}');
    }
  }

  // Implementación del método `updateImage`.
  @override
  Future<String> updateImage(File image, String imageUrl) async {
    // Obtiene una referencia a la imagen existente en Firebase Storage utilizando la URL.
    final ref = _firebaseStorage.refFromURL(imageUrl);

    // Elimina la imagen existente de la referencia.
    await ref.delete();

    // Sube la nueva imagen y obtén la URL de descarga de la nueva imagen subida.
    final newImageUrl = await uploadImage(image);

    // Retorna la URL de descarga de la nueva imagen subida.
    return newImageUrl;
  }
}
