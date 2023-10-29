import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/animated_scale_bounce.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/tappable.dart';
import 'package:quan_ly_chi_tieu/ui/widgets/text_font.dart';

class AppButtonCustomWidget extends StatelessWidget {
  const AppButtonCustomWidget({
    Key? key,
    required this.constraints,
    required this.text,
    required this.onPressed,
    this.animationScale,
    this.onLongPress,
    this.heightRatio = 0.25,
    this.widthRatio = 0.25,
    this.color,
    this.child,
    this.onDoubleTap,
  }) : super(key: key);
  final BoxConstraints constraints;
  final String text;
  final Function() onPressed;
  final double heightRatio;
  final double widthRatio;
  final Color? color;
  final Widget? child;
  final Function? onLongPress;
  final double? animationScale;
  final Function? onDoubleTap;
  @override
  Widget build(BuildContext context) {
    return AnimatedScaleBounce(
      animationScale: animationScale,
      child: SizedBox(
        width: constraints.maxWidth * widthRatio,
        height: constraints.maxWidth * heightRatio,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Tappable(
            onDoubleTap: () {
              onDoubleTap != null ? onDoubleTap!() : "";
            },
            onTap: () {
              onPressed();
            },
            onLongPress: () {
              onLongPress != null ? onLongPress!() : "";
            },
            borderRadius: 1000,
            color: color ?? Theme.of(context).colorScheme.secondaryContainer,
            child: child ??
                Center(
                  child: TextFont(
                    autoSizeText: true,
                    minFontSize: 15,
                    maxFontSize: 28,
                    maxLines: 2,
                    fontSize: 28,
                    text: text,
                    textColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    translate: false,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
