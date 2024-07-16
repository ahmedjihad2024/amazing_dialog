part of 'amazing_dialog.dart';

class StartAnimations {
  ({AnimationController controle, Animation<double> animation}) animation01(
      TickerProvider vsync, Duration? duration) {
    AnimationController controller = AnimationController(
        vsync: vsync, duration: duration ?? const Duration(milliseconds: 1000));

    Animation<double> animation = controller
        .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn))
        .drive(TweenSequence([
          TweenSequenceItem(tween: Tween(begin: 80, end: 0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0, end: -30), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -30, end: 0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0, end: 20), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 20, end: 0), weight: 1)
        ]));
    return (controle: controller, animation: animation);
  }

  ({AnimationController controle, Animation<double> animation}) animation02(
      TickerProvider vsync, Duration? duration) {
    AnimationController controller = AnimationController(
        vsync: vsync, duration: duration ?? const Duration(milliseconds: 300));

    Animation<double> animation = controller
        .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn))
        .drive(Tween(begin: 80, end: 0));
    return (controle: controller, animation: animation);
  }
}

class EndAnimations {
  ({AnimationController controle, Animation<double> animation}) animation01(
      TickerProvider vsync, Duration? duration) {
    AnimationController controller = AnimationController(
        vsync: vsync, duration: duration ?? const Duration(milliseconds: 250));

    Animation<double> animation = controller
        .drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn))
        .drive(Tween(begin: 0, end: 80));

    return (controle: controller, animation: animation);
  }
}

class StartAnimationFactory {
  StartAnimations? _startAnimations;

  ({AnimationController controle, Animation<double> animation}) createAnimation(
      StartAnimation startAnimation, TickerProvider vsync, Duration? duration) {
    _startAnimations ??= StartAnimations();
    return switch (startAnimation) {
      StartAnimation.animation01 =>
        _startAnimations!.animation01(vsync, duration),
      StartAnimation.animation02 =>
        _startAnimations!.animation02(vsync, duration),
    };
  }
}

class EndAnimationFactory {
  EndAnimations? _endAnimations;

  ({AnimationController controle, Animation<double> animation}) createAnimation(
      EndAnimation startAnimation, TickerProvider vsync, Duration? duration) {
    _endAnimations ??= EndAnimations();
    return switch (startAnimation) {
      EndAnimation.animation01 => _endAnimations!.animation01(vsync, duration),
    };
  }
}
