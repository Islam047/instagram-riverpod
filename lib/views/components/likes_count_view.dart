import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/likes/providers/post_likes_count_provider.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/post_id.dart';
import 'package:instagram_clone_riverpod/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;

  const LikesCountView({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
      data: (int likesCount) {
        final personOrPeople = likesCount == 1 ? Strings.person : Strings.person;
        final likesText = '$likesCount $personOrPeople ${Strings.likedThis}';
        return Text(likesText);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
}
