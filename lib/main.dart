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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: overlayController.show,
          child: AmazingOverlay(
            overlayController: overlayController,
            startAnimation: StartAnimation.animation02,
            duration: (
              startDuration: const Duration(milliseconds: 500),
              endDuration: const Duration(milliseconds: 300)
            ),
            overlay: Container(
              width: 350,
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.deepOrange),
              child: TextButton(
                onPressed: overlayController.hide,
                child: const Text("Close Me"),
              ),
            ),
            child: const Text("Click Me"),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
