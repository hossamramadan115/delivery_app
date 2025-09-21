import 'package:delivery/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;
  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (nav) {
          final url = nav.url.toLowerCase();
          if (url.contains("success")) {
            showSuccessSnack(context, "✅ Payment Success");
            Navigator.pop(context);
            return NavigationDecision.prevent;
          } else if (url.contains("fail") || url.contains("error")) {
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