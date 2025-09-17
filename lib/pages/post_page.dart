import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMostUse,
      body: Container(
        margin: EdgeInsets.only(top: context.screenHeight * 0.05),
        child: Column(
          children: [
            Center(
              child: Text(
                'Add package',
                style: AppStyless.styleWhiteBold22,
              ),
            ),
            SizedBox(height: context.screenHeight * .015),
            Expanded(
                child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: context.screenHeight * .016),
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
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
                  Text(
                    'Add location',
                    style: AppStyless.styleBold28.copyWith(fontSize: 22),
                  ),
                  SizedBox(height: context.screenHeight * .015),
                  Text(
                    'Pick Up',
                    style: AppStyless.styleSemiBold17,
                  ),
                  SizedBox(height: context.screenHeight * .007),
                  CustomTextFormField(
                    backgroundColor: Colors.white,
                    hintText: 'Enter pickup location',
                  ),
                  SizedBox(height: context.screenHeight * .015),
                  Text(
                    'DropOff',
                    style: AppStyless.styleSemiBold17,
                  ),
                  SizedBox(height: context.screenHeight * .007),
                  CustomTextFormField(
                    backgroundColor: Colors.white,
                    hintText: 'Enter dropoff location',
                  ),
                  SizedBox(height: context.screenHeight * .02),
                  Center(
                    child: CustomButton(
                      text: 'Submit location',
                      buttonColor: kMostUse,
                      style: AppStyless.styleWhiteBold22.copyWith(fontSize: 16),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
