import 'dart:async';

import 'package:beautiful_grocery_app/HomeScrenn/home_dart.dart';
import 'package:beautiful_grocery_app/HomeScrenn/manage_bottom_navigation.dart';
import 'package:beautiful_grocery_app/User%20_Entry_Verification/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashSreenPage extends StatefulWidget {
  const SplashSreenPage({Key? key}) : super(key: key);

  @override
  State<SplashSreenPage> createState() => _SplashSreenPageState();
}

class _SplashSreenPageState extends State<SplashSreenPage> {

  @override
  void initState() {
    super.initState();

    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    Timer(Duration(seconds: 2), () {
      if(user!=null){
        Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.rightToLeftWithFade, child: ManageBottonNav(),duration: Duration(seconds: 1)));
      }
      else{
        Navigator.pushReplacement(context, PageTransition(
            type: PageTransitionType.rightToLeftWithFade, child: LoginScreenPage(),duration: Duration(seconds: 1)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: 400,height: double.infinity,
      child: Image(fit: BoxFit.cover,image: AssetImage("assets/images/splash_screen/splashscreen.png"))),
    );
  }
}
