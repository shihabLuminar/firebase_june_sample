import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreenController with ChangeNotifier {
  String imgeUrl = "";
  static final studentCollection =
      FirebaseFirestore.instance.collection('students');

  static addData({required Map<String, dynamic> data}) {
    studentCollection.add(data);
  }

  static editData({required String id, required Map<String, dynamic> data}) {
    studentCollection.doc(id).update(data);
  }

  static Future<void> deleteData(String id) async {
    studentCollection.doc(id).delete();
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      log(pickedFile.path);
// upload to firebase storage
// Points to the root reference
      final storageRef = FirebaseStorage.instance.ref();
      // Points to "folder - june"
      Reference? folderRef = storageRef.child("june");

//creating a image file name
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final fileRef = folderRef.child("$fileName.jpg");
      //upload iamge to file reference
      await fileRef.putFile(File(pickedFile.path));

      // get download url
      var downloadUrl = await fileRef.getDownloadURL();
      log(downloadUrl.toString());
    }
  }
}
