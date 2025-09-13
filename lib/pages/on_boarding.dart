import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffFCF7D7),
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              Assets.kOnboarding,
              height: screenHeight * 0.55,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            SizedBox(height: screenHeight * 0.03),

            Text(
              textAlign: TextAlign.center,
              'Track your Parcel\nfrom anywhere',
              style: AppStyless.styleBold28,
            ),

            SizedBox(height: screenHeight * 0.03),

            Text(
              textAlign: TextAlign.center,
              'Check the progress of \nyour deliveries',
              style: AppStyless.styleBold18,
            ),

            SizedBox(height: screenHeight * 0.05),

            /// زر Next
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    GoRouter.of(context).push(AppRouter.kBottomBar);
                  },
                  child: Container(
                    // margin: EdgeInsets.only(right: screenWidth * 0.05),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                        vertical: screenHeight * 0.009),
                    decoration: BoxDecoration(
                      color: Color(0xfff8ae39),
                      borderRadius: BorderRadius.circular(16),
                      // shape: BoxShape.circle,
                    ),
                    child: Text(
                      'Track Now',
                      style: AppStyless.styleWhiteBold22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
