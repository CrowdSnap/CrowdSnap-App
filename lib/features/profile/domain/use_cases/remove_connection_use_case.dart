import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:crowd_snap/features/profile/domain/repositories/users_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remove_connection_use_case.g.dart';

class RemoveConnectionUseCase {
  final UsersRepository _repository;

  RemoveConnectionUseCase(this._repository);

  Future<void> execute(String userId, String connectionId) async {
    await _repository.removeConnection(userId, connectionId);
  }
}

@riverpod
Future<void> removeConnectionProvider(RemoveConnectionProviderRef ref, String userId, String connectionId) async {
  final removeConnectionUseCase = ref.watch(removeConnectionUseCaseProvider);
  await removeConnectionUseCase.execute(userId, connectionId);
}

@Riverpod(keepAlive: true)
RemoveConnectionUseCase removeConnectionUseCase(RemoveConnectionUseCaseRef ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return RemoveConnectionUseCase(usersRepository);
}