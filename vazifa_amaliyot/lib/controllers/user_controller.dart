import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_9_a/services/users_firibase_services.dart';
import 'package:flutter/material.dart';

class UserController with ChangeNotifier {
  final _usersFirebaseService = UsersFiribaseServices();

  Stream<QuerySnapshot> get list async* {
    yield* _usersFirebaseService.getUsers();
  }

  Future<void> addUser(String name, File imageFile) async {
    await _usersFirebaseService.addUser(name, imageFile);
  }

  Future<void> editUser(
      String id, String name, File imageFile) async {
    await _usersFirebaseService.editUser(id, name, imageFile);
  }

  Future<void> deleteUser(String id) async {
    await _usersFirebaseService.deleteUser(id);
  }
}
