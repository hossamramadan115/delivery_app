import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/helper/show_snack_bar.dart';
import 'package:delivery/models/order_model.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({
    super.key,
    required this.url,
    required this.order,
  });

  final String url;
  final OrderModel order;

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  String? userId;
  String? email;

  Future<void> getSharedPref() async {
    email = await SharedPreferencesHelper().getUserEmail();
    userId = await SharedPreferencesHelper().getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (nav) async {
          final url = nav.url.toLowerCase();

          /// ✅ لو الدفع نجح
          if (url.contains("success") || url.contains("paid")) {
            final trackNumber = "TRK-${randomAlphaNumeric(8)}";
            final orderId = "ORD-${randomAlphaNumeric(8)}";

            final orderMap = {
              "OrderId": orderId,
              "PickupAddress": widget.order.pickUpAddress,
              "PickupUserName": widget.order.pickUpUserName,
              "PickupPhone": widget.order.pickUpPhone,
              "DropoffAddress": widget.order.dropOffAddress,
              "DropoffUserName": widget.order.dropOffUserName,
              "DropoffPhone": widget.order.dropOffPhone,
              "Price": widget.order.price,
              "Track": trackNumber,
              // "Status": "Paid",
              "Status": "Pending",
              "CreatedAt": FieldValue.serverTimestamp(),
              "UserId": userId,
              "Email": email,
              "Tracker":-1,
            };

            if (userId != null) {
              await DatabaseMethods().addUserOrder(orderMap, userId!, orderId);
            }
            await DatabaseMethods().addAdminOrder(orderMap, orderId);

            showSuccessSnack(
              context,
              "✅ Payment Success\nTrack: $trackNumber\nOrder ID: $orderId",
            );
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }

          /// ❌ لو الدفع فشل أو اتلغي
          else if (url.contains("fail") ||
              url.contains("error") ||
              url.contains("cancel")) {
            showErrorSnack(context, "❌ Payment Failed");
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PayMob WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
