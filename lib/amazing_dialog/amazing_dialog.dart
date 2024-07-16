import 'dart:async';

import 'package:flutter/widgets.dart';

part 'models.dart';

typedef BuilderFactory<TT> = Widget Function(TT animations);
typedef OnDialogOpened<TT> = TT Function(TickerProvider vsync);
typedef OnDialogClosed<TT> = Future<void> Function(TT animations);

class AmazingOverlay<TT extends Animations> extends StatefulWidget {
  final OverlayController overlayController;
  final OverlayPortalController portalController;
  final Widget child;
  
  final BuilderFactory<TT> builder;
  final OnDialogOpened<TT> onDialogOpened;
  final OnDialogClosed<TT> onDialogClosed;

  AmazingOverlay(
      {super.key,
      required this.overlayController,
      required this.builder,
      required this.child,
      required this.onDialogClosed,
      required this.onDialogOpened})
      : portalController = OverlayPortalController();

  @override
  State<AmazingOverlay<TT>> createState() => _AmazingOverlayState<TT>();
}

class _AmazingOverlayState<TT extends Animations> extends State<AmazingOverlay<TT>> {
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
      overlayChildBuilder: (context) => AmazingOverlayWidget<TT>(
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

class AmazingOverlayWidget<TT extends Animations> extends StatefulWidget {
  final OverlayController overlayController;
  final OverlayPortalController portalController;
  
  final BuilderFactory<TT> builder;
  final OnDialogOpened<TT> onDialogOpened;
  final OnDialogClosed<TT> onDialogClosed;

  const AmazingOverlayWidget(
      {super.key,
      required this.overlayController,
      required this.portalController,
      required this.builder,
      required this.onDialogOpened,
      required this.onDialogClosed});

  @override
  State<AmazingOverlayWidget<TT>> createState() => _AmazingOverlayWidgetState<TT>();
}

class _AmazingOverlayWidgetState<TT extends Animations> extends State<AmazingOverlayWidget<TT>>
    with TickerProviderStateMixin {
  // late AnimationController animationController;
  // late Animation animation;
  late TT animations;
  late StreamSubscription<OverlayState> stream;

  Future onClosingDialog() async {}

  @override
  void initState() {
    /// init animation for opened dialog
    animations = widget.onDialogOpened(this);


    /// init animation for closing dialog
    stream =
        widget.overlayController.streamListener().listen((overlayState) async {
      if (overlayState == OverlayState.hidden) {
        await widget.onDialogClosed( animations );
        animations.stopAll();
        animations.disposeAll();
        stream.cancel();
        widget.portalController.hide();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(animations);
  }
}
