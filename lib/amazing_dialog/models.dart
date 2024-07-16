part of 'amazing_dialog.dart';

enum OverlayState { displayed, hidden, none }
enum StartAnimation{
  animation01,
  animation02
}
enum EndAnimation{animation01}

class OverlayController {
  final StreamController<OverlayState> _overlayStateController =
  StreamController<OverlayState>.broadcast();


  void show() => _overlayStateController.add(OverlayState.displayed);

  void hide() => _overlayStateController.add(OverlayState.hidden);

  Stream<OverlayState> streamListener() => _overlayStateController.stream;
}
