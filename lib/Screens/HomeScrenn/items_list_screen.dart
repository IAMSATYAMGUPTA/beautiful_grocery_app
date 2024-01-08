import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/Custom_widget/add_remove_button.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_event.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_state.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_model.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/Like%20Bloc/like_bloc.dart';
import 'package:beautiful_grocery_app/Screens/Like%20Item/like_model.dart';
import 'package:beautiful_grocery_app/Services/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ItemPageScreen extends StatefulWidget {
  const ItemPageScreen({Key? key}) : super(key: key);

  @override
  State<ItemPageScreen> createState() => _ItemPageScreenState();
}

class _ItemPageScreenState extends State<ItemPageScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  final databaseRef = FirebaseFirestore.instance.collection("groceryProduct");

  // seaching work
  var searchFilter = TextEditingController();
  String searchQuery = "";
  var arrData;

  // set colors to show list items
  final List colorList = [Colors.lightGreen.shade100,Colors.lightBlue.shade100,
    Colors.orangeAccent.shade100,Colors.red.shade100,
    Colors.purple.shade100,Colors.lime.shade100];

  // Create an empty list to store the data
  var uid;
  List<Map<String, dynamic>> likeItemsList = [];
  List<Map<String, dynamic>> cartItemsList = [];

  @override
  void initState(){
    super.initState();
    User? user = auth.currentUser;
    uid = user!.uid;
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


  @override
  Widget build(BuildContext context) {
    final Map<dynamic,dynamic> itemCategory = ModalRoute.of(context)!.settings.arguments as Map<dynamic,dynamic>;
    var category = itemCategory['name'];
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(18, 15, 16, 1),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    // margin: EdgeInsets.fromLTRB(13,10,13,4),
                    height : 50,
                    child: TextFormField(
                      controller: searchFilter,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(top: 6,left: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (value){
                        searchQuery=value.toLowerCase();
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: databaseRef.where('categories',isEqualTo: category).snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.connectionState==ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator(),);
                        } else if(snapshot.hasError){
                          return Center(child: Text(snapshot.error.toString()),);
                        }
                        else if(snapshot.hasData){

                          List<QueryDocumentSnapshot<Map<String, dynamic>>> books = snapshot.data!.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

                          for(QueryDocumentSnapshot data in books){
                            arrData = data['items'];
                          }
                          // print(arrData);
                          // print("#################################");
                          // Filter books based on the search query
                          var filteredBooks = arrData
                              .where((element) =>
                              element['name'].toString().toLowerCase().contains(searchQuery))
                              .toList();

                          return filteredBooks.isEmpty ? Center(
                            child: Center(child: Text("No matching books found.")),
                          ) :
                          BlocBuilder<CartBloc,CartState>(
                            builder: (context, state) {
                              if(state is CartLoadingState){
                                return Center(child: CircularProgressIndicator(),);
                              }
                              else if(state is CartLoadedState){
                                cartItemsList = state.cartItemList;
                                String id = snapshot.data!.docs[0].id;
                                return GridView.builder(
                                  padding: EdgeInsets.only(left: 6,right: 0,top: 2),
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 13,
                                    childAspectRatio: 9/12.3,
                                  ),
                                  itemCount: arrData.length,
                                  itemBuilder: (context, index) {

                                    if (index >= filteredBooks.length) {
                                      // Prevent accessing an invalid index
                                      return SizedBox.shrink(); // Return an empty widget if index is out of bounds
                                    }

                                    String image = filteredBooks[index]['img'].toString();
                                    String name = filteredBooks[index]['name'].toString();
                                    String dozen = filteredBooks[index]['dozen'].toString();
                                    String price = filteredBooks[index]['price'].toString();
                                    String mPrice = filteredBooks[index]['oldprice'].toString();
                                    bool? isCart;
                                    if(containsEqualName(cartItemsList,name)){
                                      isCart = true;
                                    }else{
                                      isCart = false;
                                    }
                                    return Stack(
                                      children: [

                                        // show all items
                                        Card(
                                          elevation: 5,
                                          shape: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              borderSide: BorderSide(color: Colors.grey)
                                          ),
                                          child: Container(
                                            height: 210,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              color: colorList[index % colorList.length],
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, "/itemdisplay",arguments: {
                                                      'id' : id,
                                                      'img' : image,
                                                      'name' : name,
                                                      'price' : price,
                                                      'oldprice' : mPrice,
                                                      'dozen': dozen,
                                                      'type': category
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 120,
                                                    child: Container(margin: EdgeInsets.only(top: 4,right: 8),
                                                        height:110,width:110,child: Image.network(image)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 80,
                                                  width: 140,
                                                  color: Colors.grey.shade100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(name+" ${dozen}"),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text(r"$"+price),
                                                                Text(mPrice),
                                                              ],
                                                            ),

                                                            AddRemoveButton(
                                                              height: 26.0,
                                                              color: isCart ? Colors.red.shade300:Colors.green.shade400,
                                                              width: isCart ?70.0:50.0,
                                                              title: isCart ? "Remove":"ADD",
                                                              onTap: (){
                                                                if(isCart!){
                                                                  context.read<CartBloc>().add(DeleteCartItem(id: id));
                                                                  context.read<CartProvider>().decrementCount();
                                                                  context.read<CartProvider>().removeTotalPrice(double.parse(price));
                                                                }else{
                                                                  context.read<CartBloc>().add(AddCartItem(
                                                                    cartItem: CartModel(
                                                                        id: id,
                                                                        img: image,
                                                                        initialPrice: price,
                                                                        totalProductPrice: price,
                                                                        quantity: 1,
                                                                        productName: name,
                                                                        dozen: dozen,
                                                                        type: category
                                                                    ),
                                                                  ));
                                                                  context.read<CartProvider>().incrementCount();
                                                                  context.read<CartProvider>().addTotalPrice(double.parse(price));
                                                                }

                                                              },
                                                            ),



                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // manage like item and save item
                                        BlocBuilder<LikeBloc,LikeState>(
                                          builder: (context, state) {
                                            if(state is LikeLoadedState){
                                              likeItemsList = state.likeItemList;
                                              bool? isLike;
                                              if(containsEqualName(likeItemsList,name)){
                                                isLike = false;
                                              }else{
                                                isLike = true;
                                              }
                                              return Container(
                                                  margin: EdgeInsets.only(top: 5,left: 100),
                                                  height:40,
                                                  width:40,
                                                  child: InkWell(
                                                    onTap: (){
                                                      if(!isLike!){
                                                        context.read<LikeBloc>().add(DeleteLikeItem(id: id));
                                                      }else{
                                                        context.read<LikeBloc>().add(AddLikeItem(
                                                            likeItem: LikeModel(
                                                                id: id,
                                                                img: image,
                                                                price: price,
                                                                oldprice: mPrice,
                                                                productName: name,
                                                                dozen: dozen,
                                                                type: category
                                                            )));
                                                      }
                                                    },
                                                    child: Icon(Icons.favorite,size: 25,color: isLike? Colors.grey:Colors.red),
                                                  )
                                              );
                                            }
                                            return Container();
                                          },
                                        ),


                                      ],
                                    );
                                  },);
                              }
                              return Container();

                            },
                          );

                        }
                        return Container();
                      },),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }


}
