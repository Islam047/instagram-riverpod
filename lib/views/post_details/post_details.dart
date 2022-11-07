import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/enums/date_sorting.dart';
import 'package:instagram_clone_riverpod/state/comments/models/post_comments_request.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/delete_post_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/comment/compact_comment_column.dart';
import 'package:instagram_clone_riverpod/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone_riverpod/views/components/dialogs/delete_dialog.dart';
import 'package:instagram_clone_riverpod/views/components/like_button.dart';
import 'package:instagram_clone_riverpod/views/components/likes_count_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_date_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_display_name_and_message_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_image_or_video_view.dart';
import 'package:instagram_clone_riverpod/views/constants/strings.dart';
import 'package:instagram_clone_riverpod/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailView extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailView({super.key, required this.post});

  @override
  ConsumerState createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );
    // get the actual post with comments
    final postWithComments =
        ref.watch(specificPostWithCommentsProvider(request));

    // can we delete the post ?
    final canDeletePost =
        ref.watch(canCurrentUserDeletePostProvider(widget.post));

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        centerTitle: false,
        actions: [
          // share button
          postWithComments.when(data: (postWithComments) {
            return IconButton(
              onPressed: () {
                final url = postWithComments.post.fileUrl;
                Share.share(url, subject: Strings.checkOutThisPost);
              },
              icon: const Icon(Icons.share),
            );
          }, error: (error, stackTrace) {
            return const SmallErrorAnimationView();
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
          // delete button or no delete button if user cannot delete this post
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost =
                    await const DeleteDialog(titleOfObjectElement: Strings.post)
                        .present(context)
                        .then((shouldDelete) => shouldDelete ?? false);
                if (shouldDeletePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: postWithComments.when(data: (postWithComments) {
        final postId = postWithComments.post.postId;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // post detail (image itself)

              PostImageOrVideoView(post: postWithComments.post),
              // post detail (like and comment button)

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (postWithComments.post.allowsLikes)
                    LikeButton(postId: postId),
                  if (postWithComments.post.allowsComments)
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return PostCommentsView(postId: postId);
                        }));
                      },
                      icon: const Icon(Icons.mode_comment_outlined),
                    )
                ],
              ),
              // post detail (show divider if there is comment)
              PostDisplayNameAndMessageView(post: postWithComments.post),
              PostDateView(dateTime: postWithComments.post.createdAt),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.white70,
                ),
              ),
              CompactCommentColumn(comments: postWithComments.comments),
              // post detail (display like count)
              if (postWithComments.post.allowsLikes)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      LikesCountView(postId: postId),
                    ],
                  ),
                ),
               // add Spacing to the bottom
              const  SizedBox(height: 100),
            ],
          ),
        );
      }, error: (error, stackTrace) {
        return const ErrorAnimationView();
      }, loading: () {
        return const LoadingAnimationView();
      }),
    );
  }
}
