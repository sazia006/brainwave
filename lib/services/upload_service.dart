import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadService {
  Future<String> uploadAnswer(File file, String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
