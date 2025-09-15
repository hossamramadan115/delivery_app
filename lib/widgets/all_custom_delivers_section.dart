import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_delivers.dart';
import 'package:flutter/material.dart';

class AllCustomDeliversSection extends StatelessWidget {
  const AllCustomDeliversSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDelivers(
          title: "Order a delivery",
          subtitle:
              "we'll pick it up and deliver it across town quickly and securely.",
          imagePath: Assets.kFastDelivery,
        ),
        SizedBox(height: context.screenHeight * .016),
        CustomDelivers(
          title: 'Track a delivery',
          subtitle: 'track your delivery in real-Time from pickup to drop-off.',
          imagePath: Assets.kParcel,
        ),
        SizedBox(height: context.screenHeight * .016),
        CustomDelivers(
          title: 'Check delivery history',
          subtitle:
              'Check your delivery history any time to view details and stay organized.',
          imagePath: Assets.kDeliveryBike,
        ),
      ],
    );
  }
}
