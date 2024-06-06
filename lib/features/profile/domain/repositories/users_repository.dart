import 'package:crowd_snap/core/data/models/user_model.dart';
import 'package:crowd_snap/features/profile/data/models/connection_model.dart';

import '../../data/models/connection_status.dart';

abstract class UsersRepository {
  Future<UserModel> getUser(String userId);
  Future<List<ConnectionModel>> getPendingConnections(String localUserId);
  Future<void> addTaggingConnection(
      String localUserId, String userId, String imageUrl, String postId);
  Future<void> removeTaggingConnection(String localUserId, String userId);
  Future<void> addConnection(String localUserId, String userId);
  Future<void> acceptConnection(String localUserId, String userId);
  Future<void> acceptTaggingConnection(String localUserId, String userId);
  Future<void> rejectConnection(String localUserId, String userId);
  Future<void> updateUserFCMToken(UserModel user, String fcmToken);
  Future<void> removeConnection(String localUserId, String userId);
  Future<ConnectionModel> checkConnection(String localUserId, String userId);
  Future<List<Map<String, DateTime>>> getUserConnections(String userId,
      {String? startAfter, int limit = 30});
}
