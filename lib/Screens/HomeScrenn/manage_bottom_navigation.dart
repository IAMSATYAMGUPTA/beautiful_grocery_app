import 'package:beautiful_grocery_app/Screens/Cart%20Item/Cart_item.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_bloc.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/Screen2.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/home_dart.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/user_account.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/Like%20Bloc/like_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/like_items.dart';
import 'package:beautiful_grocery_app/Services/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

class ManageBottonNav extends StatefulWidget{
  @override
  State<ManageBottonNav> createState() => _ManageBottonNavState();
}

class _ManageBottonNavState extends State<ManageBottonNav> {
  int _selectedItem = 2;
  var _pagesData = [Screen2(),LikeItemsPage(),HomeScreenPage(),CartItemPage(),Screen5()];

  @override
  void initState() {
    super.initState();
    getCounter();
    getCartList();
    getLikeList();
  }

  void getCounter(){
    Provider.of<CartProvider>(context,listen: false).fetchCartData();
  }

  void getCartList(){
    context.read<CartBloc>().GetCartItemListEvent();
  }

  void getLikeList(){
    context.read<LikeBloc>().getLikeList();
  }

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
            _selectedItem.toString().contains("1") ? CustomIcon(icon: Icons.favorite_border)
                :Icon(Icons.favorite_border,size: 30,color: Colors.white),


            //-----------------------------Home--------------------------------
            _selectedItem.toString().contains("2") ? CustomIcon(icon: Icons.home_outlined)
                :Icon(Icons.home_outlined,size: 35,color: Colors.white),


            //----------------------------CartItem-------------------------------
            _selectedItem.toString().contains("3") ? CustomIcon(icon: Icons.add_shopping_cart_outlined)
                :badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.counter.toString(),style: TextStyle(color: Colors.white),);
                },
              ),
              child: Icon(Icons.add_shopping_cart_outlined,size: 30,color: Colors.white),
              badgeAnimation: badges.BadgeAnimation.rotation(animationDuration: Duration(milliseconds: 300)),
            ),


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