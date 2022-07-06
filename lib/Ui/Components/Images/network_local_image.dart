import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class NetworkLocalImage extends StatefulWidget {
  final String src;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String backupImage;
  final ValueListenable<bool> firstLoadWatcher;

  const NetworkLocalImage(
    this.src, {
    Key? key,
    this.height,
    this.width,
    this.fit,
    this.backupImage = 'assets/images/no-preview-available.png',
    required this.firstLoadWatcher,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetworkLocalImageState();
}

class _NetworkLocalImageState extends State<NetworkLocalImage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: widget.firstLoadWatcher,
        builder: (context, isFirstLoad, child) {
          if (isFirstLoad) {
            return Image.network(
              widget.src,
              height: widget.height,
              width: widget.width,
              fit: widget.fit,
              errorBuilder: (context, object, stackTrace) {
                return Image.asset(
                  widget.backupImage,
                  height: widget.height,
                  width: widget.width,
                  fit: widget.fit,
                );
              },
            );
          }
          return Image.file(
            File(widget.src),
            height: widget.height,
            width: widget.width,
            fit: widget.fit,
            errorBuilder: (context, object, stackTrace) {
              return Image.asset(
                widget.backupImage,
                height: widget.height,
                width: widget.width,
                fit: widget.fit,
              );
            },
          );
        });
  }
}
