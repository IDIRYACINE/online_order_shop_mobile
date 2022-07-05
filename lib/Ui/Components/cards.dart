import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/dialogs.dart';

typedef FormFieldValidator = String? Function(String? value);
typedef FormFieldCallback = void Function(String value);

class InformationCard extends StatefulWidget {
  final String label;
  final String? initialValue;
  final Color? backgroundColor;
  final TextStyle? labelTextStyle;
  final TextStyle? valueTextStyle;
  final Widget? trailing;
  final Color? borderColor;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final FormFieldValidator? validator;
  final FormFieldCallback onChangeConfirm;

  const InformationCard(
      {Key? key,
      required this.label,
      this.initialValue,
      this.backgroundColor,
      this.labelTextStyle,
      this.valueTextStyle,
      this.trailing,
      this.borderColor,
      this.padding = const EdgeInsets.all(10),
      this.onPressed,
      this.validator,
      required this.onChangeConfirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InformationCardState();
}

class _InformationCardState extends State<InformationCard> {
  late VoidCallback alertDialogCallback;
  late ValueNotifier<String> value;

  Future<AlertDialog?> defaultAlertDialog(
      ValueNotifier<String> src, BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    void onConfirm(String value) {
      src.value = value;
      Navigator.of(context).pop();
    }

    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return TextFieldAlertDialog(
          label: widget.label,
          formKey: formKey,
          onConfirm: (value) {
            widget.onChangeConfirm(value);
            onConfirm(value);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    value = ValueNotifier(widget.initialValue ?? "");

    alertDialogCallback = widget.onPressed ??
        () {
          defaultAlertDialog(value, context);
        };

    return InkResponse(
      onTap: () {
        alertDialogCallback();
      },
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.cardColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
              color: widget.borderColor ?? Colors.grey[300]!, width: 2),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.label,
                    style: widget.labelTextStyle ?? theme.textTheme.subtitle1),
                ValueListenableBuilder<String>(
                    valueListenable: value,
                    builder: (buildContext, newValue, child) {
                      return Text(newValue,
                          style: widget.valueTextStyle ??
                              theme.textTheme.headline2);
                    })
              ],
            ),
            if (widget.trailing != null) widget.trailing!
          ],
        ),
      ),
    );
  }
}
