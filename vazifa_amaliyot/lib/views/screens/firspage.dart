import 'package:dars_9_a/controllers/user_controller.dart';
import 'package:dars_9_a/models/user.dart';
import 'package:dars_9_a/views/widgets/add_user.dart';
import 'package:dars_9_a/views/widgets/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Firspage extends StatefulWidget {
  const Firspage({super.key});

  @override
  State<Firspage> createState() => _FirspageState();
}

class _FirspageState extends State<Firspage> {
  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AddUser();
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: userController.list,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final users = snapshot.data!.docs;

                  if (users.isEmpty) {
                    return const Center(
                      child: Text("Userlar yo'q"),
                    );
                  }
                  print("-----------------------");
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      User user = User.fromJson(users[index]);
                      return UserItem(user: user);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
