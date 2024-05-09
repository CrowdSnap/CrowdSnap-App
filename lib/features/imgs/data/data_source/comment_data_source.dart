import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'comment_data_source.g.dart';

abstract class CommentDataSource {
  Future<List<CommentModel>> getCommentsByPost(String postId);
  Future<CommentModel> getCommentById(String commentId);
  Future<void> createComment(CommentModel comment);
  Future<void> loadEnvVariables();
  Future<void> addLikeToComment(String commentId, String userId);
  Future<void> removeLikeFromComment(String commentId, String userId);
}

@Riverpod(keepAlive: true)
CommentDataSource commentDataSource(CommentDataSourceRef ref) {
  return CommentDataSourceImpl();
}

class CommentDataSourceImpl implements CommentDataSource {
  String? _mongoUrl;

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _mongoUrl = dotenv.env['MONGO_URL'];
  }

  @override
  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final commentsCollection = db.collection('comments');

    final commentsData =
        await commentsCollection.find(where.eq('postId', postId)).toList();
    await db.close();

    print('commentsData: $commentsData');

    return commentsData.map((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<CommentModel> getCommentById(String commentId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final commentsCollection = db.collection('comments');

    final commentData = await commentsCollection.findOne(
      where.eq('_id', ObjectId.fromHexString(commentId)),
    );
    await db.close();

    return CommentModel.fromJson(commentData!);
  }

  @override
  Future<void> createComment(CommentModel comment) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final commentsCollection = db.collection('comments');

    await commentsCollection.insert({
      ...comment.toJson(),
    });

    await db.close();
  }

  @override
  Future<void> addLikeToComment(String commentId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final commentsCollection = db.collection('comments');

    await commentsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(commentId)),
      modify.addToSet('likedUserIds', userId),
    );

    await db.close();
  }

  @override
  Future<void> removeLikeFromComment(String commentId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final commentsCollection = db.collection('comments');

    await commentsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(commentId)),
      modify.pull('likedUserIds', userId),
    );

    await db.close();
  }
}
