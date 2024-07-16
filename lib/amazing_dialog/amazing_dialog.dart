import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

part 'models.dart';

part 'animation_dialog.dart';

class AmazingOverlay extends StatefulWidget {
  final OverlayController _overlayController;
  final OverlayPortalController _portalController;
  final Widget _child;
  final StartAnimation _startAnimation;
  final EndAnimation _endAnimation;
  final Widget _overlay;
  final ({Duration startDuration, Duration endDuration})? _duration;

  AmazingOverlay(
      {super.key,
      required OverlayController overlayController,
      required Widget child,
      required Widget overlay,
      StartAnimation startAnimation = StartAnimation.animation01,
      EndAnimation endAnimation = EndAnimation.animation01,
      ({Duration startDuration, Duration endDuration})? duration})
      : _overlayController = overlayController,
        _portalController = OverlayPortalController(),
        _child = child,
        _overlay = overlay,
        _startAnimation = startAnimation,
        _endAnimation = endAnimation,
        _duration = duration;

  @override
  State<AmazingOverlay> createState() => _AmazingOverlayState();
}

class _AmazingOverlayState extends State<AmazingOverlay> {
  late StreamSubscription<OverlayState> _stream;

  @override
  void initState() {
    _stream = widget._overlayController.streamListener().listen((overlayState) {
      if (overlayState == OverlayState.displayed)
        widget._portalController.toggle();
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
      controller: widget._portalController,
      overlayChildBuilder: (context) => AmazingOverlayWidget(
        overlay: widget._overlay,
        overlayController: widget._overlayController,
        portalController: widget._portalController,
        startAnimation: widget._startAnimation,
        endAnimation: widget._endAnimation,
        duration: widget._duration,
      ),
      child: widget._child,
    );
  }
}

class AmazingOverlayWidget extends StatefulWidget {
  final Widget _overlay;
  final OverlayPortalController _portalController;
  final OverlayController _overlayController;
  final StartAnimation _startAnimation;
  final EndAnimation _endAnimation;
  final ({Duration startDuration, Duration endDuration})? _duration;

  const AmazingOverlayWidget(
      {super.key,
      required Widget overlay,
      required OverlayController overlayController,
      required OverlayPortalController portalController,
      StartAnimation startAnimation = StartAnimation.animation01,
      EndAnimation endAnimation = EndAnimation.animation01,
        ({Duration startDuration, Duration endDuration})? duration})
      : _overlay = overlay,
        _portalController = portalController,
        _overlayController = overlayController,
        _startAnimation = startAnimation,
        _endAnimation = endAnimation,
        _duration = duration;

  @override
  State<AmazingOverlayWidget> createState() => _AmazingOverlayWidgetState();
}

class _AmazingOverlayWidgetState extends State<AmazingOverlayWidget>
    with TickerProviderStateMixin {
  late AnimationController startController;
  late Animation<double> startAnimation;
  late AnimationController endController;
  late Animation<double> endAnimation;
  late StreamSubscription<OverlayState> stream;
  late StartAnimationFactory _startAnimationFactory;
  late EndAnimationFactory _endAnimationFactory;

  Future onClosingDialog() async {
    stream =
        widget._overlayController.streamListener().listen((overlayState) async {
      if (overlayState == OverlayState.hidden) {
        startController.stop(canceled: true);
        endController.forward().whenCompleteOrCancel(() {
          widget._portalController.hide();
        });
      }
    });
  }

  @override
  void initState() {
    _startAnimationFactory = StartAnimationFactory();
    _endAnimationFactory = EndAnimationFactory();

    ({Animation<double> animation, AnimationController controle}) startRecorde =
        _startAnimationFactory.createAnimation(widget._startAnimation, this, widget._duration?.startDuration);
    startAnimation = startRecorde.animation;
    startController = startRecorde.controle;

    ({Animation<double> animation, AnimationController controle}) endRecorde =
        _endAnimationFactory.createAnimation(widget._endAnimation,this, widget._duration?.endDuration);
    endAnimation = endRecorde.animation;
    endController = endRecorde.controle;

    startController.forward();

    onClosingDialog();
    super.initState();
  }

  @override
  void dispose() {
    stream.cancel();
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, _) {
        return AnimatedBuilder(
          builder: (context, _) {
            return Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(0, startAnimation.value + endAnimation.value),
                child: Opacity(
                    opacity: 1 - endController.value, child: widget._overlay),
              ),
            );
          },
          animation: startAnimation,
        );
      },
      animation: endAnimation,
    );
  }
}
