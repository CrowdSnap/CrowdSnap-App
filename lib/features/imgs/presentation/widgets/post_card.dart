import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_widget.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/likes_sheet.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/comments_sheet.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/comment_create_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_add_like_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_remove_like_use_case.dart';
import 'package:crowd_snap/core/data/models/like_model.dart';

class PostCard extends ConsumerStatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfUserLikedPost();
      ref.read(likesNotifierProvider.notifier).setLikes(widget.post.likes);
      ref
          .read(commentsNotifierProvider.notifier)
          .setComments(widget.post.comments);
    });
    _likeCount = widget.post.likeCount;
    _commentCount = widget.post.commentCount;
  }

  Future<void> _checkIfUserLikedPost() async {
    final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
    final userId = getUserUseCase.userId;
    final isLiked = widget.post.likes.any((like) => like.userId == userId);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  void _toggleLike() async {
    final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
    final userId = getUserUseCase.userId;

    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _likeCount++;
          final newLike = LikeModel(userId: userId, createdAt: DateTime.now());
          ref.read(likesNotifierProvider.notifier).addLike(newLike);
          ref
              .read(postAddLikeUseCaseProvider)
              .execute(widget.post.mongoId!, userId);
        } else {
          _likeCount--;
          ref.read(likesNotifierProvider.notifier).removeLike(userId);
          ref
              .read(postRemoveLikeUseCaseProvider)
              .execute(widget.post.mongoId!, userId);
        }
      });
    }
  }

  void _addComment(String value) {
    final createCommentUseCase = ref.read(createCommentUseCaseProvider);
    createCommentUseCase.execute(value, widget.post.mongoId!);
    if (mounted) {
      setState(() {
        _commentCount++;
      });
    }
  }

  void _showLikedUserSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: DraggableScrollableSheet(
                initialChildSize: 0.2,
                maxChildSize: 0.7,
                minChildSize: 0.15,
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return LikesSheet(post: widget.post, scrollController: scrollController);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 0.7,
                minChildSize: 0.25,
                expand: false,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return CommentsSheet(
                    post: widget.post,
                    commentController: _commentController,
                    addComment: _addComment,
                    scrollController: scrollController,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PostWidget(
      post: widget.post,
      showLikedUserSheet: _showLikedUserSheet,
      showCommentSheet: _showCommentSheet,
      toggleLike: _toggleLike,
      isLiked: _isLiked,
      likeCount: _likeCount,
      commentCount: _commentCount,
    );
  }
}
