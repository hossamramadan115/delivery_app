import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/add_location.dart';
import 'package:delivery/widgets/pickup_dropoff_details.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMostUse,
      resizeToAvoidBottomInset: true, // ✅ عشان لما الكيبورد يفتح ميبوش الحاجة
      body: Column(
        children: [
          SizedBox(height: context.screenHeight * 0.05),
          Center(
            child: Text(
              'Add package',
              style: AppStyless.styleWhiteBold22,
            ),
          ),
          SizedBox(height: context.screenHeight * .015),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: Container(
                color: kPrimaryColor,
                width: context.screenWidth,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenHeight * .016,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            Assets.kDeliveryTruck,
                            height: context.screenHeight * .2,
                          ),
                        ),
                        AddLocation(),
                        SizedBox(height: context.screenHeight * .02),
                        PickupDropoffDetails(),
                        SizedBox(height: context.screenHeight * .08),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
