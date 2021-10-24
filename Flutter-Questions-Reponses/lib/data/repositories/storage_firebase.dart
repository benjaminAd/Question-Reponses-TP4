// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebase {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Reference getImageFromStorage(String path) {
    return _storage.ref(path);
  }

  Future<void> uploadImage(String imageName,File image)async {
    await _storage.ref(imageName).putFile(image);
  }
}
