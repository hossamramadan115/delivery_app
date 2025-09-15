import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class TrackYourShipmentSection extends StatelessWidget {
  const TrackYourShipmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  Container(
                width: screenWidth,
                height: screenHeight / 2.2,
                decoration: BoxDecoration(
                  color: kMostUse,
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
              );
  }
}