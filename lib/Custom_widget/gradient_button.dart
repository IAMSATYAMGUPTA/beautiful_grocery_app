import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget{
  final String title;
  final VoidCallback onTab;
  var width;
  bool loading;


  GradientButton({required this.title,required this.onTab,this.width=150.0,this.loading = false}){

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
          width: width,
          height: 50,
          child: Center(child: loading ? CircularProgressIndicator(color: Colors.white,strokeWidth: 3,) :
          Text(title,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lime.shade500, Colors.green],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          )
      ),
    );
  }

}