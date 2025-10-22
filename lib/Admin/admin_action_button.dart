// يمكن وضع هذا الـ Widget في ملف مستقل أو في نفس الملف مؤقتاً

import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class AdminActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const AdminActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = context.screenWidth * 0.04;

    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.018),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}