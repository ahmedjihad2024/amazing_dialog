part of '../amazing_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  OverlayController overlayController;
  Widget child;

  ConfirmDialog(
      {super.key, required this.child, required this.overlayController});

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

  Widget builder(OneAnimation animations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
              animation: animations.animation,
              builder: (context, _) {
                ThemeData theme = Theme.of(context);
                return Container(
                  transform: Matrix4.translationValues(
                      0, animations.animation.value as double, 0),
                  padding: const EdgeInsets.all(20),
                  width: 320,
                  // height: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green.withOpacity(.2),
                            offset: const Offset(0, 0),
                            blurRadius: 16)
                      ]),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Amazing Dialog",
                            style: TextStyle(color: Colors.green, fontSize: 20, height: 1 ,fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OverflowBox(
                              fit: OverflowBoxFit.deferToChild,
                                child: Text(
                              "Hi, this is a custom dialog using portalOverlay widget it's benefit widget.",
                              style: TextStyle(
                                  color: Colors.green.withOpacity(.9), fontSize: 16, height: 1.2, fontWeight: FontWeight.normal),
                            )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: overlayController.hide,
                              style: ButtonStyle(
                                  fixedSize: const WidgetStatePropertyAll(
                                      Size(double.infinity, 40)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.green.withOpacity(1)),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(9)))),
                              child: const Text(
                                "Confirm",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: overlayController.hide,
                              style: ButtonStyle(
                                  fixedSize: const WidgetStatePropertyAll(
                                      Size(double.infinity, 40)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.green.withOpacity(.2)),
                                  shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(9)))),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.green, fontSize: 14),
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
