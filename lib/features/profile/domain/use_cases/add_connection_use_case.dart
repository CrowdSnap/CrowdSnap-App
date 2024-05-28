import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_connection_use_case.g.dart';

class AddConnectionUseCase {
  final UsersRepository _repository;

  AddConnectionUseCase(this._repository);

  Future<void> execute(String userId, String connectionId) async {
    await _repository.addConnection(userId, connectionId);
  }
}

@Riverpod(keepAlive: true)
AddConnectionUseCase addConnectionUseCase(AddConnectionUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return AddConnectionUseCase(usersRepository);
}