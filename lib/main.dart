import 'package:flutter/material.dart';
import 'package:test_overlay_widget/amazing_dialog/amazing_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.brown,
        primaryColorLight: Colors.white
      ),
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
          primaryColor: Colors.white,
          primaryColorLight: Colors.brown
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OverlayController overlayController = OverlayController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: overlayController.show,
          child: ConfirmDialog(
            overlayController: overlayController,
            titleText: 'Amazing Dialog',
            contentText: 'Welcome Back',
            confirmButtonText: 'Submit',
            cancelButtonText: 'Back',
            width: 250,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: const Text("Click Me"),
          ),
        ),
      ),
    );
  }
}
