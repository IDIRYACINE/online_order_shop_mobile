import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/setting_row.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          SettingRow(title: synchroniseDatabaseTitle),
          SettingRow(
            title: resetDatabaseTitle,
            divider: false,
          )
        ],
      ),
    );
  }
}
