import 'package:delivery/utils/app_styless.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    this.buttonColor,
    this.style,
  });

  final Function()? onTap;
  final String text;
  final Color? buttonColor;
  final TextStyle? style;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.buttonColor ?? Colors.blue;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.95 : 1.0), // الضغط يدي إحساس بالعمق
        decoration: BoxDecoration(
          color: _isPressed
              ? baseColor.withOpacity(0.85) // أغمق شوية عند الضغط
              : baseColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.07,
          vertical: context.screenHeight * 0.018,
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: widget.style ??
                AppStyless.styleWhiteBold22.copyWith(
                  color: _isPressed ? Colors.white70 : Colors.white,
                ),
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
