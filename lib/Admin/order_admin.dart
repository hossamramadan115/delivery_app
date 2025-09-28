import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class OrderAdmin extends StatefulWidget {
  const OrderAdmin({super.key});

  @override
  State<OrderAdmin> createState() => _OrderAdminState();
}

class _OrderAdminState extends State<OrderAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMostUse,
      // resizeToAvoidBottomInset: true,
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
                      vertical: context.screenHeight * .03,
                    ),
                    child: CustomContainer(
                      borderRadius: BorderRadius.circular(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              Assets.kParcel,
                              height: context.screenHeight * .15,
                            ),
                          ),
                          Text(
                            'Drop-Off Details',
                            style: AppStyless.styleSemiBold17,
                          ),
                          Text(
                            'Adress: sera alliana',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Text(
                            'Name: hossam ramadan ',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Phone: 01019148497',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: context.screenHeight * .02),
                          Text(
                            'Pick-Up Details',
                            style: AppStyless.styleSemiBold17,
                          ),
                          Text(
                            'Adress: sera alliana',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          Text(
                            'Name: hossam ramadan',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Phone: 01019148497',
                            style:
                                AppStyless.styleBold18.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
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
