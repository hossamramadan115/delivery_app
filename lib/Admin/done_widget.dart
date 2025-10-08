import 'package:delivery/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoneWidget extends StatelessWidget {
  const DoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * .2),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.circleCheck,
                        color: Colors.white,
                      ),
                      SizedBox(width: context.screenWidth * .02),
                      Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: context.screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
  }
}