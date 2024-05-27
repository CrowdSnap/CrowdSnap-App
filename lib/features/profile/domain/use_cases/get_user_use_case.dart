import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_use_case.g.dart';

class GetUserUseCase {
  final UsersRepository _repository;

  GetUserUseCase(this._repository);

  Future<UserModel> execute(String userId) async {
    return await _repository.getUser(userId);
  }
}

@riverpod
Future<UserModel> userProvider(UserProviderRef ref, String userId) async {
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  return await getUserUseCase.execute(userId);
}

@Riverpod(keepAlive: true)
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return GetUserUseCase(usersRepository);
}