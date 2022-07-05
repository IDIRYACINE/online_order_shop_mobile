import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Components/forms.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

typedef DoubleTextFieldAlertCallback = void Function(
    String firstValue, String secondValue);

class SizePriceAlertDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final FormFieldValidator? validator;
  final DoubleTextFieldAlertCallback onConfirm;
  final String initialPriceValue;
  final String initialSizeValue;

  const SizePriceAlertDialog(
      {Key? key,
      required this.formKey,
      this.validator,
      required this.onConfirm,
      this.initialPriceValue = "0",
      this.initialSizeValue = "Standard"})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceAlertDialogState();
}

class _SizePriceAlertDialogState extends State<SizePriceAlertDialog> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String size = widget.initialSizeValue;
    String price = widget.initialPriceValue;

    return AlertDialog(
      content: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Flexible(
              child: CustomTextFormField(
                label: sizeLabel,
                onChange: (value) {
                  size = value;
                },
                initialValue: size,
                validator: widget.validator,
              ),
            ),
            Flexible(
              child: CustomTextFormField(
                label: priceLabel,
                onChange: (value) {
                  price = value;
                },
                initialValue: price,
                validator: widget.validator,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(cancelLabel)),
                TextButton(
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        widget.onConfirm(size, price);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      confirmLabel,
                      style: theme.textTheme.overline,
                    )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
