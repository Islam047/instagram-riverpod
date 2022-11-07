import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_thumbnail_view.dart';
import 'package:instagram_clone_riverpod/views/post_details/post_details.dart';



class PostsSliverGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsSliverGridView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
        delegate: SliverChildBuilderDelegate(
            childCount: posts.length,
                (context, index) {
              final post = posts.elementAt(index);
              return PostThumbnailView(
                post: post,
                onTapped: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailView(post: post),
                    ),
                  );
                },
              );
            }
        ));
  }
}
