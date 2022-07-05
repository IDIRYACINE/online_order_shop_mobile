import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

typedef FormFieldValidator = String? Function(String? value);
typedef TextFieldAlertCallback = void Function(String value);

class TextFieldAlertDialog extends StatelessWidget {
  final String label;
  final GlobalKey<FormState> formKey;
  final String? initialValue;
  final FormFieldValidator? validator;
  final TextFieldAlertCallback onConfirm;

  const TextFieldAlertDialog(
      {Key? key,
      required this.label,
      required this.formKey,
      this.initialValue,
      this.validator,
      required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String temp = "";
    ThemeData theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        label,
        style: theme.textTheme.bodyText1,
      ),
      content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CustomTextFormField(
                    onChange: (value) {
                      temp = value;
                    },
                    initialValue: initialValue,
                    validator: validator,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(cancelLabel)),
                      TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              onConfirm(temp);
                            }
                          },
                          child: Text(
                            confirmLabel,
                            style: theme.textTheme.overline,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
