import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_local_use_case.dart';
import 'package:crowd_snap/features/profile/data/repositories_impl/users_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status_provider.g.dart';

@riverpod
Future<bool> connectionStatusProvider(ConnectionStatusProviderRef ref, String userId) async {
  final getUserUseCase = ref.read(getUserLocalUseCaseProvider);
  final localUser = await getUserUseCase.execute();
  final checkConnection = ref.read(usersRepositoryProvider);
  return await checkConnection.checkConnection(localUser.userId, userId);
}