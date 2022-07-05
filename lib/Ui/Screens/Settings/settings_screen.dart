import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/confirmation_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/setting_row.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final IProductsDatabase database = ServicesProvider().productDatabase;

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SettingRow(
            title: synchroniseDatabaseTitle,
            onRowClick: () {
              showDialog<AlertDialog>(
                  context: context,
                  builder: (context) {
                    return ConfirmAlertDialog(
                      onConfirm: () {
                        database.upgradeDatabaseVersion();

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(updatedDatabaseLabel),
                        ));
                      },
                      message: messagePermanantAction,
                    );
                  });
            },
          ),
          SettingRow(
            title: resetDatabaseTitle,
            onRowClick: () {
              showDialog<AlertDialog>(
                  context: context,
                  builder: (context) {
                    return ConfirmAlertDialog(
                      onConfirm: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(reDownloadingDatabaseLabel),
                        ));
                        database.reset();
                      },
                      message: messagePermanantAction,
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
