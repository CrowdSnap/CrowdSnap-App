import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'like_data_source.g.dart';

abstract class LikeDataSource {
  Future<List<LikeModel>> getLikesByPostId(String postId);
  Future<void> createLike(LikeModel like);
  Future<void> removeLike(String postId, String userId);
  Future<void> loadEnvVariables();
}

@Riverpod(keepAlive: true)
LikeDataSource likeDataSource(LikeDataSourceRef ref) {
  return LikeDataSourceImpl();
}

class LikeDataSourceImpl implements LikeDataSource {
  String? _mongoUrl;

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _mongoUrl = dotenv.env['MONGO_URL'];
  }

  @override
  Future<List<LikeModel>> getLikesByPostId(String postId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final likesCollection = db.collection('likes');

    final likesData = await likesCollection.find(where.eq('postId', postId)).toList();
    await db.close();

    print('likesData: $likesData');

    return likesData.map((json) => LikeModel.fromJson(json)).toList();
  }

  @override
  Future<void> createLike(LikeModel like) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final likesCollection = db.collection('likes');

    await likesCollection.insert({
      ...like.toJson(),
    });

    await db.close();
  }

  @override
  Future<void> removeLike(String postId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final likesCollection = db.collection('likes');

    await likesCollection.deleteOne(where.eq('postId', postId).and(where.eq('userId', userId)));

    await db.close();
  }
}
