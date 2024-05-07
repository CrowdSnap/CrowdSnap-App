import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/post_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@riverpod
Future<List<PostModel>> postList(PostListRef ref) async {
  final postDataSource = ref.watch(postDataSourceProvider);
  return postDataSource.getAll();
}
