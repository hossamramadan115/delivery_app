import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    this.child,
  });
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: context.screenHeight * .02,
          right: context.screenHeight * .02,
          top: context.screenHeight * .02,
          bottom: context.screenHeight * .03),
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
