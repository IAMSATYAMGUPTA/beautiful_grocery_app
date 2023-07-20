import 'package:beautiful_grocery_app/HomeScrenn/Screen2.dart';
import 'package:beautiful_grocery_app/HomeScrenn/Screen3.dart';
import 'package:beautiful_grocery_app/HomeScrenn/Cart_item.dart';
import 'package:beautiful_grocery_app/HomeScrenn/user_account.dart';
import 'package:beautiful_grocery_app/HomeScrenn/home_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class ManageBottonNav extends StatefulWidget{
  @override
  State<ManageBottonNav> createState() => _ManageBottonNavState();
}

class _ManageBottonNavState extends State<ManageBottonNav> {
  int _selectedItem = 2;
  var _pagesData = [Screen2(),Screen3(),HomeScreenPage(),CartItemPage(),Screen5()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pagesData[_selectedItem],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          color: Colors.green,
          buttonBackgroundColor: Colors.green,
          height: 55,
          backgroundColor: Colors.grey.shade100,
          index: _selectedItem ,
          onTap: (index){
            setState(() {
              _selectedItem = index;
            });
          },
          items: [

            //-----------------------------Offer--------------------------------
            _selectedItem.toString().contains("0") ? CustomIcon(icon: Icons.local_offer_outlined)
                :Icon(Icons.local_offer_outlined,size: 30,color: Colors.white),


            //-----------------------------Order--------------------------------
            _selectedItem.toString().contains("1") ? CustomIcon(icon: Icons.history)
                :Icon(Icons.work_history_outlined,size: 30,color: Colors.white),


            //-----------------------------Home--------------------------------
            _selectedItem.toString().contains("2") ? CustomIcon(icon: Icons.home_outlined)
                :Icon(Icons.home_outlined,size: 35,color: Colors.white),


            //----------------------------CartItem-------------------------------
            _selectedItem.toString().contains("3") ? CustomIcon(icon: Icons.add_shopping_cart_outlined)
                :Icon(Icons.add_shopping_cart_outlined,size: 30,color: Colors.white),


            //----------------------------Account--------------------------------
            _selectedItem.toString().contains("4") ? CustomIcon(icon: Icons.person)
                :Icon(Icons.person,size: 30,color: Colors.white),

          ]),
    );
  }
  //-----------------------Custom Icon ----------------------
  Widget CustomIcon({required IconData icon ,var size=25.0}){
    return CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon,size: size,color: Colors.green,));
  }

}