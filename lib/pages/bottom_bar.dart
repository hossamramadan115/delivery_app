import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/pages/home_page.dart';
import 'package:delivery/pages/orders_page.dart';
import 'package:delivery/pages/post_page.dart';
import 'package:delivery/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int selected = 0;

  final List<Widget> pageList = [
    const HomePage(),
    const PostPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final navBarHeight = screenHeight * 0.06;
    final iconSize = screenWidth * 0.08;

    return SafeArea(
      top: true,
      left: false,
      right: false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        body: pageList[selected],
        bottomNavigationBar: CurvedNavigationBar(
          index: selected,
          height: navBarHeight,
          backgroundColor: kPrimaryColor,
          color: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              selected = index;
            });
          },
          items: [
            Icon(Icons.home, size: iconSize, color: Colors.white),
            Icon(Icons.note_add, size: iconSize, color: Colors.white),
            Icon(Icons.shopping_bag, size: iconSize, color: Colors.white),
            Icon(Icons.person, size: iconSize, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
