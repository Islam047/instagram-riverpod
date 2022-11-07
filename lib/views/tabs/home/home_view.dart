import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/state/posts/providers/all_post_provider.dart';
import 'package:instagram_clone_riverpod/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone_riverpod/views/components/post/posts_grid_view.dart';
import 'package:instagram_clone_riverpod/views/constants/Strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.refresh(allPostProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(
        data: (posts) {
          if(posts.isEmpty){
            return const EmptyContentsWithTextAnimationView(text: Strings.noPostsAvailable);
          }
          else{
            return PostsGridView(posts: posts);
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
