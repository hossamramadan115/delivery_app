import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF7D7),
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.kOnboarding,
              height: context.screenHeight * 0.55,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            SizedBox(height: context.screenHeight * 0.03),

            Text(
              textAlign: TextAlign.center,
              'Track your Parcel\nfrom anywhere',
              style: AppStyless.styleBold28,
            ),

            SizedBox(height: context.screenHeight * 0.03),

            Text(
              textAlign: TextAlign.center,
              'Check the progress of \nyour deliveries',
              style: AppStyless.styleBold18,
            ),

            SizedBox(height: context.screenHeight * 0.05),

            /// زر Next
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Track Now',
                  buttonColor: Color(0xfff8ae39),
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kBottomBar);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
