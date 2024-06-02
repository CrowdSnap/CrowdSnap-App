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
  final ScrollController _scrollControllerRandom = ScrollController();
  final ScrollController _scrollControllerTopLikes = ScrollController();
  bool _isLoading = false;
  late final AnimationController _animationController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollControllerRandom.addListener(_onScrollRandom);
    _scrollControllerTopLikes.addListener(_onScrollTopLikes);
    _animationController = AnimationController(vsync: this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollControllerRandom.dispose();
    _scrollControllerTopLikes.dispose();
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScrollTopLikes() {
    if (!_isLoading &&
        _scrollControllerTopLikes.position.pixels ==
            _scrollControllerTopLikes.position.maxScrollExtent) {
      _loadMoreTopLikesPosts();
    }
  }

  void _onScrollRandom() {
    if (!_isLoading &&
        _scrollControllerRandom.position.pixels ==
            _scrollControllerRandom.position.maxScrollExtent) {
      _loadMoreRandomPosts();
    }
  }

  Future<void> _loadMoreTopLikesPosts() async {
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(orderedByLikesPostListProvider.notifier)
        .loadMorePostsOrderedByLikes();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreRandomPosts() async {
    setState(() {
      _isLoading = true;
    });
    await ref.read(randomPostListProvider.notifier).loadMorePostsRandom();
    setState(() {
      _isLoading = false;
    });
  }

  void _scrollToTop() {
    _scrollControllerRandom.animateTo(
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

    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollControllerRandom,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: GestureDetector(
                  onTap: () {
                    HapticFeedback.vibrate();
                    ref
                        .read(randomPostListProvider.notifier)
                        .refreshPostsRandom();
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
                  ),],
                bottom: TabBar(
                  enableFeedback: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onTap: (value) {
                    HapticFeedback.vibrate();
                    _scrollToTop();
                  },
                  tabs: const [
                    Tab(text: "Random Posts"),
                    Tab(text: "Top Posts"),
                  ],
                ),
                pinned: true,
                floating: true,
                snap: true,
                centerTitle: true,
              ),
            ];
          },
          body: TabBarView(
            physics: blockScroll
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            children: [
              _buildListView(randomPostListAsyncValue, blockScroll),
              _buildListView(orderedByLikesPostListAsyncValue, blockScroll),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
      AsyncValue<List<PostModel>> postListAsyncValue, bool blockScroll) {
    return RefreshIndicator(
      onRefresh: () =>
          ref.read(randomPostListProvider.notifier).refreshPostsRandom(),
      child: postListAsyncValue.when(
        data: (postList) {
          return CustomScrollView(
            physics: blockScroll
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FilterBadges(),
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
        loading: () => Center(
          child: Lottie.asset(
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
