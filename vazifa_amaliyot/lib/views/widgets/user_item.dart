
import 'package:dars_9_a/controllers/user_controller.dart';
import 'package:dars_9_a/models/user.dart';
import 'package:dars_9_a/views/widgets/edit_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserItem extends StatelessWidget {
  User user;
  UserItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return Column(
      children: [
        ListTile(
          leading: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.hardEdge,
            width: 100,
            child: Image.network(
              user.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            user.name,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return EditUser(
                        user: user,
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () {
                  userController.deleteUser(user.id);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
