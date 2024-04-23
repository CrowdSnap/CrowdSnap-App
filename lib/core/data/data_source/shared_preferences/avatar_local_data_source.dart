import 'dart:io';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_local_data_source.g.dart';

abstract class AvatarLocalDataSource {
  Future<void> saveAvatar(File avatar);
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
  Future<void> saveAvatar(File avatar) async {
    final user = await _getUserUseCase.execute();
    final userName = user.username;
    final imageName = '$userName-${DateTime.now()}.jpeg';
    final directory = await getApplicationDocumentsDirectory();
    await avatar.copy('${directory.path}/$imageName');
  }

  @override
  Future<File> getAvatar() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();

    if (files.isNotEmpty) {
      // Obtener el archivo de imagen ms reciente
      final avatarFile = files.last;
      return File(avatarFile.path);
    } else {
      throw Exception('No avatar image found');
    }
  }

  @override
  Future<void> deleteAvatar() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();

    if (files.isNotEmpty) {
      // Find the avatar file and delete it
      try {
        final avatarFile = files.firstWhere(
          (file) => file.path.contains('avatar'),
        );
        await avatarFile.delete();
      } catch (e) {
        // Avatar file not found, handle the exception if needed
        throw Exception('Avatar file not found');
      }
    }
  }
}
