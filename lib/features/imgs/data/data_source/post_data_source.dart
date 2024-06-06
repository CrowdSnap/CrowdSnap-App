import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

part 'post_data_source.g.dart';

abstract class PostDataSource {
  Future<List<PostModel>> getPostsRandomByDateRange(String location,
      DateTime startDate, DateTime endDate, int limit, List<String> excludeIds);
  Future<List<PostModel>> getPostsOrderedByLikes(String location,
      DateTime startDate, DateTime endDate, int limit, List<String> excludeIds);
  Future<List<PostModel>> getTaggedPostsByUserId(String userId);
  Future<List<PostModel>> getPostsByUser(String userId);
  Future<String> createPost(PostModel post);
  Future<void> loadEnvVariables();
  Future<void> incrementCommentCount(String postId);
  Future<void> decrementCommentCount(String postId);
  Future<void> addLikeToPost(String postId, String userId);
  Future<void> removeLikeFromPost(String postId, String userId);
  Future<void> deletePendingTaggedFromPost(String postId, String userId);
  Future<void> acceptPendingTaggedToPost(String postId, String userId);
  Future<void> deletePost(String postId);
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
  Future<List<PostModel>> getPostsByUser(String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    final postsData =
        await postsCollection.find(where.eq('userId', userId)).toList();
    await db.close();

    return postsData.map((json) {
      final id =
          json['_id'].toString().split('"')[1]; // Extraer el valor de ObjectId
      final postJson = {
        ...json,
        'mongoId': id,
      };
      return PostModel.fromJson(postJson);
    }).toList();
  }

  @override
  Future<List<PostModel>> getPostsRandomByDateRange(
      String location,
      DateTime startDate,
      DateTime endDate,
      int limit,
      List<String> excludeIds) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    final pipeline = [
      {
        '\$match': {
          'location': location,
          'createdAt': {
            '\$gte': startDate.toString(),
            '\$lte': endDate.toString()
          },
          '_id': {
            '\$nin': excludeIds.map((id) => ObjectId.fromHexString(id)).toList()
          } // Excluir IDs
        }
      },
      {
        '\$sample': {'size': limit}
      }
    ];

    final postsData =
        await postsCollection.aggregateToStream(pipeline).toList();
    await db.close();

    return postsData.map((json) {
      final id =
          json['_id'].toString().split('"')[1]; // Extract the ObjectId value
      final postJson = {
        ...json,
        'mongoId': id,
      };
      return PostModel.fromJson(postJson);
    }).toList();
  }

  @override
  Future<List<PostModel>> getPostsOrderedByLikes(
      String location,
      DateTime startDate,
      DateTime endDate,
      int limit,
      List<String> excludeIds) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    final pipeline = [
      {
        '\$match': {
          'location': location,
          'createdAt': {
            '\$gte': startDate.toString(),
            '\$lte': endDate.toString()
          },
          '_id': {
            '\$nin': excludeIds.map((id) => ObjectId.fromHexString(id)).toList()
          } // Excluir IDs
        }
      },
      {
        '\$sort': {
          'likeCount': -1
        } // Ordenar por likeCount en orden descendente
      },
      {
        '\$limit': limit // Limitar el número de resultados
      }
    ];

    final postsData =
        await postsCollection.aggregateToStream(pipeline).toList();
    await db.close();

    return postsData.map((json) {
      final id =
          json['_id'].toString().split('"')[1]; // Extraer el valor de ObjectId
      final postJson = {
        ...json,
        'mongoId': id,
      };
      return PostModel.fromJson(postJson);
    }).toList();
  }

  @override
  Future<List<PostModel>> getTaggedPostsByUserId(String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    // Buscar en el array de taggedUserIds el userId y devolver los posts
    final postsData =
        await postsCollection.find(where.eq('taggedUserIds', userId)).toList();

    return postsData.map((json) {
      final id =
          json['_id'].toString().split('"')[1]; // Extraer el valor de ObjectId
      final postJson = {
        ...json,
        'mongoId': id,
      };
      return PostModel.fromJson(postJson);
    }).toList();
  }

  @override
  Future<String> createPost(PostModel post) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    print('Creating post: ${post.toJson()}');

    // Insertar el post y obtener el ID del documento insertado
    final result = await postsCollection.insertOne({
      ...post.toJson(),
    });

    // Verificar si la inserción fue exitosa y obtener el ID
    if (result.isSuccess) {
      final insertedId = result.id.toHexString();
      await db.close();
      return insertedId;
    } else {
      await db.close();
      throw Exception('Failed to insert post');
    }
  }

  @override
  Future<void> addLikeToPost(String postId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.inc('likeCount', 1).push('likes',
          {'userId': userId, 'createdAt': DateTime.now().toIso8601String()}),
    );

    await db.close();
  }

  @override
  Future<void> removeLikeFromPost(String postId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.inc('likeCount', -1).pull('likes', {'userId': userId}),
    );

    await db.close();
  }

  @override
  Future<void> incrementCommentCount(String postId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.inc('commentCount', 1),
    );

    await db.close();
  }

  @override
  Future<void> decrementCommentCount(String postId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.inc('commentCount', -1),
    );

    await db.close();
  }

  @override
  Future<void> deletePendingTaggedFromPost(String postId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.pull('taggedUserIds', userId),
    );

    await db.close();
  }

  @override
  Future<void> acceptPendingTaggedToPost(String postId, String userId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection.updateOne(
      where.eq('_id', ObjectId.fromHexString(postId)),
      modify.pull('taggedPendingUserIds', userId).push('taggedUserIds', userId),
    );

    await db.close();
  }

  @override
  Future<void> deletePost(String postId) async {
    final Db db = await Db.create(_mongoUrl!);
    await db.open();
    final postsCollection = db.collection('posts');

    await postsCollection
        .remove(where.eq('_id', ObjectId.fromHexString(postId)));

    await db.close();
  }
}
