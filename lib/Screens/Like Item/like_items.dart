import 'package:beautiful_grocery_app/Custom_widget/add_remove_button.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_event.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_state.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_model.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/Like%20Bloc/like_bloc.dart';
import 'package:beautiful_grocery_app/Services/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikeItemsPage extends StatefulWidget{
  @override
  State<LikeItemsPage> createState() => _LikeItemsPageState();
}

class _LikeItemsPageState extends State<LikeItemsPage> {


  final FirebaseAuth auth = FirebaseAuth.instance;

  final firestore = FirebaseFirestore.instance.collection("Usernames");

  List<Map<String, dynamic>> cartItemsList = [];


  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    var uid = user!.uid;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [

          //--------------- SET TITLE--------------------------------
          SizedBox(
            width: double.infinity,
            height: 90,
            child: Align(
              alignment: Alignment(-0.9, 0.8),
              child: Text("Favourite items",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),),
            )
          ),


          // ------------SHOW LIST  ITEM-----------------------------
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.doc(uid).collection("likesItem").snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return Text("........... Error..........");
                }
                else{
                  return BlocBuilder<CartBloc,CartState>(
                      builder: (context, state) {
                        if(state is CartLoadingState){
                        return Center(child: CircularProgressIndicator(),);
                        }
                        else if(state is CartLoadedState) {
                          cartItemsList = state.cartItemList;

                          return ListView.builder(
                            padding: EdgeInsets.only(top: 4),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {


                              bool? isCart;
                              if(containsEqualName(cartItemsList,snapshot.data!.docs[index]['productName'])){
                                isCart = true;
                              }else{
                                isCart = false;
                              }

                              return Card(
                                margin: EdgeInsets.fromLTRB(13, 7, 7, 7),
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade400)
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(height: 100, width: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  9.0),
                                              child: Image.network(snapshot.data!.docs[index]['img'].toString()),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(snapshot.data!.docs[index]['productName'].toString(),
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                    InkWell(
                                                        onTap: () {
                                                          context.read<LikeBloc>().add(DeleteLikeItem(id: snapshot.data!.docs[index]['id'].toString()));
                                                        },
                                                        child: Icon(
                                                            Icons.delete)),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Text("MRP " + snapshot.data!.docs[index]['oldprice'].toString(),
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [

                                                    Text(r"$" + snapshot.data!.docs[index]['price'].toString() + " ${snapshot.data!.docs[index]['dozen']}",
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),

                                                    AddRemoveButton(
                                                      height: 26.0,
                                                      color: isCart ? Colors.red.shade300:Colors.green.shade400,
                                                      width: isCart ?70.0:50.0,
                                                      title: isCart ? "Remove":"ADD",
                                                      onTap: (){
                                                        if(isCart!){
                                                          context.read<CartBloc>().add(DeleteCartItem(id: snapshot.data!.docs[index]['id'].toString()));
                                                          context.read<CartProvider>().decrementCount();
                                                          context.read<CartProvider>().removeTotalPrice(double.parse(snapshot.data!.docs[index]['price'].toString()));
                                                        }else{
                                                          context.read<CartBloc>().add(AddCartItem(
                                                            cartItem: CartModel(
                                                                id: snapshot.data!.docs[index]['id'].toString(),
                                                                img: snapshot.data!.docs[index]['img'].toString(),
                                                                initialPrice: snapshot.data!.docs[index]['price'].toString(),
                                                                totalProductPrice: snapshot.data!.docs[index]['price'].toString(),
                                                                quantity: 1,
                                                                productName: snapshot.data!.docs[index]['productName'].toString(),
                                                                dozen: snapshot.data!.docs[index]['dozen'].toString(),
                                                                type: snapshot.data!.docs[index]['type'].toString()
                                                            ),
                                                          ));
                                                          context.read<CartProvider>().incrementCount();
                                                          context.read<CartProvider>().addTotalPrice(double.parse(snapshot.data!.docs[index]['price'].toString()));
                                                        }

                                                      },
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }else{
                          return Center(child: Text("No data Found"),);
                        }
                      },
                  );
                }
              },
            ),
          ),

          // --------------show prices-------------------------------
          Card(

          )

        ],
      ),
    );
  }

  bool containsEqualName(List<Map<dynamic, dynamic>> list, String name) {
    for (var map in list) {
      if (map['productName'] == name) {
        return true;
      }
    }
    return false;
  }

}