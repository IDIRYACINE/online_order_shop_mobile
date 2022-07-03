import 'package:flutter/material.dart';

typedef OnChangeFunction = void Function(String value);
typedef FormFieldValidator = String? Function(String? value);

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final bool obsecureText;
  final Widget? trailing;

  final OnChangeFunction onChange;
  final EdgeInsets? paddings;
  final Color? textFieldColor;
  final FormFieldValidator? validator;

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

class FaultTolerantImage extends StatelessWidget {
  final String src;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String backupImage;

  const FaultTolerantImage(
    this.src, {
    Key? key,
    this.height,
    this.width,
    this.fit,
    this.backupImage = 'assets/images/no-preview-available.png',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      src,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, object, stackTrace) {
        return Image.asset(
          backupImage,
          height: height,
          width: width,
          fit: fit,
        );
      },
    );
  }
}
