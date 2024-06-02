import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/filter_providers.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_random_get_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'random_post_state_notifier.g.dart';

@riverpod
class RandomPostList extends _$RandomPostList {
  final Set<String> _loadedPostIds = {};

  @override
  FutureOr<List<PostModel>> build() async {
    // Escuchar cambios en los filtros
    ref.listen<DateTime?>(startDateProvider, (previous, next) {
      _onFilterChanged();
    });
    ref.listen<DateTime?>(endDateProvider, (previous, next) {
      _onFilterChanged();
    });
    ref.listen<String?>(cityProvider, (previous, next) {
      _onFilterChanged();
    });
    ref.listen<int>(numberOfPostsProvider, (previous, next) {
      _onFilterChanged();
    });

    return _fetchPostsRandom();
  }

  Future<List<PostModel>> _fetchPostsRandom() async {
    final getPostsRandomByDateRangeUseCase =
        ref.watch(getPostsRandomByDateRangeUseCaseProvider);
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
    final newPosts =
        query.where((post) => !_loadedPostIds.contains(post.mongoId)).toList();

    // Actualizar la lista de IDs cargados
    _loadedPostIds.addAll(newPosts.map((post) => post.mongoId!));
    print('Query random: $city, $startDateOnly, $endDateOnly, $numberOfPosts');
    print('Postslist random: $_loadedPostIds');
    return query;
  }

  Future<void> loadMorePostsRandom() async {
    state = await AsyncValue.guard(() async {
      final currentPosts = state.value ?? [];
      final newPosts = await _fetchPostsRandom();
      return [...currentPosts, ...newPosts];
    });
  }

  Future<void> refreshPostsRandom() async {
    ref.invalidate(likesNotifierProvider);
    ref.invalidate(commentsNotifierProvider);
    _loadedPostIds.clear();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPostsRandom);
  }

  Future<void> _onFilterChanged() async {
    _loadedPostIds.clear();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchPostsRandom);
  }
}