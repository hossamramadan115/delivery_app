import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/all_custom_delivers_section.dart';
import 'package:delivery/widgets/track_your_shipment_section.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              top: context.screenHeight * 0.05, right: 16, left: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.locationDot,
                    color: kMostUse,
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
              SizedBox(height: context.screenHeight * .015),
              TrackYourShipmentSection(),
              SizedBox(height: context.screenHeight * .03),
              AllCustomDeliversSection(),
              SizedBox(height: context.screenHeight * .08),
            ],
          ),
        ),
      ),
    );
  }
}
