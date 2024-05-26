import 'package:crowd_snap/features/imgs/domain/use_case/post_delete_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:crowd_snap/core/data/models/post_model.dart';
import 'package:crowd_snap/features/home/presentation/provider/block_scroll.dart';
import 'package:crowd_snap/features/imgs/presentation/notifier/post_povider.dart';
import 'package:flutter/services.dart';

class PostWidget extends ConsumerStatefulWidget {
  final PostModel post;
  final Function() showLikedUserSheet;
  final Function() showCommentSheet;
  final Function() toggleLike;
  final bool isLiked;
  final int likeCount;
  final int commentCount;
  final bool isOwner;
  final Function(DateTime) getElapsedTime;

  const PostWidget({
    super.key,
    required this.post,
    required this.showLikedUserSheet,
    required this.showCommentSheet,
    required this.toggleLike,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.isOwner,
    required this.getElapsedTime,
  });

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends ConsumerState<PostWidget> {
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    final blockScroll = ref.watch(blockScrollProvider.notifier);
    final postNotifier =
        ref.watch(postNotifierProvider(widget.post.mongoId!).notifier);
    final isDeleted = postNotifier.isDeleted;
    final isLongPressed = postNotifier.isLongPressed;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 4.0),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl: widget.post.userAvatarUrl,
                    placeholder: (context, url) => ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: BlurHash(
                          hash: widget.post.blurHashAvatar,
                          imageFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipOval(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: BlurHash(
                          hash: widget.post.blurHashAvatar,
                          imageFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      backgroundImage: imageProvider,
                    ),
                    fadeInDuration: const Duration(milliseconds: 400),
                    fadeOutDuration: const Duration(milliseconds: 400),
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  widget.post.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Subido hace ${widget.getElapsedTime(widget.post.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 4.0),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              const maxHeight = 650.0;
              const minHeight = 200.0;
              final height = (maxWidth / widget.post.aspectRatio)
                  .clamp(minHeight, maxHeight);

              return Stack(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      postNotifier.markAsLongPressed();
                      HapticFeedback.lightImpact();
                      setState(() {
                        _isLongPressed = true;
                      });
                    },
                    onDoubleTap: widget.toggleLike,
                    child: AnimatedPadding(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                          horizontal: _isLongPressed ? 0 : 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          height: _isLongPressed ? height * 1.05 : height,
                          width: _isLongPressed ? maxWidth * 1.2 : maxWidth,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: height,
                                width: maxWidth,
                                child: isDeleted
                                    ? const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              'Imagen eliminada',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : AnimatedScale(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        scale: _isLongPressed ? 1.3 : 1.0,
                                        child: PinchZoomReleaseUnzoomWidget(
                                          twoFingersOn: () => setState(() =>
                                              blockScroll.setBlockScroll(true)),
                                          twoFingersOff: () => setState(() =>
                                              blockScroll
                                                  .setBlockScroll(false)),
                                          child: ColorFiltered(
                                            colorFilter: _isLongPressed
                                                ? ColorFilter.mode(
                                                    Colors.black
                                                        .withOpacity(0.5),
                                                    BlendMode.darken)
                                                : const ColorFilter.mode(
                                                    Colors.transparent,
                                                    BlendMode.dst),
                                            child: OctoImage(
                                              image: CachedNetworkImageProvider(
                                                  widget.post.imageUrl),
                                              placeholderBuilder: (context) =>
                                                  SizedBox.expand(
                                                child: Image(
                                                  image: BlurHashImage(widget
                                                      .post.blurHashImage),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.error),
                                              fit: BoxFit.cover,
                                              fadeInDuration: const Duration(
                                                  milliseconds: 400),
                                              fadeOutDuration: const Duration(
                                                  milliseconds: 400),
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                bottom: _isLongPressed ? height / 2 - 30 : 8.0,
                                curve: Curves.easeInOut,
                                left: 0.0,
                                right: 0.0,
                                child: Center(
                                  child: IntrinsicWidth(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: height < 300
                                            ? Colors.transparent
                                            : Colors.grey[800]
                                                ?.withOpacity(0.85),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        boxShadow: height >= 300
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _isLongPressed
                                            ? [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: TapRegion(
                                                    onTapOutside: (event) {
                                                      if (isLongPressed) {
                                                        postNotifier
                                                            .resetLongPress();
                                                        HapticFeedback
                                                            .lightImpact();
                                                        setState(() {
                                                          _isLongPressed =
                                                              false;
                                                        });
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        if (widget
                                                            .isOwner) // Verifica si el usuario es el propietario
                                                          GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Eliminar Publicación'),
                                                                    content:
                                                                        const Text(
                                                                            '¿Estás seguro de que quieres eliminar esta publicación?'),
                                                                    actions: [
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Cancelar'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Eliminar'),
                                                                        onPressed:
                                                                            () {
                                                                          ref.read(deletePostUseCaseProvider).execute(
                                                                              widget.post.mongoId!,
                                                                              widget.post.imageUrl);
                                                                          ref
                                                                              .read(postNotifierProvider(widget.post.mongoId!).notifier)
                                                                              .markAsDeleted();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                SizedBox(
                                                                    width: 8.0),
                                                                Text(
                                                                  'Eliminar',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        16.0),
                                                              ],
                                                            ),
                                                          ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            // Lógica para reportar el post
                                                          },
                                                          child: const Row(
                                                            children: [
                                                              Icon(
                                                                Icons.report,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              SizedBox(
                                                                  width: 8.0),
                                                              Text(
                                                                'Reportar',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            : [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: widget
                                                                .toggleLike,
                                                            child: Icon(
                                                              widget.isLiked
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              color: widget
                                                                      .isLiked
                                                                  ? Colors.red
                                                                  : null,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8.0),
                                                          GestureDetector(
                                                            onTap: widget
                                                                .showLikedUserSheet,
                                                            child: Text(
                                                              widget.likeCount ==
                                                                      1
                                                                  ? '${widget.likeCount} Like'
                                                                  : '${widget.likeCount} Likes',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          width: 16.0),
                                                      GestureDetector(
                                                        onTap: widget
                                                            .showCommentSheet,
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.comment),
                                                            const SizedBox(
                                                                width: 8.0),
                                                            Text(widget.commentCount ==
                                                                    1
                                                                ? '${widget.commentCount} Comentario'
                                                                : '${widget.commentCount} Comentarios'),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
