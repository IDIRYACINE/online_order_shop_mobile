import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Settings/settings_helper.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/confirmation_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Screens/Settings/setting_row.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final IProductsDatabase database = ServicesProvider().productDatabase;
  late CatalogueHelper catalogueHelper;

  Future<void> reboot() async {
    await database.reset();
    await catalogueHelper.reloadCategories();
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData theme = Theme.of(context);

    catalogueHelper = catalogueHelper =
        Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

    SettingsHelper settingsHelper =
        Provider.of<HelpersProvider>(context, listen: false).settingsHelper;

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
                        database.reset();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(messageResetDatabase),
                        ));
                      },
                      message: messagePermanantAction,
                    );
                  });
            },
          ),
          SettingRow(
            title: "connect to google",
            onRowClick: () {
              settingsHelper.googleSignIn();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(messageResetDatabase),
              ));
            },
          )
        ],
      ),
    );
  }
}
