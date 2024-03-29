import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

abstract class IOnlineServerAcess {
  Future<void> downloadFile({required String fileUrl, required File out});
  Future<dynamic> fetchData({required String dataUrl});
  Future<void> postData({required String dataUrl, required dynamic data});
  Future<void> updateData({required String dataUrl, required dynamic data});
  Stream<DatabaseEvent> getDataStream({required String dataUrl});
  Future<void> removeData({required String dataUrl});
  Future<String> uploadFile({required String fileUrl, required String name});
  Future<bool> uploadPendingFiles();
  Future<String> getUploadUrl({required String savePath});
  void addFileToUploadQueue({required String fileUrl, String? savePath});

  String serverImageNameFormater(String name);
}
