import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRowClick;
  final Widget? trailing;
  final Widget? leading;
  final bool divider;

  const SettingRow(
      {Key? key,
      required this.title,
      this.description,
      this.onRowClick,
      this.trailing,
      this.leading,
      this.divider = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkResponse(
      onTap: onRowClick,
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (leading != null) Flexible(child: leading!),
                Column(children: [
                  Text(title, style: theme.textTheme.bodyText1),
                  if (description != null)
                    Text(description!, style: theme.textTheme.bodyText2)
                ]),
                if (trailing != null) trailing!,
              ],
            ),
            if (divider) const Divider()
          ],
        ),
      ),
    );
  }
}
