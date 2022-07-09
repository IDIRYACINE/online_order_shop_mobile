import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/image_picker_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/spinner_dialog.dart';
import 'package:online_order_shop_mobile/Ui/Screens/ImagePicker/image_box.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class ImagePickerScreen extends StatefulWidget {
  final TypedCallback onConfirm;
  final int rowItemCount = 2;

  final double bodyPadding = 8.00;

  final rowItemSpacing = 4.00;

  const ImagePickerScreen({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  late ThemeData theme;

  late ImagePicker imagePicker;
  void setup() {
    theme = Theme.of(context);

    imagePicker = Provider.of<HelpersProvider>(context, listen: false)
        .settingsHelper
        .getImagePicker();

    imagePicker.setOnConfirm(widget.onConfirm);
  }

  @override
  Widget build(BuildContext context) {
    setup();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: theme.colorScheme.secondaryContainer,
                  ))),
          Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    imagePicker.confirmSelection();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.done,
                    color: theme.colorScheme.secondaryContainer,
                  ))),
        ]),
      ),
      body: Padding(
        padding: EdgeInsets.all(widget.bodyPadding),
        child: FutureBuilder(
            future: imagePicker.load(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (imagePicker.getFilesCount() != 0) {
                  return GridView.builder(
                      itemCount: imagePicker.getFilesCount(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: widget.rowItemSpacing,
                        mainAxisSpacing: widget.rowItemSpacing,
                        crossAxisCount: widget.rowItemCount,
                      ),
                      itemBuilder: (context, index) {
                        return ImageBox(
                          driveFile: imagePicker.getDriveFile(index),
                          selectedColor: theme.colorScheme.secondaryContainer,
                          unselectedColor: theme.colorScheme.onBackground,
                          onSelect: (DriveFile driveFile) {
                            imagePicker.selectFile(driveFile);
                          },
                        );
                      });
                }
                return const Center(child: Text(noImagesFound));
              }

              if (snapshot.hasError) {
                return Text(snapshot.stackTrace.toString());
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
