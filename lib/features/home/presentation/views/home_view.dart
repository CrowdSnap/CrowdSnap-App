import 'package:crowd_snap/features/home/presentation/provider/post_state_notifier.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(postListProvider.notifier).refreshPosts(),
        child: postListAsyncValue.when(
          data: (postList) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  title: GestureDetector(
                    onTap: _scrollToTop,
                    child: const Text('Home'),
                  ),
                  pinned: false,
                  floating: true,
                  snap: true,
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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }
}
