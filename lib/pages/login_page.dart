import 'package:delivery/Admin/admin_button.dart';
import 'package:delivery/constsnt.dart';
import 'package:delivery/helper/show_snack_bar.dart';
import 'package:delivery/services/auth_service.dart';
import 'package:delivery/services/database_service.dart';
import 'package:delivery/services/shared_preferences_helper.dart';
import 'package:delivery/utils/app_router.dart';
import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/assets.dart';
import 'package:delivery/widgets/custom_text_button.dart';
import 'package:delivery/widgets/custom_text_form_field.dart';
import 'package:delivery/widgets/login_signup_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();

  void loginMethod() async {
  if (!formKey.currentState!.validate()) return;

  if (!mounted) return;
  setState(() => isLoading = true);

  try {
    final user = await AuthService().login(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    if (user != null) {
      final snapshot = await DatabaseMethods().getUserByEmail(email.text.trim());

      if (snapshot != null) {
        final userData = snapshot.data() as Map<String, dynamic>;

        await SharedPreferencesHelper().saveUserEmail(userData["email"]);
        await SharedPreferencesHelper().saveUserId(userData["id"]);
        await SharedPreferencesHelper().saveUserName(userData["name"]);
        await SharedPreferencesHelper().saveUserImage(userData["image"]);
      }

      if (!mounted) return; // ✅ قبل أي استخدام لـ context
      showSuccessSnack(context, "Welcome back 👋");

      // التنقل لازم يكون آخر خطوة
      context.go(AppRouter.kBottomBar);
      return; // ✅ عشان ما يكملش ل finally بعد كده
    }
  } catch (e) {
    if (!mounted) return; // ✅
    showErrorSnack(context, e.toString());
  } finally {
    if (!mounted) return; // ✅
    setState(() => isLoading = false);
  }
}


  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        bottom: 1, // مسافة بسيطة من تحت
                        left: width * 0.08, // نفس الـ padding الجانبي
                        child: Text(
                          'Welcome\nBack',
                          style: TextStyle(
                            fontSize: width * 0.1, // حجم خط كبير
                            height: 1.2,
                            color: kLoginColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                          'Email',
                          style: AppStyless.styleSemiBold28.copyWith(
                            fontSize: width * 0.045,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        CustomTextFormField(
                          controller: email,
                          hintText: 'Email',
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
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
                          validator: (data) {
                            if (data == null || data.isEmpty) {
                              return 'field is required';
                            }
                            return null;
                          },
                          obscureText: true,
                        ),
                        SizedBox(height: height * 0.009),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forget password',
                            style: TextStyle(
                              color: kSignupcolor,
                              fontSize: width * 0.038,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025),
                        Row(
                          children: [
                            Text(
                              'Sign in',
                              style: AppStyless.styleSemiBold28,
                            ),
                            Spacer(),
                            LoginSignupButton(
                              backgroundColor: kLoginColor, // لون داكن
                              isLoading: isLoading,
                              onTap: () async {
                                formKey.currentState!.validate();
                                loginMethod();
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create new account...',
                              style: TextStyle(
                                fontSize: width * 0.04,
                              ),
                            ),
                            CustomTextButton(
                              text: 'Sign Up',
                              onPressed: () {
                                GoRouter.of(context)
                                    .push(AppRouter.kSignupPage);
                              },
                            ),
                          ],
                        ),
                        // Center(child: AdminButton()),
                        // SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
                Center(child: AdminButton()),
                SizedBox(height: height * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }
}
