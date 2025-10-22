import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_custom_dialog.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:delivery/widgets/custom_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kMostUse, // اللون الخلفي الأساسي
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // لون الأيقونات داخل AppBar
          ),
          backgroundColor: kMostUse,
          title: Text(
            'Admin Home Page',
            style: AppStyless.styleWhiteBold22,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight * 0.015),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  width: screenWidth,
                  color: kPrimaryColor, // خلفية داخلية فاتحة
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenWidth * 0.1),
                      Image.asset(
                        Assets.kAdmin,
                        height: screenHeight * .2,
                      ),
                      SizedBox(height: screenWidth * 0.1),
                      CustomListTile(
                        icon: Icons.local_shipping_outlined,
                        title: 'Admin Pending Order',
                        onTap: () {
                          GoRouter.of(context)
                              .push(AppRouter.kAdminPendingOrder);
                        },
                      ),
                      SizedBox(height: screenWidth * 0.08),
                      CustomListTile(
                        icon: Icons.local_shipping_outlined,
                        title: 'Manage Orders',
                        onTap: () {
                          GoRouter.of(context).push(AppRouter.kOrderAdmin);
                        },
                      ),
                      SizedBox(height: screenWidth * 0.08),
                      CustomListTile(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        onTap: () async {
                          showCustomDialog(
                            context: context,
                            title: "Sign Out",
                            content: "Are you sure you want to sign out?",
                            confirmText: "Sign Out",
                            onConfirm: () async {
                              final prefs = SharedPreferencesHelper();
                              final isAdmin =
                                  await prefs.getIsAdminLoggedIn() ?? false;
                              if (isAdmin) {
                                await prefs.clearAdminLogin();
                              } else {
                                await FirebaseAuth.instance.signOut();
                                await prefs.clearPrefs();
                              }
                              GoRouter.of(context).go(AppRouter.kOrderAdmin);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
