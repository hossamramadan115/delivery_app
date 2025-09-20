import 'package:flutter/material.dart';

class LoginSignupButton extends StatelessWidget {
  const LoginSignupButton({
    super.key,
    this.onTap,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
    this.isLoading = false,
  });

  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color iconColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const CircleBorder(), // يخلي الزرار دائري
          padding: EdgeInsets.zero, // يشيل أي فراغ
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                Icons.arrow_forward, // سهم ناحيه اليمين
                color: iconColor,
                size: 28,
              ),
      ),
    );
  }
}
