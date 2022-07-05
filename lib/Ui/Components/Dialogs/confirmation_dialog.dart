import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String? title;
  final VoidCallback onConfirm;
  final String message;

  const ConfirmAlertDialog(
      {Key? key, this.title, required this.onConfirm, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget? buildDialogTitle() {
      if (title != null) {
        return Text(
          title!,
          style: theme.textTheme.bodyText1,
        );
      }
      return null;
    }

    return AlertDialog(
      title: buildDialogTitle(),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(message)),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(cancelLabel)),
                  TextButton(
                      onPressed: () {
                        onConfirm();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        confirmLabel,
                        style: theme.textTheme.overline,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
