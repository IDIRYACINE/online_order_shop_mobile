import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
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

    return AlertDialog(
      title: Text(label),
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
                      DefaultButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              onConfirm(temp);
                            }
                          },
                          text: confirmLabel),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ColoredBox(
          color: theme.colorScheme.surface,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(message, style: theme.textTheme.bodyText2),
          ]),
        ),
      ),
    );
  }
}
