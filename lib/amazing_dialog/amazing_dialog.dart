import 'dart:async';

import 'package:flutter/widgets.dart';

part 'models.dart';

class AmazingOverlay extends StatefulWidget {
  final OverlayController overlayController;
  final OverlayPortalController portalController;
  final Widget child;
  final Widget Function(AnimationController animationController,Animation animation) builder;

  final (AnimationController, Animation) Function(TickerProvider vsync) onDialogOpened;

  final Future<void> Function(AnimationController animationController,Animation animation) onDialogClosed;

  AmazingOverlay(
      {super.key,
      required this.overlayController,
      required this.builder,
      required this.child,
      required this.onDialogClosed,
      required this.onDialogOpened})
      : portalController = OverlayPortalController();

  @override
  State<AmazingOverlay> createState() => _AmazingOverlayState();
}

class _AmazingOverlayState extends State<AmazingOverlay> {
  late StreamSubscription<OverlayState> _stream;

  @override
  void initState() {
    _stream = widget.overlayController.streamListener().listen((overlayState) {
      if (overlayState == OverlayState.displayed) {
        widget.portalController.toggle();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: widget.portalController,
      overlayChildBuilder: (context) => AmazingOverlayWidget(
        overlayController: widget.overlayController,
        portalController: widget.portalController,
        builder: widget.builder,
        onDialogClosed: widget.onDialogClosed,
        onDialogOpened: widget.onDialogOpened,
      ),
      child: widget.child,
    );
  }
}

class AmazingOverlayWidget extends StatefulWidget {
  final OverlayController overlayController;
  final OverlayPortalController portalController;
  final Widget Function(AnimationController animationController,Animation animation) builder;

  final (AnimationController, Animation) Function( TickerProvider vsync) onDialogOpened;

  final Future<void> Function(AnimationController animationController,Animation animation) onDialogClosed;

  const AmazingOverlayWidget(
      {super.key,
      required this.overlayController,
      required this.portalController,
      required this.builder,
      required this.onDialogOpened,
      required this.onDialogClosed});

  @override
  State<AmazingOverlayWidget> createState() => _AmazingOverlayWidgetState();
}

class _AmazingOverlayWidgetState extends State<AmazingOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late StreamSubscription<OverlayState> stream;

  Future onClosingDialog() async {}

  @override
  void initState() {
    /// init animation for opened dialog
    var result = widget.onDialogOpened(this);
    animationController = result.$1;
    animation = result.$2;

    /// init animation for closing dialog
    stream =
        widget.overlayController.streamListener().listen((overlayState) async {
      if (overlayState == OverlayState.hidden) {
        await widget.onDialogClosed( animationController, animation);
        animationController.stop(canceled: true);
        animationController.dispose();
        stream.cancel();
        widget.portalController.hide();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(animationController, animation);
  }
}
