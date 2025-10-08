import 'package:delivery/Admin/done_widget.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class OrdeStatus extends StatelessWidget {
  const OrdeStatus({
    super.key,
    required this.dropoffAddress,
    required this.dropoffPhone,
    required this.dropoffUserName,
    required this.pickupAddress,
    required this.pickupPhone,
    required this.pickupUserName,
    required this.price,
    this.button1,
    this.button2,
    this.button3,
    this.button4,
    required this.tracker,
    this.button5,
  });
  final String dropoffAddress;
  final String dropoffPhone;
  final String dropoffUserName;
  final String pickupAddress;
  final String pickupPhone;
  final String pickupUserName;
  final num price;
  final int tracker;
  final Function()? button1, button2, button3, button4, button5;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.only(bottom: 16),
      borderRadius: BorderRadius.circular(30),
      // تم إزالة الـ SingleChildScrollView المكرر هنا
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              Assets.kParcel,
              height: context.screenHeight * .1,
            ),
          ),
          Text(
            'Drop-Off Details',
            style: AppStyless.styleSemiBold17,
          ),
          Text(
            'Adress: $dropoffAddress',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          Text(
            'Name: $dropoffUserName',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Phone: $dropoffPhone',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
          ),
          SizedBox(height: context.screenHeight * .02),
          Text(
            'Pick-Up Details',
            style: AppStyless.styleSemiBold17,
          ),
          Text(
            'Adress: $pickupAddress',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          Text(
            'Name: $pickupUserName',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Phone: $pickupPhone',
            style: AppStyless.styleBold18.copyWith(fontSize: 16),
          ),
          SizedBox(height: context.screenHeight * .02),
          tracker >= 0
              ? DoneWidget()
              : CustomButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .05),
                  text: 'Driver on the way to pickup point',
                  style: TextStyle(fontSize: context.screenWidth * 0.045),
                  onTap: tracker == -1 ? button1 : null,
                ),
          SizedBox(height: context.screenHeight * .02),
          tracker >= 1
              ? DoneWidget()
              : CustomButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .05),
                  text: 'Driver has arrived to pickup point',
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.045,
                  ),
                  onTap: tracker == 0 ? button2 : null,
                ),
          SizedBox(height: context.screenHeight * .02),
          tracker >= 2
              ? DoneWidget()
              : CustomButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .05),
                  text: 'Parcel collected',
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.045,
                  ),
                  onTap: tracker == 1 ? button3 : null,
                ),
          SizedBox(height: context.screenHeight * .02),
          tracker >= 3
              ? DoneWidget()
              : CustomButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .05),
                  text: 'Driver on th way to delivery destination',
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.045,
                  ),
                  onTap: tracker == 2 ? button4 : null,
                ),
          SizedBox(height: context.screenHeight * .02),
          tracker >= 4
              ? DoneWidget()
              : CustomButton(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .05),
                  text: 'Parcel delivered',
                  style: TextStyle(
                    fontSize: context.screenWidth * 0.045,
                  ),
                  onTap: tracker == 3 ? button5 : null,
                ),
          SizedBox(height: context.screenHeight * .01),
        ],
      ),
    );
  }
}
