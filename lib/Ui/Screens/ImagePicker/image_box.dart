import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'dart:developer' as dev;

class ImageBox extends StatefulWidget {
  final DriveFile driveFile;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<DriveFile> onSelect;
  final double borderWidth = 2;

  const ImageBox(
      {Key? key,
      required this.driveFile,
      required this.selectedColor,
      required this.unselectedColor,
      required this.onSelect})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  late Color color;

  void setUp() {
    if (widget.driveFile.isSelected().value) {
      color = widget.selectedColor;
      return;
    }
    color = widget.unselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    setUp();

    return InkResponse(
      onTap: () {
        widget.onSelect(widget.driveFile);
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.driveFile.isSelected(),
        builder: (context, selected, child) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    color: selected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    width: widget.borderWidth),
              ),
              child: CustomNetworkImage(widget.driveFile.getUrl(),
                  fit: BoxFit.fill));
        },
      ),
    );
  }
}
