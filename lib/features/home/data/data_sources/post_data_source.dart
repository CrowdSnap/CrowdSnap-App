import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'post_data_source.g.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPostsRandomByDateRange(
      String city, DateTime startDate, DateTime endDate, int limit);
  Future<void> createPost(PostModel post);
  Future<void> loadEnvVariables();
}

@Riverpod(keepAlive: true)
PostDataSource postDataSource(PostDataSourceRef ref) {
  return PostDataSourceImpl();
}

class PostDataSourceImpl implements PostDataSource {
  String? _mongoUrl;

  @override
  Future<void> loadEnvVariables() async {
    await dotenv.load();
    _mongoUrl = dotenv.env['MONGO_URL'];
  }

  @override
  Future<List<PostModel>> getPostsRandomByDateRange(
      String city, DateTime startDate, DateTime endDate, int limit) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

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
    await db.close();

    return postsData.map((json) => PostModel.fromJson(json)).toList();
  }

  @override
  Future<void> createPost(PostModel post) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.insert({
      ...post.toJson(),
    });

    await db.close();
  }
}
