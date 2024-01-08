import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_bloc.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/item_display.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/items_list_screen.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/Like%20Bloc/like_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Splash_screen/splash_screen.dart';
import 'package:beautiful_grocery_app/Services/cart_provider.dart';
import 'package:beautiful_grocery_app/Services/user_detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      BlocProvider<UserDetailCubit>(
        create: (context) => UserDetailCubit(),
      ),

      BlocProvider<CartBloc>(
        create: (context) => CartBloc(),
      ),

      BlocProvider<LikeBloc>(
        create: (context) => LikeBloc(),
      ),

      ChangeNotifierProvider(
        create: (context) => CartProvider(),
      ),
    ],
    child: const MyApp(),
  ),);
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