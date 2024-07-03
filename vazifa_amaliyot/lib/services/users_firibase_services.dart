import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UsersFiribaseServices {
  final userCollection = FirebaseFirestore.instance.collection('users');
  final _productsImageStorage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* userCollection.snapshots();
  }

  Future<void> addUser(String name, File imageFile) async {
    final imageReference = _productsImageStorage
        .ref()
        .child("users")
        .child("images")
        .child("$name.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await userCollection.add({
        "name": name,
        "imageUrl": imageUrl,
      });
    });
  }

  Future<void> editUser(String id, String name, File imageFile) async {
    final imageReference = _productsImageStorage
        .ref()
        .child("users")
        .child("images")
        .child("$name.jpg");
    final uploadTask = imageReference.putFile(
      imageFile,
    );

    await uploadTask.whenComplete(() async {
      final imageUrl = await imageReference.getDownloadURL();
      await userCollection.doc(id).update({
        "name": name,
        "imageUrl": imageUrl,
      });
    });
  }

  Future<void> deleteUser(String id) async {
    userCollection.doc(id).delete();
  }
}
