import 'package:crowd_snap/core/data/models/comment_model.dart';
import 'package:crowd_snap/core/data/models/like_model.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/core/domain/use_cases/shared_preferences/get_user_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/comment_create_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/comment_delete_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_add_like_use_case.dart';
import 'package:crowd_snap/features/imgs/domain/use_case/post_remove_like_use_case.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/comments_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/likes_provider.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/comments_sheet.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/likes_sheet.dart';
import 'package:crowd_snap/features/imgs/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  String _currentUserId = '';
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _checkIfUserLikedPost();
        _getUserId().then((value) {
          if (mounted) {
            setState(() {
              _currentUserId = value;
              _isOwner = _currentUserId == widget.post.userId;
            });
          }
        });
      }
    });
    _likeCount = widget.post.likeCount;
    _commentCount = widget.post.commentCount;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<String> _getUserId() async {
    final getUserUseCase = await ref.read(getUserUseCaseProvider).execute();
    return getUserUseCase.userId;
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
    final postId = widget.post.mongoId!;

    if (mounted) {
      setState(() {
        _isLiked = !_isLiked;
        if (_isLiked) {
          _likeCount++;
          final newLike = LikeModel(userId: userId, createdAt: DateTime.now());
          ref.read(likesNotifierProvider(postId).notifier).addLike(newLike);
          ref.read(postAddLikeUseCaseProvider).execute(postId, userId);
        } else {
          _likeCount--;
          ref.read(likesNotifierProvider(postId).notifier).removeLike(userId);
          ref.read(postRemoveLikeUseCaseProvider).execute(postId, userId);
        }
      });
    }
  }

  void _addComment(String value) {
    final createCommentUseCase =
        ref.read(createCommentUseCaseProvider(widget.post.mongoId!));
    createCommentUseCase.execute(value, widget.post.mongoId!);
    if (mounted) {
      setState(() {
        _commentCount++;
      });
    }
  }

  void _deleteComment(String commentId) {
    final deleteCommentUseCase =
        ref.read(deleteCommentUseCaseProvider(widget.post.mongoId!));
    deleteCommentUseCase.execute(commentId, widget.post.mongoId!);
    if (mounted) {
      setState(() {
        _commentCount--;
      });
    }
  }

  void _showPopupMenuComment(
      BuildContext context, CommentModel comment, String commentUsername) {
    final isOwner = _currentUserId == commentUsername ||
        _currentUserId == widget.post.userName;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + button.size.width,
        offset.dy,
        overlay.size.width - (offset.dx + button.size.width),
        overlay.size.height - offset.dy,
      ),
      color: Theme.of(context).colorScheme.surfaceBright,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      items: [
        if (isOwner)
          const PopupMenuItem(
            value: 'delete',
            child: Center(child: Text('Eliminar', textAlign: TextAlign.center)),
          ),
        const PopupMenuItem(
          value: 'report',
          child: Center(child: Text('Reportar', textAlign: TextAlign.center)),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        _deleteComment(comment.commentId);
      } else if (value == 'report') {
        // Lógica para reportar el comentario
      }
    });
  }

  void _showLikedUserSheet() {
    final postId = widget.post.mongoId!;
    final likesNotifier = ref.read(likesNotifierProvider(postId).notifier);
    final likesValue = ref.watch(likesNotifierProvider(postId));

    // Solo actualizar el estado si es la primera vez que se carga
    if (likesNotifier.isFirstLoad) {
      if (likesValue.isNotEmpty) {
        List<LikeModel> likes = likesValue;
        likes.addAll(widget.post.likes);
        likesNotifier.setLikes(likes);
      } else {
        likesNotifier.setLikes(widget.post.likes);
      }
      likesNotifier.markAsLoaded();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.2,
              maxChildSize: 0.7,
              minChildSize: 0.15,
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return LikesSheet(
                  post: widget.post,
                  scrollController: scrollController,
                  getElapsedTime: _getElapsedTime,
                );
              },
            );
          },
        );
      },
    );
  }

  void _showCommentSheet() {
    final postId = widget.post.mongoId!;
    final commentsNotifier =
        ref.read(commentsNotifierProvider(postId).notifier);

    if (commentsNotifier.isFirstLoad) {
      commentsNotifier.setComments(widget.post.comments);
      commentsNotifier.markAsLoaded();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
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
                  showPopupMenu: _showPopupMenuComment,
                  getElapsedTime: _getElapsedTime,
                  scrollController: scrollController,
                );
              },
            );
          },
        );
      },
    );
  }

  String _getElapsedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks semana${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${difference.inSeconds} segundo${difference.inSeconds > 1 ? 's' : ''}';
    }
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
      isOwner: _isOwner,
      getElapsedTime: _getElapsedTime,
    );
  }
}
