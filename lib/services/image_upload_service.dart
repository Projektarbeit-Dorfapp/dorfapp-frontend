import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadService  {
  Future uploadFile(File image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(new DateTime.now().millisecondsSinceEpoch.toString() + image.path.split("/")?.last);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }
}