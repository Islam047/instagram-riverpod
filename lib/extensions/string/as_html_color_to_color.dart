// convert 0x?????? or #?????? to Color
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone_riverpod/extensions/string/remove_all.dart';
// cfc9c2
extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}
