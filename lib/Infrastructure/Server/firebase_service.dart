import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as dev;
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
  Future<String> uploadFile(
      {required String fileUrl, required String name}) async {
    String url = "";
    try {
      File file = File(fileUrl);

      await _firebaseStorage.ref(name).putFile(file);
      url = await _firebaseStorage.ref(name).getDownloadURL();
    } on FirebaseException catch (e) {
      dev.log(e.message!);
    }
    return url;
  }

  @override
  void addFileToUploadQueue({required String fileUrl, String? savePath}) {
    _uploadQueue.add(fileUrl);
  }

  @override
  Future<bool> uploadPendingFiles() async {
    // TODO: Somehow give back feedback on progress

    return true;
  }

  @override
  Future<String> getUploadUrl({required String savePath}) async {
    String url = await _firebaseStorage.ref(savePath).getDownloadURL();
    return url;
  }

  @override
  String serverImageNameFormater(String name) {
    return "images/$name.png";
  }
}
