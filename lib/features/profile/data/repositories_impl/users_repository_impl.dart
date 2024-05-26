import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/data_source/users_data_source.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_repository_impl.g.dart';

@Riverpod(keepAlive: true)
UsersRepository usersRepository(UsersRepositoryRef ref) {
  final usersDataSource = ref.watch(usersDataSourceProvider);
  return UsersRepositoryImpl(usersDataSource);
}

class UsersRepositoryImpl implements UsersRepository {
  final UsersDataSource _usersModelDataSource;

  UsersRepositoryImpl(this._usersModelDataSource);

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final usersModel = await _usersModelDataSource.getUser(userId);
      return usersModel;
    } catch (e) {
      throw Exception('Failed to get user from Firestore');
    }
  }
}