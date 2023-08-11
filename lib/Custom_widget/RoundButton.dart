import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget{
  final String title;
  final VoidCallback onTab;
  var width;
  var height;
  Color color;


  RoundButton({required this.title,required this.onTab,this.width=65.0,this.height=24.0,this.color=Colors.white}){

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
          width: width,
          height: height,
          child: Center(child: Text(title,style: TextStyle(color: Colors.lightGreen.shade300,fontSize: 14,fontWeight: FontWeight.bold,),)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.lightGreen.shade300,width: 2),
            color: color
          )
      ),
    );
  }

}