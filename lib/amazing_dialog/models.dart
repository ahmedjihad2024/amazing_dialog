part of 'amazing_dialog.dart';

enum OverlayState { displayed, hidden}

class OverlayController {
  final StreamController<OverlayState> _overlayStateController =
  StreamController<OverlayState>.broadcast();


  void show() => _overlayStateController.add(OverlayState.displayed);

  void hide() => _overlayStateController.add(OverlayState.hidden);

  Stream<OverlayState> streamListener() => _overlayStateController.stream;
}

abstract class Animations{
  late Animation animation;
  late AnimationController animationController;
  Animations(this.animationController, this.animation);
  void stopAll();
  void disposeAll();
}

class OneAnimation extends Animations{

  OneAnimation(super.animationController, super.animation);

  @override
  void disposeAll() => animationController.dispose();

  @override
  void stopAll() => animationController.stop(canceled: true);
}
