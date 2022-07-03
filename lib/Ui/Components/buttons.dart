import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Color? textColor;
  final Color? backgroundColor;
  final String text;
  final VoidCallback? onPressed;
  final ShapeBorder shape;
  final double? width;
  final double? height;

  const DefaultButton(
      {Key? key,
      this.textColor,
      this.backgroundColor,
      required this.text,
      this.onPressed,
      this.shape = const StadiumBorder(),
      this.width,
      this.height})
      : super(key: key);

  final double defaultHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SizedBox(
        width: width,
        height: height ?? defaultHeight,
        child: MaterialButton(
          color: backgroundColor ?? theme.primaryColor,
          shape: shape,
          child: Text(
            text,
            style: theme.textTheme.button,
          ),
          onPressed: onPressed ?? () {},
        ));
  }
}

typedef CounterCallback = void Function(int count);

class UnitButton extends StatefulWidget {
  final double borderRadius;
  final bool fillBackground;
  final int initialCount;
  final CounterCallback onCountChange;
  final Axis direction;
  final EdgeInsets iconsPadding;

  final MainAxisSize mainAxisSize;

  const UnitButton({
    Key? key,
    this.borderRadius = 12.0,
    this.fillBackground = false,
    this.initialCount = 1,
    required this.onCountChange,
    this.direction = Axis.horizontal,
    this.iconsPadding = const EdgeInsets.all(8.0),
    this.mainAxisSize = MainAxisSize.min,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UnitButtonState();
}

class _UnitButtonState extends State<UnitButton> {
  late ValueNotifier<int> _units;

  void _increameant(int step) {
    int temp = _units.value + step;
    if (temp > 0) {
      widget.onCountChange(temp);
      _units.value = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    late Color _backgroundColor;
    late Color _iconColor;
    late TextStyle _counterTextStyle;
    _units = ValueNotifier(widget.initialCount);

    if (widget.fillBackground) {
      _backgroundColor = theme.primaryColor;
      _counterTextStyle = theme.textTheme.button!;
      _iconColor = theme.colorScheme.surface;
    } else {
      _backgroundColor = theme.colorScheme.surface;
      _counterTextStyle = theme.textTheme.bodyText2!;
      _iconColor = theme.colorScheme.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius),
        ),
      ),
      child: Flex(
        mainAxisSize: widget.mainAxisSize,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        direction: widget.direction,
        verticalDirection: VerticalDirection.up,
        children: [
          InkResponse(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                _increameant(-1);
              },
              child: Padding(
                  padding: widget.iconsPadding,
                  child: Icon(
                    Icons.remove_circle_outlined,
                    color: _iconColor,
                  ))),
          ValueListenableBuilder(
              valueListenable: _units,
              builder: (context, value, child) {
                return Text(_units.value.toString(),
                    textAlign: TextAlign.center, style: _counterTextStyle);
              }),
          InkResponse(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _increameant(1);
            },
            child: Padding(
                padding: widget.iconsPadding,
                child: Icon(Icons.add_circle_rounded, color: _iconColor)),
          )
        ],
      ),
    );
  }
}

typedef ToggleCallback = void Function(bool value);

class ToggleButton extends StatefulWidget {
  final IconData showTextIcon;
  final IconData hideTextIcon;
  final ToggleCallback? toggleCallback;
  final bool isActive;
  const ToggleButton(
      {Key? key,
      this.showTextIcon = Icons.visibility,
      this.hideTextIcon = Icons.visibility_off,
      this.toggleCallback,
      this.isActive = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool isActive;

  @override
  Widget build(BuildContext context) {
    isActive = widget.isActive;

    return InkResponse(
        onTap: () {
          setState(() {
            isActive = !isActive;
          });
          if (widget.toggleCallback != null) {
            widget.toggleCallback!(isActive);
          }
        },
        child: Icon(isActive ? widget.hideTextIcon : widget.showTextIcon));
  }
}
