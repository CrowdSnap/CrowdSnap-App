
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'avatar_bucket_data_source.g.dart';

abstract class AvatarBucketDataSource {
  Future<String> uploadImage(File image);
  Future<String> deleteImage(String imageUrl);
  Future<String> updateImage(File image, String imageUrl);
}

@Riverpod(keepAlive: true)
AvatarBucketDataSource avatarBucketDataSource(AvatarBucketDataSourceRef ref) {
  final firebaseStorage = FirebaseStorage.instance;
  return AvatarBucketDataSourceImpl(firebaseStorage);
}

class AvatarBucketDataSourceImpl implements AvatarBucketDataSource {
  final FirebaseStorage _firebaseStorage;

  AvatarBucketDataSourceImpl(this._firebaseStorage);

  @override
  Future<String> uploadImage(File image) async {
    final ref = _firebaseStorage.ref().child('images/${image.path}');
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