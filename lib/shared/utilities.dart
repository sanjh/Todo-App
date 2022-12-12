import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/colors.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

const size = 8.0;
RichText getTaskDetailTItle(BuildContext context, String text) {
  return RichText(
    text: TextSpan(
      style: Theme.of(context).textTheme.headline1,
      children: <TextSpan>[
        // TextSpan(
        //   text: l10n.find,
        // ),
        TextSpan(
          text: '$text',
          style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Appcolors.kGreyColor900,
              ),
        ),
      ],
    ),
  );
}
