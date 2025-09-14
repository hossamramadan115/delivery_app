import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        margin: EdgeInsets.only(top: 40, right: 20, left: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.locationDot,
                  color: kHomeColor,
                ),
                SizedBox(width: 10),
                Text(
                  'current location',
                  style: AppStyless.styleBold18,
                ),
              ],
            ),
            Text(
              'City name : sers ellian',
              style: AppStyless.styleBold28.copyWith(fontSize: 20),
            ),
            SizedBox(height: screenHeight * .015),
            Container(
              width: screenWidth,
              height: screenHeight / 2.2,
              decoration: BoxDecoration(
                color: kHomeColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * .02),
                  Text(
                    'Track your shipment',
                    style: AppStyless.styleWhiteBold22,
                  ),
                  Text(
                    'Please enter your shipment number',
                    style: AppStyless.styleWhiteBold15,
                  ),
                  SizedBox(height: screenHeight * .03),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenHeight * .026),
                    child: CustomTextFormField(
                      backgroundColor: Colors.white,
                      icon: Icons.track_changes,
                      iconColor: Colors.red,
                      hintText: 'Enter track number',
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    Assets.kOnHome,
                    height: screenHeight * .25,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
