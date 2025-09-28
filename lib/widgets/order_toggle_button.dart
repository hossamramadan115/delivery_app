import 'package:delivery/constsnt.dart';
import 'package:flutter/material.dart';
import 'package:delivery/utils/media_query_values.dart';

class OrderToggleButton extends StatelessWidget {
  final bool isCurrent;
  final ValueChanged<bool> onToggle;

  const OrderToggleButton({
    super.key,
    required this.isCurrent,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: context.screenHeight * 0.02,
        horizontal: context.screenWidth * 0.04,
      ),
      padding: EdgeInsets.all(context.screenWidth * 0.015),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                    vertical: context.screenHeight * 0.015),
                decoration: BoxDecoration(
                  color: isCurrent ? kMostUse : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Current",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isCurrent ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onToggle(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                    vertical: context.screenHeight * 0.015),
                decoration: BoxDecoration(
                  color: !isCurrent ? kMostUse : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Past",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: !isCurrent ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
