import 'package:flutter/widgets.dart';

class CustomNetworkImage extends StatelessWidget {
  final String src;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String backupImage;

  const CustomNetworkImage(
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
