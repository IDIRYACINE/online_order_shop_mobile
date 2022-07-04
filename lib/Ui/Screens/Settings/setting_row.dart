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
      this.divider = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return InkResponse(
      onTap: onRowClick,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) Flexible(child: leading!),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: theme.textTheme.headline2),
                      if (description != null)
                        Text(description!, style: theme.textTheme.bodyText1)
                    ]),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
