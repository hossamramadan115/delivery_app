import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_snack_bar.dart';
import 'package:delivery/services/auth_service.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_text_button.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:delivery/widgets/login_signup_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_string/random_string.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  String id = randomAlphaNumeric(10);

  void signUpMethod() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService().signUp(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        id: id,
      );

      await SharedPreferencesHelper().saveUserEmail(email.text.trim());
      await SharedPreferencesHelper().saveUserId(id);
      await SharedPreferencesHelper().saveUserName(name.text.trim());
      await SharedPreferencesHelper().saveUserImage("");
      showSuccessSnack(context, "Account created successfully 🎉");
      context.go(AppRouter.kBottomBar);
    } catch (e) {
      showErrorSnack(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3ECE8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        bottom: height * 0.008, // مسافة بسيطة من تحت
                        left: width * 0.08, // نفس الـ padding الجانبي
                        child: Text(
                          'Create\nAccount',
                          style: TextStyle(
                            fontSize: width * 0.1, // حجم خط كبير
                            height: 1.2,
                            color: kSignupcolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.08, // زيادة الهامش الأفقي
                    // vertical: height * 0.02,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        CustomTextFormField(
                          controller: name,
                          hintText: 'Name',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: email,
                          hintText: 'Email',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            } else if (!data.contains('@') || data.length < 7) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            } else if (data.length < 7) {
                              return 'must be at least 7 characters';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: height * 0.05),
                        Row(
                          children: [
                            Text(
                              'Sign up',
                              style: AppStyless.styleSemiBold28,
                            ),
                            Spacer(),
                            LoginSignupButton(
                              backgroundColor: kSignupcolor, // لون داكن
                              isLoading: isLoading,
                              onTap: () async {
                                !formKey.currentState!.validate();
                                signUpMethod();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black,
                              ),
                            ),
                            CustomTextButton(
                              text: 'Sign in', // تغيير النص ليتناسب مع الصورة
                              onPressed: () {
                                GoRouter.of(context).push(AppRouter.kLoginPage);
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
