import 'package:crowd_snap/features/auth/data/datasources/google_user_data_source.dart';
import 'package:crowd_snap/features/auth/data/models/google_user_model.dart';
import 'package:crowd_snap/features/auth/domain/repositories/google_user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'google_user_repository_impl.g.dart';

@Riverpod(keepAlive: true)
GoogleUserRepository googleUserRepository(GoogleUserRepositoryRef ref) {
  final googleUserModelDataSource = ref.watch(googleUserModelDataSourceProvider);
  return GoogleUserRepositoryImpl(googleUserModelDataSource);
}

class GoogleUserRepositoryImpl implements GoogleUserRepository {
  final GoogleUserModelDataSource _googleUserModelDataSource;

  GoogleUserRepositoryImpl(this._googleUserModelDataSource);

  @override
  Future<void> saveGoogleUser(GoogleUserModel googleUser) async {
    try {
      await _googleUserModelDataSource.saveGoogleUserModel(googleUser);
    } catch (e) {
      throw Exception('Failed to save GoogleUser to SharedPreferences');
    }
  }

  @override
  Future<GoogleUserModel> getGoogleUser() async {
    try {
      final googleUser = await _googleUserModelDataSource.getGoogleUserModel();
      return googleUser;
    } catch (e) {
      throw Exception('Failed to get GoogleUser from SharedPreferences');
    } 
  }

  @override
  Future<void> deleteGoogleUser() async {
    try {
      await _googleUserModelDataSource.deleteGoogleUserModel();
    } catch (e) {
      throw Exception('Failed to delete GoogleUser from SharedPreferences');
    }
  }
}