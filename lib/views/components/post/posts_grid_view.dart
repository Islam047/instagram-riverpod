import 'package:flutter/material.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';
import 'package:instagram_clone_riverpod/views/components/post/post_thumbnail_view.dart';
import 'package:instagram_clone_riverpod/views/post_details/post_details.dart';

class PostsGridView extends StatelessWidget {
  final Iterable<Post> posts;

  const PostsGridView({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
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
        });
  }
}
