import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/data/data_source/post_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_state_notifier.g.dart';

@riverpod
class PostList extends _$PostList {
  @override
  FutureOr<List<PostModel>> build() async {
    return _fetchPosts();
  }

  Future<List<PostModel>> _fetchPosts() async {
    final postDataSource = ref.watch(postDataSourceProvider);
    return postDataSource.getPostsRandomByDateRange(
        'Madrid', DateTime(2024, 05, 05), DateTime(2024, 05, 11), 2);
  }

  Future<void> loadMorePosts() async {
    state = await AsyncValue.guard(() async {
      final currentPosts = state.value ?? [];
      final newPosts = await _fetchPosts();
      return [...currentPosts, ...newPosts];
    });
  }

  Future<void> refreshPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPosts);
  }
}
