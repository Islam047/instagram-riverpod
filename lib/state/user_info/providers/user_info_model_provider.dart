import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_collection_name.dart';
import 'package:instagram_clone_riverpod/state/constants/firebase_field_name.dart';
import 'package:instagram_clone_riverpod/state/posts/typedefs/user_id.dart';
import 'package:instagram_clone_riverpod/state/user_info/models/user_info_model.dart';

final userInfoModelProvider = StreamProvider.family
    .autoDispose<UserInfoModel, UserId>((ref, UserId userId) {
  final controller = StreamController<UserInfoModel>();

  final subscription = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.users)
      .where(FirebaseFieldName.userId, isEqualTo: userId)
      .limit(1)
      .snapshots()
      .listen((snapshots) {
      final doc = snapshots.docs.first;
      final json = doc.data();
      final userInfoModel = UserInfoModel.fromJson(json, userId: userId);
      controller.sink.add(userInfoModel);
    },
  );

  ref.onDispose(() {
    controller.close();
    subscription.cancel();
  });
  return controller.stream;
});
