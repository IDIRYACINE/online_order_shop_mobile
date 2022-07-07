import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';

class ImageBox extends StatefulWidget {
  final DriveFile driveFile;

  const ImageBox({Key? key, required this.driveFile}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CustomNetworkImage(widget.driveFile.getUrl()),
    );
  }
}
