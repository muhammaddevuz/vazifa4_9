import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars_9/services/todo_firebase_services.dart';

class TodoFirebaseControllers {
  final todoFirebaseServices = TodoFirebaseServices();

  Stream<QuerySnapshot> get todosList async* {
    yield* todoFirebaseServices.getTodos();
  }

  void addTodo(String title, int priority, bool isDone, Timestamp date) {
    todoFirebaseServices.addTodo(title, priority, isDone, date);
  }

  void editTodo(
      String id, String title, int priority, bool isDone, DateTime date) {
    todoFirebaseServices.editTodo(id, title, priority, isDone, date);
  }

  void deleteTodo(String id) {
    todoFirebaseServices.deleteTodo(id);
  }

  void toggleIsDone(String id, bool isDone) {
    todoFirebaseServices.toggleIsDone(id, isDone);
  }
}
