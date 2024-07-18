part of '../amazing_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  OverlayController overlayController;
  Widget child;
  String titleText;
  String contentText;
  String confirmButtonText;
  String cancelButtonText;
  TextStyle? titleTextStyle;
  TextStyle? contentTextStyle;
  TextStyle? confirmButtonTextStyle;
  TextStyle? cancelButtonTextStyle;
  Color? backgroundColor;
  BoxShadow? boxShadow;
  EdgeInsets? padding;
  BorderRadius? borderRadius;
  double? width;


  ConfirmDialog(
      {
        super.key,
        required this.overlayController,
        required this.titleText,
        required this.contentText,
        required this.confirmButtonText,
        required this.cancelButtonText,
        required this.child,
        this.width,
        this.titleTextStyle,
        this.contentTextStyle,
        this.cancelButtonTextStyle,
        this.confirmButtonTextStyle,
        this.backgroundColor,
        this.boxShadow,
        this.padding,
        this.borderRadius
      });

  @override
  Widget build(BuildContext context) {
    return AmazingOverlay<OneAnimation>(
      overlayController: overlayController,
      onDialogOpened: (TickerProvider vsync) {
        AnimationController animationController = AnimationController(
            vsync: vsync, duration: const Duration(milliseconds: 500), reverseDuration: const Duration(milliseconds: 500));
        Animation<double> animation = CurvedAnimation(
                parent: animationController,
                curve: Curves.fastLinearToSlowEaseIn)
            .drive(Tween<double>(begin: 40.0, end: 0.0));
        animationController.forward();
        return OneAnimation(animationController, animation);
      },
      onDialogClosed: (OneAnimation animations) async {
        animations.animationController.stop(canceled: true);
        await animations.animationController.reverse();
      },
      builder: builder,
      child: child,
    );
  }

  Widget builder(BuildContext context, OneAnimation animations) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: animations.animation,
              builder: (context, _) {
                return Container(
                  transform: Matrix4.translationValues(
                      0, animations.animation.value as double, 0),
                  padding: padding ?? const EdgeInsets.all(15),
                  width: width ?? 320,
                  // height: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surfaceContainerHigh,
                      boxShadow: [
                        boxShadow ?? BoxShadow(
                            color: (theme.dialogTheme.shadowColor ?? Colors.transparent).withOpacity(.2),
                            offset: const Offset(0, 0),
                            blurRadius: 16)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            titleText,
                            style: titleTextStyle ?? theme.dialogTheme.titleTextStyle,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OverflowBox(
                              fit: OverflowBoxFit.deferToChild,
                                child: Text(
                              contentText,
                              style: contentTextStyle ?? theme.dialogTheme.contentTextStyle,
                            )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: overlayController.hide,
                              style: theme.textButtonTheme.style,
                              child: Text(
                                confirmButtonText,
                                style: contentTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: overlayController.hide,
                              style: theme.textButtonTheme.style,
                              child: Text(
                               cancelButtonText,
                                style: cancelButtonTextStyle,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
