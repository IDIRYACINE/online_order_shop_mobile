import 'dart:io';

import 'package:googleapis/drive/v3.dart';
import 'package:http/io_client.dart';
import 'package:online_order_shop_mobile/Application/ImagePicker/drive_file.dart'
    as my_app;

class ImagePicker {
  late DriveApi _driveApi;

  late FileList _rootFiles;

  late FileList _currentFolder;

  int? selectedFileIndex;

  ImagePicker(HttpClient authClient) {
    _driveApi = DriveApi(IOClient(authClient));
  }

  Future<void> exploreFolder(String folderId) async {
    _rootFiles = await _driveApi.files.list(
      spaces: 'drive',
      q: "$folderId in parents",
    );
  }

  void selectFile(int index) {
    selectedFileIndex = index;
  }

  void unSelectFile(int index) {
    selectedFileIndex = null;
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
        q: "mimeType = '' and name = '$folderName'",
        $fields: "files(id, name)",
      );

      final files = found.files;
      if (files == null) {
        return null;
      }

      if (files.isNotEmpty) {
        return files.first.id;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
