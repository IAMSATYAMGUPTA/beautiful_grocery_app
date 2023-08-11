import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  Color iconColor,backGroundColor;
  IconData? icon;
  IconCircleButton({required this.iconColor,required this.backGroundColor,required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: backGroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,color: iconColor,),
      ),
    );
  }
}
