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

typedef TypedCallback = void Function(String value);

class SpinnerAlertDialog extends StatefulWidget {
  final List<String> data;
  final int initialSelection;
  final String? initialValue;
  final TypedCallback onConfirm;
  final VoidCallback? onCancel;

  const SpinnerAlertDialog(
      {Key? key,
      required this.data,
      this.initialSelection = 0,
      required this.onConfirm,
      this.onCancel,
      this.initialValue})
      : super(key: key);

  String getInitialItem() {
    return data[initialSelection];
  }

  @override
  State<StatefulWidget> createState() => _SpinnerAlertDialogState();
}

class _SpinnerAlertDialogState<T> extends State<SpinnerAlertDialog> {
  String? dropDownValue;

  void onItemSelected(String? value) {
    setState(() {
      dropDownValue = value!;
    });
  }

  void setup() {
    dropDownValue ??= widget.initialValue ?? "attendu";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    setup();

    return AlertDialog(
        content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: DropdownButton<String>(
                    value: dropDownValue,
                    isExpanded: true,
                    items: [
                      for (String element in widget.data)
                        DropdownMenuItem(
                            value: element, child: Text(element.toString()))
                    ],
                    onChanged: onItemSelected,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            cancelLabel,
                            style: TextStyle(fontSize: textSizeMeduim2),
                          )),
                      TextButton(
                          onPressed: () {
                            widget.onConfirm(dropDownValue!);
                            Navigator.pop(context);
                          },
                          child: Text(
                            confirmLabel,
                            style: TextStyle(
                                color: theme.colorScheme.secondaryVariant,
                                fontSize: textSizeMeduim2),
                          )),
                    ],
                  ),
                ),
              ],
            )));
  }
}

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
