import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

typedef FormFieldValidator = String? Function(String? value);
typedef TextFieldAlertCallback = void Function(
    String firstValue, String secondValue);

class TextFieldAlertDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String? initialPrice;
  final String? initialSize;

  final FormFieldValidator? validator;
  final TextFieldAlertCallback onConfirm;

  const TextFieldAlertDialog(
      {Key? key,
      required this.formKey,
      this.validator,
      required this.onConfirm,
      this.initialPrice,
      this.initialSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String price = "";
    String size = "";

    return AlertDialog(
      content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: CustomTextFormField(
                    label: priceLabel,
                    onChange: (value) {
                      price = value;
                    },
                    initialValue: initialPrice,
                    validator: validator,
                  ),
                ),
                Flexible(
                  child: CustomTextFormField(
                    label: sizeLabel,
                    onChange: (value) {
                      size = value;
                    },
                    initialValue: initialSize,
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
                              onConfirm(price, size);
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
