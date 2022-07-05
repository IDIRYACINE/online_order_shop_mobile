import 'package:flutter/material.dart';

typedef OnChangeFunction = void Function(String value);
typedef StringFormFieldValidator = String? Function(String? value);

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool obsecureText;
  final Widget? trailing;

  final OnChangeFunction onChange;
  final EdgeInsets? paddings;
  final Color? textFieldColor;
  final StringFormFieldValidator? validator;

  const CustomTextFormField({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.obsecureText = false,
    required this.onChange,
    this.paddings,
    this.textFieldColor,
    this.validator,
    this.trailing,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late IconData sufficxIcon;
  late IconData showTextIcon;
  late IconData hideTextIcon;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
        padding: widget.paddings ?? const EdgeInsets.all(8),
        child: TextFormField(
          style: theme.textTheme.bodyText1,
          decoration: InputDecoration(
              filled: true,
              fillColor: widget.textFieldColor ?? theme.scaffoldBackgroundColor,
              labelStyle: theme.textTheme.subtitle1,
              labelText: widget.label,
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyText1,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              suffixIcon: widget.trailing),
          initialValue: widget.initialValue,
          obscureText: widget.obsecureText,
          onChanged: widget.onChange,
          validator: widget.validator,
        ));
  }
}
