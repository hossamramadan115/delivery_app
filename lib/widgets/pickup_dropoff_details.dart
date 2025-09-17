import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:delivery/widgets/pickup_details.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PickupDropoffDetails extends StatelessWidget {
  const PickupDropoffDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          child: Column(
            children: [
              Text(
                'Pick-up details',
                style: AppStyless.styleBold28.copyWith(fontSize: 22),
              ),
              SizedBox(height: context.screenHeight * .02),
              PickupDetails(
                icon: FontAwesomeIcons.locationDot,
                hintText: 'Enter pick-up address',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                icon: FontAwesomeIcons.solidUser,
                hintText: 'Enter user name',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                icon: FontAwesomeIcons.phone,
                hintText: 'Enter phone number',
              ),
            ],
          ),
        ),
        SizedBox(height: context.screenHeight * .04),
        CustomContainer(
          child: Column(
            children: [
              Text(
                'Drop-off details',
                style: AppStyless.styleBold28.copyWith(fontSize: 22),
              ),
              SizedBox(height: context.screenHeight * .02),
              PickupDetails(
                icon: FontAwesomeIcons.locationDot,
                hintText: 'Enter pick-up address',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                icon: FontAwesomeIcons.solidUser,
                hintText: 'Enter user name',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                icon: FontAwesomeIcons.phone,
                hintText: 'Enter phone number',
              ),
            ],
          ),
        ),
        SizedBox(height: context.screenHeight * .03),
        CustomContainer(
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    'Total price',
                    style: AppStyless.styleSemiBold17,
                  ),
                  Text('\$150', style: AppStyless.stylePrice),
                ],
              ),
              Spacer(),
              CustomButton(
                text: 'Place order',
                style: AppStyless.styleWhiteBold22.copyWith(fontSize: 16),
                buttonColor: kMostUse,
                onTap: () {},
              )
            ],
          ),
        ),
      ],
    );
  }
}
