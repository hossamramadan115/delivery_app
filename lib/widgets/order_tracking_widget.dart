import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_custom_dialog.dart';
import 'package:delivery/models/order.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderTrackingWidget extends StatelessWidget {
  final int currentStep;
  final OrderModel order;

  const OrderTrackingWidget({
    super.key,
    required this.currentStep,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final statusList = [
      {
        "text": "Driver on the way to pickup point",
        "icon": FontAwesomeIcons.motorcycle
      },
      {
        "text": "Driver has arrived to pickup point",
        "icon": FontAwesomeIcons.locationDot
      },
      {"text": "Parcel collected", "icon": FontAwesomeIcons.boxOpen},
      {
        "text": "Driver on the way to delivery destination",
        "icon": FontAwesomeIcons.truckFast
      },
      {"text": "Parcel delivered", "icon": FontAwesomeIcons.check},
    ];

    final circleSize = context.screenWidth * 0.06;
    final iconSize = circleSize * 0.6;
    final lineHeight = context.screenWidth * 0.1;
    final fontSize = context.screenWidth * 0.04;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 العنوان + زر الحذف
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.track}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.xmark, color: Colors.black),
                  onPressed: () async {
                    showCustomDialog(
                      context: context,
                      title: "Delete Confirmation",
                      content:
                          "Are you sure you want to delete this order? This action cannot be undone.",
                      confirmText: "Delete",
                      onConfirm: () async {
                        final messenger = ScaffoldMessenger.of(context);

                        try {
                          await DatabaseMethods().deleteOrder(order.id);

                          // تأجيل تنفيذ الـ pop عشان ما يحصلش تداخل مع النظام
                          Future.delayed(Duration.zero, () {
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          });

                          if (context.mounted) {
                            messenger.showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("✅ Order deleted successfully")),
                            );
                          }
                        } catch (e) {
                          Future.delayed(Duration.zero, () {
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          });

                          if (context.mounted) {
                            messenger.showSnackBar(
                              SnackBar(content: Text("❌ Error: $e")),
                            );
                          }
                        }
                      },
                    );
                  },
                )
              ],
            ),

            const SizedBox(height: 4),
            Text(
              "${order.pickUpAddress} → ${order.dropOffAddress}",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "EGP ${order.price.toStringAsFixed(2)}",
              style: const TextStyle(
                color: kMostUse,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Status: ${order.status}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const Divider(height: 20),

            /// 🔹 خطوات التتبع
            ...List.generate(
              statusList.length,
              (index) {
                final isActive = index <= currentStep;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.03,
                            vertical: context.screenWidth * 0.02,
                          ),
                          width: circleSize,
                          height: circleSize,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            statusList[index]["icon"] as IconData,
                            size: iconSize,
                            color: Colors.white,
                          ),
                        ),
                        if (index != statusList.length - 1)
                          Container(
                            width: 3,
                            height: lineHeight,
                            color: isActive ? Colors.green : Colors.grey[300],
                          ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: circleSize * 0.2),
                        child: Text(
                          statusList[index]["text"] as String,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: isActive ? Colors.black : Colors.grey,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
