import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_user_use_case.g.dart';

class DeleteUserUseCase {
  final UserRepository _repository;

  DeleteUserUseCase(this._repository);

  Future<void> execute() async {
    return await _repository.deleteUser();
  }
}

@riverpod
DeleteUserUseCase deleteUserUseCase(DeleteUserUseCaseRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return DeleteUserUseCase(userRepository);
}