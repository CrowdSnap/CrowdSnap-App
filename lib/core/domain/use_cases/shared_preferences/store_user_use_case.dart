import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/core/data/repository_impl/shared_preferences/user_repository_impl.dart';
import 'package:crowd_snap/core/domain/repositories/shared_preferences/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_user_use_case.g.dart';

class StoreUserUseCase {
  final UserRepository _repository;

  StoreUserUseCase(this._repository);

  Future<void> execute(UserModel user) async {
    await _repository.saveUser(user);
  }
}

@riverpod
StoreUserUseCase storeUserUseCase(StoreUserUseCaseRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return StoreUserUseCase(userRepository);
}