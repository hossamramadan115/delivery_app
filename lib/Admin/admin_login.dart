import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_snack_bar.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:delivery/widgets/login_signup_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  bool isLoading = false;
  final userName = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> loginAdmin() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Admin")
          .where("username", isEqualTo: userName.text.trim())
          .where("password", isEqualTo: password.text.trim())
          .get();

      if (snapshot.docs.isNotEmpty) {
        await SharedPreferencesHelper().saveIsAdminLoggedIn(true);
        showSuccessSnack(context, 'Welcome Admin 👑');
        GoRouter.of(context).go(AppRouter.kAdminHomePage);
      } else {
        showErrorSnack(context, "Invalid username or password");
      }
    } catch (e) {
      showErrorSnack(context, "Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF3ECE8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- الصورة والنص فوقها ----------
                SizedBox(
                  height: height * 0.4,
                  width: width,
                  child: Stack(
                    children: [
                      Image.asset(
                        Assets.kLoginSignup,
                        fit: BoxFit.cover,
                        width: width,
                        height: height * 0.4,
                      ),
                      Positioned(
                        bottom: 1,
                        left: width * 0.08,
                        child: Text(
                          'Admin\nPanel',
                          style: TextStyle(
                            fontSize: width * 0.1, // حجم خط كبير
                            height: 1.2,
                            color: kLoginColor,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ---------- باقي المحتوى ----------
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: height * 0.02,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.03),
                        Text(
                          'Username',
                          style: AppStyless.styleSemiBold28.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: userName,
                          hintText: 'Username',
                          validator: (data) =>
                              data == null || data.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          'Password',
                          style: AppStyless.styleSemiBold28.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          obscureText: true,
                          validator: (data) =>
                              data == null || data.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: height * 0.05),
                        Row(
                          children: [
                            Text(
                              'Sign in',
                              style: AppStyless.styleSemiBold28,
                            ),
                            const Spacer(),
                            LoginSignupButton(
                              backgroundColor: kLoginColor,
                              isLoading: isLoading,
                              onTap: () async {
                                formKey.currentState!.validate();
                                loginAdmin();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
