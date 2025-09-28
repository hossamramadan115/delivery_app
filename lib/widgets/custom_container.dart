import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding, this.color,
  });
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(context.screenHeight * .02),
      //  EdgeInsets.all(
      // left: context.screenHeight * .02,
      // right: context.screenHeight * .02,
      // top: context.screenHeight * .02,
      // bottom: context.screenHeight * .02,
      // ),
      width: width ?? context.screenWidth,
      height: height,
      decoration: BoxDecoration(
        color:color?? Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
