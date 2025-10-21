import 'dart:convert';
import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_snack_bar.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:delivery/widgets/payment_wep_view.dart';
import 'package:delivery/widgets/pickup_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class PickupDropoffDetails extends StatefulWidget {
  const PickupDropoffDetails({super.key});

  @override
  State<PickupDropoffDetails> createState() => _PickupDropoffDetailsState();
}

class _PickupDropoffDetailsState extends State<PickupDropoffDetails> {
  final pickUpAddress = TextEditingController();
  final pickUpUserName = TextEditingController();
  final pickUpPhone = TextEditingController();
  final drpOffAddress = TextEditingController();
  final dropOffUserName = TextEditingController();
  final dropOffPhone = TextEditingController();

  bool _loading = false;

  Future<void> startPayment(OrderModel order) async {
    setState(() => _loading = true);

    try {
      // 1) Get auth token
      final authRes = await http.post(
        Uri.parse("https://accept.paymob.com/api/auth/tokens"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"api_key": PAYMOB_API_KEY}),
      );
      final authToken = jsonDecode(authRes.body)["token"];

      // 2) Create order in Paymob
      final orderRes = await http.post(
        Uri.parse("https://accept.paymob.com/api/ecommerce/orders"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": (order.price * 100).toString(),
          "currency": "EGP",
          "items": []
        }),
      );
      final orderId = jsonDecode(orderRes.body)["id"];

      // 3) Get payment key
      final payKeyRes = await http.post(
        Uri.parse("https://accept.paymob.com/api/acceptance/payment_keys"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "amount_cents": (order.price * 100).toString(),
          "expiration": 3600,
          "order_id": orderId,
          "billing_data": {
            "apartment": "NA",
            "email": FirebaseAuth.instance.currentUser?.email ?? "test@example.com",
            "floor": "NA",
            "first_name": order.pickUpUserName,
            "street": "NA",
            "building": "NA",
            "phone_number": order.pickUpPhone,
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "Cairo",
            "country": "EG",
            "last_name": "User",
            "state": "NA"
          },
          "currency": "EGP",
          "integration_id": INTEGRATION_ID_VODAFONE,
        }),
      );
      final payToken = jsonDecode(payKeyRes.body)["token"];

      // 4) Build iframe url
      final iframeUrl =
          "https://accept.paymob.com/api/acceptance/iframes/$IFRAME_ID?payment_token=$payToken";

      // 5) Open WebView
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebView(
            url: iframeUrl,
            order: order, 
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong!")),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Pick-up
        CustomContainer(
          child: Column(
            children: [
              Text('Pick-up details',
                  style: AppStyless.styleBold28.copyWith(fontSize: 22)),
              SizedBox(height: context.screenHeight * .02),
              PickupDetails(
                controller: pickUpAddress,
                icon: FontAwesomeIcons.locationDot,
                hintText: 'Enter pick-up address',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                controller: pickUpUserName,
                icon: FontAwesomeIcons.solidUser,
                hintText: 'Enter user name',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                controller: pickUpPhone,
                icon: FontAwesomeIcons.phone,
                hintText: 'Enter phone number',
              ),
            ],
          ),
        ),

        SizedBox(height: context.screenHeight * .04),

        /// Drop-off
        CustomContainer(
          child: Column(
            children: [
              Text('Drop-off details',
                  style: AppStyless.styleBold28.copyWith(fontSize: 22)),
              SizedBox(height: context.screenHeight * .02),
              PickupDetails(
                controller: drpOffAddress,
                icon: FontAwesomeIcons.locationDot,
                hintText: 'Enter drop-off address',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                controller: dropOffUserName,
                icon: FontAwesomeIcons.solidUser,
                hintText: 'Enter user name',
              ),
              SizedBox(height: context.screenHeight * .01),
              PickupDetails(
                controller: dropOffPhone,
                icon: FontAwesomeIcons.phone,
                hintText: 'Enter phone number',
              ),
            ],
          ),
        ),

        SizedBox(height: context.screenHeight * .03),

        /// Price + Button
        CustomContainer(
          child: Row(
            children: [
              Column(
                children: [
                  Text('Total price', style: AppStyless.styleSemiBold17),
                  Text('100 EGP', style: AppStyless.stylePrice),
                ],
              ),
              const Spacer(),
              CustomButton(
                text: _loading ? 'Loading...' : 'Place order',
                style: AppStyless.styleWhiteBold22.copyWith(fontSize: 16),
                buttonColor: kMostUse,
                onTap: _loading
                    ? null
                    : () async {
                        if (pickUpAddress.text.isNotEmpty &&
                            pickUpUserName.text.isNotEmpty &&
                            pickUpPhone.text.isNotEmpty &&
                            drpOffAddress.text.isNotEmpty &&
                            dropOffUserName.text.isNotEmpty &&
                            dropOffPhone.text.isNotEmpty) {
                          final order = OrderModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            pickUpAddress: pickUpAddress.text,
                            pickUpUserName: pickUpUserName.text,
                            pickUpPhone: pickUpPhone.text,
                            dropOffAddress: drpOffAddress.text,
                            dropOffUserName: dropOffUserName.text,
                            dropOffPhone: dropOffPhone.text,
                            price: 100.0,
                          );

                          // ✅ الدفع فقط (Firestore هيتسجل بعد النجاح جوه PaymentWebView)
                          await startPayment(order);
                        } else {
                          showErrorSnack(context, 'Please Fill Complete Details');
                        }
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
