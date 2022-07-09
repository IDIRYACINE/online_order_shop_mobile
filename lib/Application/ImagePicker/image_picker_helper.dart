import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart';

import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart'
    as my_app;

import 'dart:developer' as dev;

import 'package:online_order_shop_mobile/Ui/Components/Dialogs/spinner_dialog.dart';

class ImagePicker {
  final DriveApi _driveApi;

  late ValueChanged<String> _onConfirm;

  String? uploadFolderId;

  static const String uploadFolderName = "Al-Manal";

  late FileList _currentFolder;

  my_app.DriveFile? selectedFile;

  ImagePicker(this._driveApi);

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
      //TODO:HARD CODED
      String? targetFolderId = await _getFolderId(uploadFolderName);

      if (targetFolderId != null) {
        _currentFolder = await _driveApi.files.list(
            spaces: 'drive',
            q: "'$targetFolderId' in parents and mimeType='image/png'",
            $fields: "files(thumbnailLink,name,id,webViewLink)");
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

  Future<void> uploadImages(List<PlatformFile> files) async {
    try {
      if (uploadFolderId == null) {
        uploadFolderId = await _getFolderId(uploadFolderName);

        if (uploadFolderId == null) {
          File uploadFolder = File();
          uploadFolder.name = uploadFolderName;

          uploadFolder.mimeType = "application/vnd.google-apps.folder";

          File result = await _driveApi.files.create(uploadFolder);
          uploadFolderId = result.id;

          _driveApi.permissions.create(
              Permission(type: "anyone", role: "reader"), uploadFolderId!);
        }
      }
      for (PlatformFile file in files) {
        //TODO : Fix upload

        File fileMetadata = File();
        fileMetadata.parents = [uploadFolderId!];
        fileMetadata.name = file.name;

// http://127.0.0.1:9102?uri=http://127.0.0.1:34199/Bmqi1TYMpXg=/

        int contentLength = await file.readStream!.length;

        Media mediaContent =
            Media(file.readStream!, contentLength, contentType: "image/jpeg");

        File result = await _driveApi.files
            .create(fileMetadata, uploadMedia: mediaContent);

        await _driveApi.permissions
            .create(Permission(type: "anyone", role: "reader"), result.id!);
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
