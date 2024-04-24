import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_user_use_case.g.dart';

class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<UserModel> execute() async {
    return await _repository.getUser();
  }
}

@riverpod
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return GetUserUseCase(userRepository);
}