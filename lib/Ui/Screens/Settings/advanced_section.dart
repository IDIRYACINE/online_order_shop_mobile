import 'package:flutter/cupertino.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/setting_row.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class AdvancedSection extends StatelessWidget {
  const AdvancedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Flexible(
            child: SettingRow(title: synchroniseDatabaseTitle, divider: true))
      ],
    );
  }
}
