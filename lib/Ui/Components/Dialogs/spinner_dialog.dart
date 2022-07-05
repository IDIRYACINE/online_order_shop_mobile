import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

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
