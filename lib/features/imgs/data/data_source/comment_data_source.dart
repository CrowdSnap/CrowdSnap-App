import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'comment_data_source.g.dart';

abstract class CommentDataSource {
  Future<List<CommentModel>> getCommentsByPost(String postId);
  Future<CommentModel> getCommentById(String postId, String commentId);
  Future<void> createComment(String postId, CommentModel comment);
  Future<void> loadEnvVariables();
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
    final postsCollection = db.collection('posts');

    final post = await postsCollection.findOne(where.eq('_id', ObjectId.fromHexString(postId)));
    await db.close();

    final commentsData = post?['comments'] ?? [];
    return commentsData.map<CommentModel>((json) => CommentModel.fromJson(json)).toList();
  }

  @override
  Future<CommentModel> getCommentById(String postId, String commentId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    final post = await postsCollection.findOne(where.eq('_id', ObjectId.fromHexString(postId)));
    await db.close();

    final commentData = post?['comments']?.firstWhere((comment) => comment['_id'] == ObjectId.fromHexString(commentId));
    return CommentModel.fromJson(commentData);
  }

  @override
  Future<void> createComment(String postId, CommentModel comment) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.inc('commentCount', 1).push('comments', comment.toJson()),
    );

    await db.close();
  }
}