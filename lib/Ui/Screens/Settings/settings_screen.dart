import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/advanced_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [AdvancedSection()],
    );
  }
}
