import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart';

class DriveFile {
  final ValueNotifier<bool> _selected = ValueNotifier(false);

  final File _file;

  DriveFile(this._file);

  String getFileId() {
    return _file.name!;
  }

  String getName() {
    return _file.name!;
  }

  String getUrl() {
    return _file.thumbnailLink!;
  }

  void select() {
    _selected.value = true;
  }

  void unselect() {
    _selected.value = false;
  }

  ValueListenable<bool> isSelected() => _selected;
}
