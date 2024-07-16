part of 'amazing_dialog.dart';

enum OverlayState { displayed, hidden}

class OverlayController {
  final StreamController<OverlayState> _overlayStateController =
  StreamController<OverlayState>.broadcast();


  void show() => _overlayStateController.add(OverlayState.displayed);

  void hide() => _overlayStateController.add(OverlayState.hidden);

  Stream<OverlayState> streamListener() => _overlayStateController.stream;
}
