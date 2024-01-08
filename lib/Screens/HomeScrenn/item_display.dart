import 'package:beautiful_grocery_app/Custom_widget/circle_icon_button.dart';
import 'package:beautiful_grocery_app/Custom_widget/gradient_button.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_event.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_state.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_model.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/Like%20Bloc/like_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/like_model.dart';
import 'package:beautiful_grocery_app/Services/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDisplayPage extends StatefulWidget {
  const ItemDisplayPage({Key? key}) : super(key: key);

  @override
  State<ItemDisplayPage> createState() => _ItemDisplayPageState();
}

class _ItemDisplayPageState extends State<ItemDisplayPage> {

  var auth = FirebaseAuth.instance;
  var firestoreRef = FirebaseFirestore.instance.collection("Usernames");

  @override
  Widget build(BuildContext context) {
    User user = auth.currentUser!;
    var uID = user.uid;
    final Map<String,dynamic> displayItem = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic> ;
    return Scaffold(
      body: BlocBuilder<CartBloc,CartState>(
          builder: (context, state) {
            if(state is CartLoadingState){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is CartLoadedState){
              var cartItemsList = state.cartItemList;
              bool? isLike;
              bool? isCart;
              if(containsEqualName(likeItemsList,displayItem['name'])){
                isLike = false;
              }else{
                isLike = true;
              }
              if(containsEqualName(cartItemsList,displayItem['name'])){
                isCart = true;
              }else{
                isCart = false;
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 330,
                      decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(180, 75),bottomRight: Radius.elliptical(180, 75))
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10,40,10,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: (){Navigator.pop(context);},
                                  child: Card(
                                    shape: CircleBorder(),
                                    elevation: 3,
                                    child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.keyboard_backspace,color: Colors.black,)),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Card(
                                      shape: CircleBorder(),
                                      elevation: 3,
                                      child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.shopping_bag_outlined,color: Colors.black,)),
                                    ),
                                    SizedBox(height: 5,),
                                    BlocBuilder<LikeBloc,LikeState>(
                                      builder: (context, state) {
                                        if(state is LikeLoadedState){
                                          likeItemsList = state.likeItemList;
                                          bool? isLike;
                                          if(containsEqualName(likeItemsList,displayItem['name'])){
                                            isLike = false;
                                          }else{
                                            isLike = true;
                                          }
                                          return InkWell(
                                            onTap: (){
                                              if(!isLike!){
                                                context.read<LikeBloc>().add(DeleteLikeItem(id: displayItem['id']));
                                              }else{
                                                context.read<LikeBloc>().add(AddLikeItem(
                                                    likeItem: LikeModel(
                                                        id: displayItem['id'],
                                                        img: displayItem['img'],
                                                        price: displayItem['price'],
                                                        oldprice: displayItem['oldprice'],
                                                        productName: displayItem['name'],
                                                        dozen: displayItem['dozen'],
                                                        type: displayItem['type'])
                                                ));
                                              }
                                              },
                                            child: Card(
                                              shape: CircleBorder(),
                                              elevation: 3,
                                              child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.favorite,color: isLike ? Colors.grey:Colors.red,)),
                                            ),
                                          );
                                        }
                                        return Container();
                                        },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 100,left: 80),
                            height: 200,
                            width: 200,
                            child: Image.network(displayItem['img']),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 18,),
                    Container(
                        margin: EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(displayItem['name'],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                Text(displayItem['price']+".00",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 17,),
                            Row(
                              children: [
                                SizedBox(
                                    height: 30,
                                    width: 100,
                                    child: Image.asset("assets/images/itemdisplay/displaystar.png")
                                ),
                                SizedBox(width: 145,),
                                IconCircleButton(iconColor: Colors.green,backGroundColor: Colors.lightGreen.shade100,icon : Icons.remove),
                                Text("  1kg  ",style: TextStyle(fontWeight: FontWeight.w500),),
                                IconCircleButton(iconColor: Colors.white,backGroundColor: Colors.green,icon : Icons.add),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Divider(color: Colors.grey,),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(right: 208.0,bottom: 10),
                              child: Text('Description',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                            ),
                            ExpandableText('apple, (Malus domestica), domesticated tree and fruit of the rose family (Rosaceae), one of the most widely'
                                ' cultivated tree fruits. Apples are predominantly grown for sale as fresh fruit, though apples are also used '
                                'commercially for vinegar, juice, jelly, applesauce, and apple butter and are canned as pie stock. A significant '
                                'portion of the global crop also is used for cider, wine, and brandy. Fresh apples are eaten raw or cooked. There '
                                'are a variety of ways in which cooked apples are used; frequently, they are used as a pastry filling, apple pie'
                                ' being perhaps the archetypal American dessert. Especially in Europe, fried apples characteristically accompany '
                                'certain dishes of sausage or pork. Apples provide vitamins A and C, are high in carbohydrates, and are an excellent '
                                'source of dietary fibre.',
                              expandText: 'show more',
                              collapseText: 'show less',
                              maxLines: 3,
                              linkColor: Colors.blue,
                            ),
                            SizedBox(height: 15,),
                            Divider(color: Colors.grey,),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(right: 229.0,bottom: 8),
                              child: Text('Return Time',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            ),
                            Text("After received the product within one hour                  "),
                            SizedBox(height: 15,),
                            Divider(color: Colors.grey,),
                            SizedBox(height: 10,),
                            GradientButton(
                                width: 400.0,
                                title: isCart? "Remove To Cart":"Add To Cart",
                                isColor: isCart? true:false,
                                onTab: (){
                                  if(isCart!){
                                    context.read<CartBloc>().add(DeleteCartItem(id: displayItem['id']));
                                    context.read<CartProvider>().decrementCount();
                                    context.read<CartProvider>().removeTotalPrice(double.parse(displayItem['price']));
                                  }else{
                                    context.read<CartBloc>().add(AddCartItem(
                                      cartItem: CartModel(
                                          id: displayItem['id'],
                                          img: displayItem['img'],
                                          initialPrice: displayItem['price'],
                                          totalProductPrice: displayItem['price'],
                                          quantity: 1,
                                          productName: displayItem['name'],
                                          dozen: displayItem['dozen'],
                                          type: displayItem['type']
                                      ),
                                    ));
                                    context.read<CartProvider>().incrementCount();
                                    context.read<CartProvider>().addTotalPrice(double.parse(displayItem['price']));
                                  }
                                }
                            )
                          ],
                        )
                    )

                  ],
                ),
              );
            }
            else if(state is CartErrorState){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Please Check your \nInternet Connection",style: TextStyle(fontSize: 18,fontFamily: GoogleFonts.openSans().fontFamily),),
                    OutlinedButton(onPressed: (){setState(() {});}, child: Text("Try Again"))
                  ],
                ),
              );
            }
            return Container();
          },
      ),
    );
  }

  bool containsEqualName(
      List<Map<dynamic, dynamic>> list, String name) {
    for (var map in list) {
      if (map['productName'] == name) {
        return true;
      }
    }
    return false;
  }

  List<Map<String, dynamic>> likeItemsList = [];

}
