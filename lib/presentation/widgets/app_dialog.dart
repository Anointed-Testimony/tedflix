import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/common/extensions/string_extensions.dart';
import 'package:tedflix_app/presentation/themes/theme_color.dart';

import 'button.dart';

class AppDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Widget image;
  final TextStyle? titleStyle;  // Add this line to accept a custom title style

  const AppDialog({
    required Key key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.image,
    this.titleStyle,  // Include the custom title style parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.vulcan,
      elevation: Sizes.dimen_32,
      insetPadding: EdgeInsets.all(Sizes.dimen_32.w.toDouble()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Sizes.dimen_8.w.toDouble()),
        ),
      ),
      child: Container(
        padding: EdgeInsets.only(
          top: Sizes.dimen_4.h.toDouble(),
          left: Sizes.dimen_16.w.toDouble(),
          right: Sizes.dimen_16.w.toDouble(),
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.vulcan,
              blurRadius: Sizes.dimen_16,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: titleStyle ?? Theme.of(context).textTheme.headlineSmall,  // Use the custom style or fallback
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.dimen_6.h.toDouble()),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (image != null) image,
            Button(
              key: Key('Button'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: "Okay",
            ),
          ],
        ),
      ),
    );
  }
}
