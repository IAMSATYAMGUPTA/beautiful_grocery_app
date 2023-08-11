import 'package:beautiful_grocery_app/Custom_widget/circle_icon_button.dart';
import 'package:beautiful_grocery_app/Custom_widget/gradient_button.dart';
import 'package:beautiful_grocery_app/Provider_Services/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItemPage extends StatefulWidget{
  @override
  State<CartItemPage> createState() => _CartItemPageState();
}

class _CartItemPageState extends State<CartItemPage> {

  var cartItemRef = FirebaseFirestore.instance.collection('Usernames');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var uid = user!.uid;
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [

            SizedBox(
                width: double.infinity,
                height: 90,
                child: Align(
                  alignment: Alignment(-0.9, 0.8),
                  child: Text("  Cart items",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 22,color: Colors.black),),
                )
            ),

            Positioned(
              left: 8,
              right: 8,
              top: 95,
              child: SizedBox(
                height: 420,
                child: StreamBuilder<QuerySnapshot>(
                  stream: cartItemRef.doc(uid).collection('CartItem').snapshots(),
                  builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.connectionState==ConnectionState.active){
                      if(snapshot.hasData){
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 5,),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6,left: 11,bottom: 5),
                              child: Card(
                                color: Colors.grey.shade50,
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.grey.shade200)
                                ),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [

                                      // item Image
                                      SizedBox(
                                        height: 90,
                                        width: 100,
                                        child: Image.network("${snapshot.data!.docs[index]["img"].toString()}"),
                                      ),
                                      SizedBox(width: 20,),

                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            // details
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${snapshot.data!.docs[index]["productName"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.black),),
                                                SizedBox(height: 2,),
                                                Text("${snapshot.data!.docs[index]["type"]}",style: TextStyle(fontSize: 15)),
                                                SizedBox(height: 13,),
                                                Row(
                                                  children: [
                                                    Text(r"$"+"${snapshot.data!.docs[index]["productPrice"].toString()} ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                                                    Text(snapshot.data!.docs[index]['dozen'].toString(),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500,fontSize: 15),)
                                                  ],
                                                ),
                                              ],
                                            ),

                                            // quantity
                                            Column(
                                              children: [
                                                IconCircleButton(iconColor: Colors.white,backGroundColor: Colors.green,icon : Icons.add),
                                                SizedBox(height: 4,),
                                                Text("1kg",),
                                                SizedBox(height: 4,),
                                                IconCircleButton(iconColor: Colors.green,backGroundColor: Colors.lightGreen.shade100,icon : Icons.remove),

                                              ],
                                            ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      else if(snapshot.hasError){
                        return Center(child: Text("An Error Occured"),);
                      }
                      else{
                        return Center(child: Text("No Data Found!!"));
                      }
                    }else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 6,
              right: 0,
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(23),topLeft: Radius.circular(23)),
                    borderSide: BorderSide(color: Colors.grey.shade100,width: 4)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<CartProvider>(
                    builder: (context, value, child) {
                      return Visibility(
                        visible: value.totalPrice.toStringAsFixed(2)== "0.00" ? false:true,
                        child: Column(
                          children: [
                            ReusableWidget(title: 'Sub Total', value: r"$"+value.totalPrice.toStringAsFixed(2),isBold: false),
                            ReusableWidget(title: 'Discount 10%',value: r"$"+"${(value.totalPrice*0.1).toStringAsFixed(2)}",isBold: false),
                            ReusableWidget(title: 'Total',value: r"$"+(value.totalPrice-(value.totalPrice*0.1)).toStringAsFixed(2),isBold: true),
                            SizedBox(height: 27,),
                            Container(
                                width: 300,
                                height: 43,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green.shade500,
                                ),
                                child: Center(child: Text("Checkout",style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),))
                            ),
                            SizedBox(height: 15,)
                          ],
                        ),
                      );
                    },)
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title,value;
  bool isBold;

  ReusableWidget({required this.title,required this.value,required this.isBold});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: TextStyle(fontSize: isBold ? 20:16,fontWeight: isBold ? FontWeight.bold:FontWeight.w400 ),),
          Text(value,style: TextStyle(fontSize: isBold ? 20:17,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}