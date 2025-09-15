import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
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
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Image.asset(
                    Assets.kDeliveryTruck,
                    height: context.screenHeight * .2,
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
