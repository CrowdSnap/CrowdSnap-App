import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'post_data_source.g.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPostsRandomByDateRange(
      String city, DateTime startDate, DateTime endDate, int limit);
  Future<void> createPost(PostModel post, String city);
}

@Riverpod(keepAlive: true)
PostDataSource postDataSource(PostDataSourceRef ref) {
  return PostDataSourceImpl();
}

class PostDataSourceImpl implements PostDataSource {
  final Db _db = Db('mongodb+srv://alex03marcos:K1f1cdbQGrbyFVHx@cluster0.miqyblk.mongodb.net/CrowdSnap?retryWrites=true&w=majority');

  @override
  Future<List<PostModel>> getPostsRandomByDateRange(
      String city, DateTime startDate, DateTime endDate, int limit) async {
    await _db.open();
    final postsCollection = _db.collection('posts');

    final pipeline = [
      {
        '\$match': {
          'city': city,
          'createdAt': {'\$gte': startDate, '\$lte': endDate}
        }
      },
      {
        '\$sample': {'size': limit}
      }
    ];

    final postsData =
        await postsCollection.aggregateToStream(pipeline).toList();
    await _db.close();

    return postsData.map((json) => PostModel.fromJson(json)).toList();
  }

  @override
  Future<void> createPost(PostModel post, String city) async {
    await _db.open();
    final postsCollection = _db.collection('posts');

    await postsCollection.insert({
      ...post.toJson(),
      'city': city,
    });

    await _db.close();
  }
}
