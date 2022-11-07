import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone_riverpod/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/rich_two_parts_text.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;

  const PostDisplayNameAndMessageView({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoModelProvider(post.userId));
    return userInfoModel.when(
        data: (userInfoModel) {
          return RichTwoPartsText(leftPart: userInfoModel.displayName, rightPart: post.message);
        },
        error: (error, stackTrace) {
          return const SmallErrorAnimationView();
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
