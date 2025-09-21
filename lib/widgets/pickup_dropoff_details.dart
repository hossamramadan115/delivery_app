import 'dart:convert';
import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_button.dart';
import 'package:delivery/widgets/custom_container.dart';
import 'package:delivery/widgets/payment_wep_view.dart';
import 'package:delivery/widgets/pickup_details.dart';
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

  Future<void> startPayment() async {
    setState(() => _loading = true);

    try {
      // 1) Get auth token
      final authRes = await http.post(
        Uri.parse("https://accept.paymob.com/api/auth/tokens"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"api_key": PAYMOB_API_KEY}),
      );
      final authToken = jsonDecode(authRes.body)["token"];

      // 2) Create order
      const amount = 100; // السعر (بالجنيه)
      final orderRes = await http.post(
        Uri.parse("https://accept.paymob.com/api/ecommerce/orders"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "auth_token": authToken,
          "delivery_needed": "false",
          "amount_cents": (amount * 100).toString(),
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
          "amount_cents": (amount * 100).toString(),
          "expiration": 3600,
          "order_id": orderId,
          "billing_data": {
            "apartment": "NA",
            "email": "test@example.com",
            "floor": "NA",
            "first_name": "Test",
            "street": "NA",
            "building": "NA",
            "phone_number": "01000000000", // رقم تجريبي
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebView(url: iframeUrl),
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
        CustomContainer(
          child: Column(
            children: [
              Text(
                'Pick-up details',
                style: AppStyless.styleBold28.copyWith(fontSize: 22),
              ),
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
        CustomContainer(
          child: Column(
            children: [
              Text(
                'Drop-off details',
                style: AppStyless.styleBold28.copyWith(fontSize: 22),
              ),
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
        CustomContainer(
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    'Total price',
                    style: AppStyless.styleSemiBold17,
                  ),
                  Text('\$150', style: AppStyless.stylePrice),
                ],
              ),
              Spacer(),
              CustomButton(
                text: 'Place order',
                style: AppStyless.styleWhiteBold22.copyWith(fontSize: 16),
                buttonColor: kMostUse,
                onTap: startPayment,
              )
            ],
          ),
        ),
      ],
    );
  }
}




// String? email;
  // late Razorpay _razorpay;
  // int total = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay = Razorpay();

  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  //   onLoad();
  // }

  // Future<void> getTheSharedPref() async {
  //   email = await SharedPreferencesHelper().getUserEmail();
  //   setState(() {}); // هنا مفيد عشان تحدث UI بعد جلب الايميل
  // }

  // Future<void> onLoad() async {
  //   await getTheSharedPref();
  // }

  // void openCheckout(String amount, String email) {
  //   var options = {
  //     'key': 'RazorPayKey',
  //     'amount': amount,
  //     'name': 'Package Delivery App',
  //     'description': 'Payment for your order',
  //     'prefill': {'email': email},
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };

  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   showSuccessSnack(context, "Payment Success: ${response.paymentId}");
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   showErrorSnack(context, "Payment Failure: ${response.message}");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   showErrorSnack(context, "External Wallet: ${response.walletName}");
  // }

  // @override
  // void dispose() {
  //   _razorpay.clear();
  //   super.dispose();
  // }

     //  () {
                // if (email != null && email!.isNotEmpty) {
                //   openCheckout((total * 100).toString(), email!);
                //   // خد بالك: amount في Razorpay بيتحسب بالـ paisa (يعني لو 100 جنيه = 100 * 100 = 10000)
                // } else {
                //   showErrorSnack(
                //       context, "Email not found, please login again.");
                // }
                // },