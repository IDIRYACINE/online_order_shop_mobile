import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ColoredBox(
          color: theme.colorScheme.surface,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, style: theme.textTheme.bodyText2),
          ]),
        ),
      ),
    );
  }
}
