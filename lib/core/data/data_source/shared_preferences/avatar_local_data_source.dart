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
    if (userName == null) {
      final user = await _getUserUseCase.execute();
      userName = user.username;
    }
    final imageName = 'avatar-$userName.jpeg';
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

    if (files.isNotEmpty) {
      // Find the avatar file and return it
      try {
        final avatarFile = files.firstWhere(
          (file) => file.path.contains('avatar-$userName.jpeg'),
        );
        print('Returning avatar file: ${avatarFile.path}');
        return File(avatarFile.path);
      } on StateError {
        // Avatar file not found, handle the exception if needed
        print('Avatar file not found for user $userName');
        throw Exception('Avatar file not found');
      } catch (e) {
        // Avatar file not found, handle the exception if needed
        print('Exception: $e');
        throw Exception(e.toString());
      }
    } else {
      // Avatar file not found, handle the exception if needed
      print('Avatar file not found');
      throw Exception('Avatar file not found');
    }
  }

  @override
  Future<void> deleteAvatar() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = await directory.list().toList();
    final user = await _getUserUseCase.execute();
    final userName = user.username;

    if (files.isNotEmpty) {
      // Find the avatar file and delete it
      try {
        final avatarFile = files.firstWhere(
          (file) => file.path.contains('avatar-$userName.jpeg'),
        );
        print('Deleting avatar file: ${avatarFile.path}');
        await avatarFile.delete();
        print('Avatar file deleted');
      } on StateError {
        // Avatar file not found, handle the exception if needed
        print('Avatar file not found for user $userName');
        throw Exception('Avatar file not found');
      } catch (e) {
        // Avatar file not found, handle the exception if needed
        print('Avatar file not found');
        throw Exception('Avatar file not found');
      }
    }
  }
}
