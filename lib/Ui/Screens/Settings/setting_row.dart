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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leading != null) Expanded(child: leading!),
              Expanded(
                  child: Column(children: [
                Expanded(
                  child: Text(title, style: theme.textTheme.bodyText1),
                ),
                if (description != null)
                  Expanded(
                      child:
                          Text(description!, style: theme.textTheme.bodyText2))
              ])),
              if (trailing != null) Expanded(child: trailing!),
            ],
          ),
          if (divider) const Divider()
        ],
      ),
    );
  }
}
