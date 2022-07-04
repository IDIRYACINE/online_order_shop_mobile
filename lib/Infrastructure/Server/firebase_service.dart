import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'ionline_data_service.dart';

class FireBaseServices implements IOnlineServerAcess {
  final DatabaseReference _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;
  final List<String> _uploadQueue = [];

  FireBaseServices(this._firebaseStorage, this._firebaseDatabase);

  @override
  Future<dynamic> fetchData({required String dataUrl}) async {
    dynamic data;
    data = await _firebaseDatabase
        .child(dataUrl)
        .get()
        .then((value) => value.value);

    return data;
  }

  @override
  Future<void> postData({required String dataUrl, required data}) async {
    _firebaseDatabase.child(dataUrl).set(data);
  }

  @override
  Stream<DatabaseEvent> getDataStream({required String dataUrl}) {
    return _firebaseDatabase.child(dataUrl).onValue;
  }

  @override
  Future<void> downloadFile(
      {required String fileUrl, required File out}) async {
    await _firebaseStorage.ref(fileUrl).writeToFile(out);
  }

  @override
  Future<void> updateData({required String dataUrl, required data}) async {
    _firebaseDatabase.child(dataUrl).update(data);
  }

  @override
  Future<void> removeData({required String dataUrl}) async {
    _firebaseDatabase.child(dataUrl).remove();
  }

  @override
  Future<bool> uploadFile({required String fileUrl, String? savePath}) async {
    File file = File(fileUrl);
    await _firebaseStorage.ref(fileUrl).putFile(file);
    return true;
  }

  @override
  void addFileToUploadQueue({required String fileUrl, String? savePath}) {
    _uploadQueue.add(fileUrl);
  }

  @override
  Future<bool> uploadPendingFiles() async {
    // TODO: Somehow give back feedback on progress

    for (String fileUrl in _uploadQueue) {
      uploadFile(fileUrl: fileUrl);
    }

    return true;
  }
}
