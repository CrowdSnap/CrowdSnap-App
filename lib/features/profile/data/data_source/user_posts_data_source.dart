import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_posts_data_source.g.dart';

abstract class UserPostsDataSource {
  Future<List<PostModel>> getUserPosts(String userId);
  Future<void> loadEnvVariables();
}

@Riverpod(keepAlive: true)
UserPostsDataSource userPostsDataSource(UserPostsDataSourceRef ref) {
  return UserPostsDataSourceImpl();
}

class UserPostsDataSourceImpl implements UserPostsDataSource {
  String? _mongoUrl;

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _mongoUrl = dotenv.env['MONGO_URL'];
  }

  @override
  Future<List<PostModel>> getUserPosts(String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    final posts = await postsCollection.find(where.eq('userId', userId)).toList();
    await db.close(); 

    return posts.map<PostModel>((json) => PostModel.fromJson(json)).toList();
  }
}
