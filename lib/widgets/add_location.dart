import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddLocation extends StatelessWidget {
  const AddLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }
}
