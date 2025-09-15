import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:delivery/utils/app_styless.dart';

class CustomDelivers extends StatelessWidget {
  const CustomDelivers({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Image.asset(
              imagePath,
              height: context.screenHeight * 0.1,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 7,
            child: Column(
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyless.styleBold28
                      .copyWith(fontSize: context.screenWidth * 0.05),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyless.styleWhite13.copyWith(
                    color: Colors.black54,
                    fontSize: context.screenWidth * 0.035,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
