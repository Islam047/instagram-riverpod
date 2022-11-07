import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_riverpod/state/posts/models/post.dart';

final allPostProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final subscription = FirebaseFirestore.instance.collection(
    FirebaseCollectionName.posts,).orderBy(
    FirebaseFieldName.createdAt, descending: true,)
      .snapshots().listen((snapshot) {
    final posts = snapshot.docs.map((docs) =>
        Post(postId: docs.id, json: docs.data()));
       controller.sink.add(posts);
  });

  ref.onDispose(() {
    controller.close();
    subscription.cancel();
  });


  return controller.stream;
});