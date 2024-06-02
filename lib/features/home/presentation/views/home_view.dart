import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/block_scroll.dart';
import 'package:crowd_snap/features/home/presentation/provider/post_state_notifier.dart';
import 'package:crowd_snap/features/home/presentation/widgets/filter_button.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late final AnimationController _animationController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    setState(() {
      _isLoading = true;
    });
    await ref.read(postListProvider.notifier).loadMorePosts();
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
    final postListAsyncValue = ref.watch(postListProvider);
    final blockScroll = ref.watch(blockScrollProvider);

    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: GestureDetector(
                  onTap: () {
                    HapticFeedback.vibrate();
                    ref.read(postListProvider.notifier).refreshPosts();
                  },
                  child: Image.asset(
                    'assets/icons/crowd_snap_logo.png',
                    height: 165,
                    width: 85,
                    fit: BoxFit.cover,
                  ),
                ),
                actions: const [
                  FilterButton(),
                ],
                bottom: TabBar(
                  enableFeedback: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onTap: (value) {
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
              _buildListView(postListAsyncValue, blockScroll),
              _buildListView(postListAsyncValue,
                  blockScroll), // Puedes cambiar esto para mostrar diferentes listados
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
      AsyncValue<List<PostModel>> postListAsyncValue, bool blockScroll) {
    return RefreshIndicator(
      onRefresh: () => ref.read(postListProvider.notifier).refreshPosts(),
      child: postListAsyncValue.when(
        data: (postList) {
          return CustomScrollView(
            physics: blockScroll
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            slivers: [
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
