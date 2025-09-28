import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class InactiveOrder extends StatelessWidget {
  const InactiveOrder({
    super.key,
    this.onTap,
    required this.image,
    required this.text,
  });

  final void Function()? onTap;
  final String image, text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        color: const Color.fromARGB(255, 232, 230, 230),
        padding: EdgeInsets.all(context.screenHeight * .01),
        width: context.screenWidth * .4,
        child: Column(
          children: [
            Image.asset(
              image,
              height: context.screenHeight * .08,
            ),
            SizedBox(height: context.screenHeight * .02),
            Text(
              text,
              style: AppStyless.styleBold28.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
