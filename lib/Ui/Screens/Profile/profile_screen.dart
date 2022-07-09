import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Authentication/authentication_helper.dart';
import 'package:online_order_shop_mobile/Application/Authentication/user_input_validator.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final double cardsPadding = 10.0;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  final UserInputValidtor userInputValidtor = UserInputValidtor();

  @override
  Widget build(BuildContext context) {
    AuthenticationHelper _authHelper =
        Provider.of<HelpersProvider>(context, listen: false).authHelper;

    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.surface,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.secondaryContainer,
                  ))),
          Text(profileTitle, style: theme.textTheme.headline2),
          Card(
            elevation: 4.0,
            color: theme.cardColor,
            child: IconButton(
                onPressed: () {
                  _authHelper.saveProfile();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.done,
                  color: theme.colorScheme.secondaryContainer,
                )),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(widget.cardsPadding),
                child: InformationCard(
                  label: emailLabel,
                  initialValue: _authHelper.getEmail(),
                  onChangeConfirm: _authHelper.updateEmail,
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(widget.cardsPadding),
                  child: InformationCard(
                    label: addressLabel,
                    initialValue: _authHelper.getAddress(),
                    onPressed: () {
                      _authHelper.setDeliveryAddresse(context);
                    },
                    onChangeConfirm: (value) {},
                  )),
              Padding(
                  padding: EdgeInsets.all(widget.cardsPadding),
                  child: DefaultButton(
                    text: logoutLabel,
                    width: double.infinity,
                    onPressed: () {
                      _authHelper.logout();
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
