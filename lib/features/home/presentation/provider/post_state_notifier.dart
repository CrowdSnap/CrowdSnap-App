import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/filter_providers.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_get_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_state_notifier.g.dart';

@riverpod
class PostList extends _$PostList {
  Set<String> _loadedPostIds = {};

  @override
  FutureOr<List<PostModel>> build() async {
    return _fetchPosts();
  }

  Future<List<PostModel>> _fetchPosts() async {
    final getPostsRandomByDateRangeUseCase = ref.watch(getPostsRandomByDateRangeUseCaseProvider);
    final startDate = ref.watch(startDateProvider);
    final endDate = ref.watch(endDateProvider);
    final city = ref.watch(cityProvider);
    final numberOfPosts = ref.watch(numberOfPostsProvider);

    // Obtener la fecha actual
    final now = DateTime.now();

    // Calcular el lunes y el domingo de la semana actual
    final monday = DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final sunday = DateTime(now.year, now.month, now.day + (8 - now.weekday));

    // Establecer startDate y endDate por defecto si no hay valores seleccionados
    final defaultStartDate = startDate ?? monday;
    final defaultEndDate = endDate ?? sunday;

    // Obtener solo la fecha sin la hora
    final startDateOnly = DateTime(
        defaultStartDate.year, defaultStartDate.month, defaultStartDate.day);
    final endDateOnly =
        DateTime(defaultEndDate.year, defaultEndDate.month, defaultEndDate.day);

    final query = await getPostsRandomByDateRangeUseCase.execute(
      city ?? 'Madrid',
      startDateOnly,
      endDateOnly,
      numberOfPosts,
      _loadedPostIds.toList(),
    );

    // Filtrar posts que ya han sido cargados
    final newPosts = query.where((post) => !_loadedPostIds.contains(post.mongoId)).toList();

    // Actualizar la lista de IDs cargados
    _loadedPostIds.addAll(newPosts.map((post) => post.mongoId!));
    print('Query: $city, $startDateOnly, $endDateOnly, $numberOfPosts');
    print('Postslist: $_loadedPostIds');
    return query;
  }

  Future<void> loadMorePosts() async {
    state = await AsyncValue.guard(() async {
      final currentPosts = state.value ?? [];
      final newPosts = await _fetchPosts();
      return [...currentPosts, ...newPosts];
    });
  }

  Future<void> refreshPosts() async {
    ref.invalidate(likesNotifierProvider);
    ref.invalidate(commentsNotifierProvider);
    _loadedPostIds.clear();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPosts);
  }
}
