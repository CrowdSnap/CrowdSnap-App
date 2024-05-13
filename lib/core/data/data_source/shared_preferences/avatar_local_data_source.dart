import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_local_data_source.g.dart';

abstract class AvatarLocalDataSource {
  Future<void> saveAvatar(File avatar, {String? userName});
  Future<File> getAvatar();
  Future<void> deleteAvatar();
}

@Riverpod(keepAlive: true)
AvatarLocalDataSource avatarLocalDataSource(AvatarLocalDataSourceRef ref) {
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return AvatarLocalDataSourceImpl(getUserUseCase);
}

class AvatarLocalDataSourceImpl implements AvatarLocalDataSource {
  final GetUserUseCase _getUserUseCase;
  AvatarLocalDataSourceImpl(this._getUserUseCase);

  @override
  Future<void> saveAvatar(File avatar, {String? userName}) async {
    print('Saving avatar for user $userName');
    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }
    final imageName =
        'avatar-$userName.jpeg';

    final directory = await getApplicationDocumentsDirectory();
    await avatar.copy('${directory.path}/$imageName');
    print('Avatar saved');
  }

  @override
  Future<File> getAvatar() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();
    final user = await _getUserUseCase.execute();
    final userName = user.username;

    final avatarFiles = files
        .where((file) =>
            file.path.contains('avatar-$userName') &&
            file.path.endsWith('.jpeg'))
        .toList();

    if (avatarFiles.isNotEmpty) {
      avatarFiles.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      final avatarFile = avatarFiles.first;
      print('Avatar file found: ${avatarFile.path}');
      return File(avatarFile.path);
    } else {
      print('Avatar file not found for user $userName');
      throw Exception('Avatar file not found');
    }
  }

  @override
  Future<void> deleteAvatar() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();
    final user = await _getUserUseCase.execute();
    final userName = user.username;

    final avatarFiles = files
        .where((file) =>
            file.path.contains('avatar-$userName') &&
            file.path.endsWith('.jpeg'))
        .toList();

    if (avatarFiles.isNotEmpty) {
      avatarFiles.sort(
          (a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      final avatarFile = avatarFiles.first;
      print('Avatar file deleted: ${avatarFile.path}');
      await File(avatarFile.path).delete();
    } else {
      print('Avatar file not found for user $userName');
      throw Exception('Avatar file not found');
    }
  }
}
