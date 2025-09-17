import 'package:delivery/constsnt.dart';
import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';

class PickupDetails extends StatelessWidget {
  const PickupDetails({
    super.key,
    this.hintText,
    this.icon,
  });

  final String? hintText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kMostUse, size: context.screenHeight * .023),
        SizedBox(width: context.screenWidth * .03),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.black54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
