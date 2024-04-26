import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

part 'avatar_bucket_data_source.g.dart';

abstract class AvatarBucketDataSource {
  Future<String> uploadImage(File image, {String? userName});
  Future<File> getImage(String userName);
  Future<String> deleteImage(String imageUrl);
  Future<String> updateImage(File image, String imageUrl);
}

@Riverpod(keepAlive: true)
AvatarBucketDataSource avatarBucketDataSource(AvatarBucketDataSourceRef ref) {
  final firebaseStorage = FirebaseStorage.instance;
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return AvatarBucketDataSourceImpl(firebaseStorage, getUserUseCase);
}

class AvatarBucketDataSourceImpl implements AvatarBucketDataSource {
  final FirebaseStorage _firebaseStorage;
  final GetUserUseCase _getUserUseCase;

  AvatarBucketDataSourceImpl(this._firebaseStorage, this._getUserUseCase);

  @override
  Future<File> getImage(String avatarUrl) async {
    // Create a Dio instance
    final dio = Dio();

    // Get the app's directory for storing files
    final directory = await getApplicationDocumentsDirectory();

    // Create a new file in the app's directory
    final localFile = File('${directory.path}/$avatarUrl');

    // Download the image file from the URL
    await dio.download(avatarUrl, localFile.path);
    return localFile;
  }

  @override
  Future<String> uploadImage(File image, {String? userName}) async {
    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }
    final imageName = '$userName-${DateTime.now()}.jpeg';
    final ref = _firebaseStorage.ref().child('images/$imageName');
    final uploadTask = ref.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  @override
  Future<String> deleteImage(String imageUrl) async {
    final ref = _firebaseStorage.refFromURL(imageUrl);
    await ref.delete();
    return imageUrl;
  }

  @override
  Future<String> updateImage(File image, String imageUrl) async {
    final ref = _firebaseStorage.refFromURL(imageUrl);
    await ref.delete();
    final newImageUrl = await uploadImage(image);
    return newImageUrl;
  }
}
