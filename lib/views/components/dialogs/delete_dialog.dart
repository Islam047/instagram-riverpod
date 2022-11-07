import 'package:instagram_clone_riverpod/views/components/constants/strings.dart';
import 'package:instagram_clone_riverpod/views/components/dialogs/alert_dialog_model.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectElement,
  }) : super(
          title: "${Strings.delete} $titleOfObjectElement?",
          message:
              "${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectElement",
          buttons:const {Strings.cancel: false, Strings.delete: true},
        );
}
