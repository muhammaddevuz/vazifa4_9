import 'package:dars_9/services/local_notifications_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!LocalNotificationsService.notificationsEnable)
            const Text("aaaaaaaaaaaaaa"),
          TextButton(
              onPressed: () {
                LocalNotificationsService.showNotification();
              },
              child: const Text("push")),
          TextButton(
              onPressed: () {
                LocalNotificationsService.showScheduledNotification();
              },
              child: const Text("push")),
          TextButton(onPressed: () {}, child: const Text("push")),
        ],
      )),
    ));
  }
}
