import 'package:beautiful_grocery_app/HomeScrenn/items_list_screen.dart';
import 'package:beautiful_grocery_app/Provider_Services/cart_provider.dart';
import 'package:beautiful_grocery_app/Splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:beautiful_grocery_app/HomeScrenn/item_display.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashSreenPage(),
      routes: {
        "/itempage" : (context) => ItemPageScreen(),
        "/itemdisplay" : (context) => ItemDisplayPage(),
      },
    );
  }
}