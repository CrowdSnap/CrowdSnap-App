import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/block_scroll.dart';
import 'package:crowd_snap/features/home/presentation/provider/ordered_bylikes_post_state_notifier.dart';
import 'package:crowd_snap/features/home/presentation/provider/random_post_state_notifier.dart';
import 'package:crowd_snap/features/home/presentation/widgets/filter_badges.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showRandomPosts = true; // Variable para controlar el tipo de posts
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  void _togglePosts() {
    setState(() {
      _showRandomPosts = !_showRandomPosts;
    });
    _scrollToTop();
    if (_showRandomPosts) {
      ref.read(randomPostListProvider.notifier).refreshPostsRandom();
    } else {
      ref
          .read(orderedByLikesPostListProvider.notifier)
          .refreshPostsOrderedByLikes();
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() {
      _isLoading = true;
    });
    if (_showRandomPosts) {
      await ref.read(randomPostListProvider.notifier).loadMorePostsRandom();
    } else {
      await ref
          .read(orderedByLikesPostListProvider.notifier)
          .loadMorePostsOrderedByLikes();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final randomPostListAsyncValue = ref.watch(randomPostListProvider);
    final orderedByLikesPostListAsyncValue =
        ref.watch(orderedByLikesPostListProvider);
    final blockScroll = ref.watch(blockScrollProvider);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: GestureDetector(
                onTap: () {
                  HapticFeedback.vibrate();
                  if (_showRandomPosts) {
                    ref
                        .read(orderedByLikesPostListProvider.notifier)
                        .refreshPostsOrderedByLikes();
                  } else {
                    ref
                        .read(randomPostListProvider.notifier)
                        .refreshPostsRandom();
                  }
                },
                child: Image.asset(
                  'assets/icons/crowd_snap_logo.png',
                  height: 165,
                  width: 85,
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_rounded),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    context.push('/notifications');
                  },
                ),
              ],
              pinned: false,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: _showRandomPosts
                  ? _buildListView(randomPostListAsyncValue, blockScroll)
                  : _buildListView(
                      orderedByLikesPostListAsyncValue, blockScroll),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
      AsyncValue<List<PostModel>> postListAsyncValue, bool blockScroll) {
    return RefreshIndicator(
      onRefresh: () => _showRandomPosts
          ? ref.read(randomPostListProvider.notifier).refreshPostsRandom()
          : ref
              .read(orderedByLikesPostListProvider.notifier)
              .refreshPostsOrderedByLikes(),
      child: postListAsyncValue.when(
        data: (postList) {
          return CustomScrollView(
            physics: blockScroll
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterBadges(
                    onTogglePosts: _togglePosts, // Pasar la función de toggle
                    showRandomPosts: _showRandomPosts, // Pasar el estado actual
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == postList.length) {
                      return _buildLoadingIndicator();
                    }
                    final post = postList[index];
                    return PostCard(post: post);
                  },
                  childCount: postList.length + 1,
                ),
              ),
            ],
          );
        },
        loading: () => Lottie.asset(
          'assets/Principal-Disco-Ball.json',
          controller: _animationController,
          onLoaded: (composition) {
            _animationController
              ..duration = composition.duration *
                  (2 / 3) // Ajustar la duración para 1.5x velocidad
              ..forward(
                  from: 0.05); // Saltar los primeros 20% de la animación
          },
          height: 400,
          width: 400,
          repeat: true,
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Lottie.asset(
              'assets/Secondary-Disco-Ball.json',
              onLoaded: (composition) {
                _animationController.duration = composition.duration *
                    (4 / 5); // Ajustar la duración para 1.5x velocidad
              },
              height: 75,
              width: 75,
            ),
          )
        : const SizedBox.shrink();
  }
}
