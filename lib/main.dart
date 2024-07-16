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
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: overlayController.show,
          child: AmazingOverlay<OneAnimation>(
            overlayController: overlayController,
            onDialogOpened: (TickerProvider vsync) {
              AnimationController animationController = AnimationController(
                  vsync: vsync, duration: const Duration(milliseconds: 500));
              Animation<double> animation = CurvedAnimation(
                      parent: animationController, curve: Curves.fastLinearToSlowEaseIn)
                  .drive(
                      Tween<double>(begin: 40.0, end: 0.0));
              animationController.forward();
              return OneAnimation(animationController, animation);
            },
            onDialogClosed: (OneAnimation animations) async {
              animations.animationController.stop(canceled: true);
              await animations.animationController.reverse();
            },
            builder: (OneAnimation animations) {
              return Center(
                child: AnimatedBuilder(
                  animation: animations.animation,
                  builder: (context, _) {
                    return Container(
                      transform: Matrix4.translationValues(0, animations.animation.value as double, 0),
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
                    );
                  }
                ),
              );
            },
            child: const Text("Click Me"),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
