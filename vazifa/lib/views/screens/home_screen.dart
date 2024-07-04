import 'package:dars_9/controllers/todo_firebase_controllers.dart';
import 'package:dars_9/models/todo.dart';
import 'package:dars_9/views/widgets/add_todo_modal_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todoFirebaseControllers = TodoFirebaseControllers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: todoFirebaseControllers.todosList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No Todos avaliable',
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...List.generate(snapshot.data.docs.length, (int index) {
                  Todo todo = Todo.fromJson(snapshot.data.docs[index]);
                  DateTime convertedDateTime = todo.date.toDate();
                  return ListTile(
                    title: Text(
                      todo.title,
                    ),
                    subtitle: Text(
                      convertedDateTime.toString(),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          todoFirebaseControllers.toggleIsDone(
                              todo.id, !todo.isDone);
                        },
                        icon: todo.isDone
                            ? Icon(Icons.check_box)
                            : Icon(Icons.check_box_outline_blank)),
                    leading: Text(todo.priority.toString(),
                        style: TextStyle(fontSize: 19)),
                  );
                })
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF8687E6),
          shape: const CircleBorder(),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return AddTodoModalSheet();
                });
          },
          child: const Icon(CupertinoIcons.add)),
    );
  }
}
