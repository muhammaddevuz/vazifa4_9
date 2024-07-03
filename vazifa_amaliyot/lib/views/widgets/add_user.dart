import 'dart:io';
import 'package:dars_9_a/controllers/user_controller.dart';
import 'package:dars_9_a/utils/messages.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final nameController = TextEditingController();
  File? imageFile;

  void addCar() async {
    Messages.showLoadingDialog(context);
    await context.read<UserController>().addUser(
        nameController.text, imageFile!);

    if (context.mounted) {
      nameController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  void openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("User Qo'shish"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "User ismi",
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Rasm Qo'shish",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: openCamera,
                label: const Text("Kamera"),
                icon: const Icon(Icons.camera),
              ),
              TextButton.icon(
                onPressed: openGallery,
                label: const Text("Galleriya"),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          if (imageFile != null)
            SizedBox(
              height: 200,
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
              ),
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Bekor Qilish"),
        ),
        FilledButton(
          onPressed: addCar,
          child: const Text("Saqlash"),
        ),
      ],
    );
  }
}
