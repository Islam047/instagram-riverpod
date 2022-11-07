import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone_riverpod/state/image_upload/notifies/image_upload_notifier.dart';
import 'package:instagram_clone_riverpod/state/image_upload/typedefs/is_loading.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>(
        (ref) => ImageUploadNotifier());
