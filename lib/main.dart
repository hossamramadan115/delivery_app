import 'package:delivery/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    DeliveryApp(),
  );
}

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
