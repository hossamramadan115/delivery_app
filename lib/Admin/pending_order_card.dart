import 'package:delivery/Admin/admin_action_button.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PendingOrderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String orderId;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const PendingOrderCard({
    super.key,
    required this.data,
    required this.orderId,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final double cardPadding = context.screenWidth * 0.045;
    final double fontSize = context.screenWidth * 0.04;
    // final double titleFont = context.screenWidth * 0.045;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: context.screenHeight * 0.012),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${data["PickupUserName"]} → ${data["DropoffUserName"]}",
                  style: AppStyless.styleBold18,
                  overflow: TextOverflow.visible,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Pending",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.screenHeight * .014),

          // 🔹 Addresses (expanded for long text)
          Text(
            "📍 Pickup: ${data["PickupAddress"]}",
            style: TextStyle(color: Colors.black, fontSize: fontSize),
            maxLines: 3,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          SizedBox(height: context.screenHeight * .013),
          Text(
            "📦 Drop-off: ${data["DropoffAddress"]}",
            style: TextStyle(color: Colors.black, fontSize: fontSize),
            maxLines: 3,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),

          SizedBox(height: context.screenHeight * .013),

          // 🔹 Price and phone
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "💰 ${data["Price"]} EGP",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
              Text(
                "📞 ${data["PickupPhone"]}",
                style: TextStyle(color: Colors.black, fontSize: fontSize),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Action Buttons
          Row(
            children: [
              AdminActionButton(
                text: "Accept",
                icon: Icons.check,
                color: Colors.green,
                onPressed: onAccept,
              ),

              SizedBox(width: context.screenWidth * .03),

              // ✅ زر الرفض (Reject)
              AdminActionButton(
                text: "Reject",
                icon: FontAwesomeIcons.xmark,
                color: Colors.redAccent,
                onPressed: onReject,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
