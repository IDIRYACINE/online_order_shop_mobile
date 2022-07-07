import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/io_client.dart';

import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart'
    as my_app;

import 'dart:developer' as dev;

import 'package:online_order_shop_mobile/Ui/Components/Dialogs/spinner_dialog.dart';

class ImagePicker {
  late DriveApi _driveApi;

  late ValueChanged<String> _onConfirm;

  late FileList _currentFolder;

  my_app.DriveFile? selectedFile;

  ImagePicker(IOClient authClient) {
    _driveApi = DriveApi(authClient);
  }

  Future<void> exploreFolder(String folderId) async {
    _currentFolder = await _driveApi.files.list(
      spaces: 'drive',
      q: "$folderId in parents",
    );
  }

  void selectFile(my_app.DriveFile driveFile) {
    if (selectedFile != null) {
      selectedFile!.unselect();
    }
    driveFile.select();
    selectedFile = driveFile;
  }

  void unSelectFile(my_app.DriveFile driveFile) {
    selectedFile = null;
    driveFile.unselect();
  }

  int getFilesCount() {
    return _currentFolder.files!.length;
  }

  my_app.DriveFile getDriveFile(int index) {
    return my_app.DriveFile(_currentFolder.files![index]);
  }

  Future<String?> _getFolderId(
    String folderName,
  ) async {
    try {
      final found = await _driveApi.files.list(
        q: "'root' in parents and name = '$folderName'",
        $fields: "files(id)",
      );

      final files = found.files;
      if (files == null) {
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }
    } catch (e) {
      dev.log(e.toString());
    }
    return null;
  }

  Future<bool> load() async {
    try {
      String? targetFolderId = await _getFolderId("Memoire");

      if (targetFolderId != null) {
        _currentFolder = await _driveApi.files.list(
            spaces: 'drive',
            q: "'$targetFolderId' in parents and mimeType='image/png'",
            $fields: "files(thumbnailLink,name,webViewLink)");
      }
    } catch (e) {
      dev.log(e.toString());
    }

    return true;
  }

  void confirmSelection() {
    if (selectedFile != null) {
      _onConfirm(selectedFile!.getUrl());
    }
  }

  void setOnConfirm(TypedCallback onConfirm) {
    _onConfirm = onConfirm;
  }
}
