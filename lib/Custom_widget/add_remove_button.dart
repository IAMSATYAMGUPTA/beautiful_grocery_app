import 'package:flutter/material.dart';

class AddRemoveButton extends StatelessWidget{
  String title;
  VoidCallback onTap;
  double width;
  double height;
  Color color;
  AddRemoveButton({required this.title,required this.onTap,this.width=110.0,this.color=Colors.lightGreen,this.height=35.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Center(child: Text(title,style: TextStyle(color: Colors.white),),),
      ),
    );
  }
}