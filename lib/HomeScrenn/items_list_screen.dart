import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/Provider_Services/cart_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class ItemPageScreen extends StatefulWidget {
  const ItemPageScreen({Key? key}) : super(key: key);

  @override
  State<ItemPageScreen> createState() => _ItemPageScreenState();
}

class _ItemPageScreenState extends State<ItemPageScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  // seaching work
  var searchFilter = TextEditingController();
  String searchQuery = "";

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
    getLikeList();
    getCartList();
  }

  Future<void> getLikeList() async {
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    QuerySnapshot snapshot = await firestoreRef.doc(uid).collection("likesItem").get();

    likeItemsList.clear();
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      likeItemsList.add(docData);
    });
    setState(() {

    });
  }
  Future<void> getCartList() async {
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    QuerySnapshot snapshot = await firestoreRef.doc(uid).collection("CartItem").get();

    cartItemsList.clear();
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      cartItemsList.add(docData);
    });
    setState(() {

    });
  }

  bool containsEqualMap(
      List<Map<dynamic, dynamic>> list, Map<dynamic, dynamic> target) {
    for (var map in list) {
      if (map.keys.length == target.keys.length && map.keys.every((key) => map[key] == target[key])) {
        return true;
      }
    }
    return false;
  }

  bool containsEqualName(
      List<Map<dynamic, dynamic>> list, Map<dynamic, dynamic> target) {
    for (var map in list) {
      if (map['productName'] == target['name']) {
        return true;
      }
    }
    return false;
  }


  @override
  Widget build(BuildContext context) {
    final Map<dynamic,dynamic> itemCategory = ModalRoute.of(context)!.settings.arguments as Map<dynamic,dynamic>;
    var category = itemCategory['name'];
    var cId = itemCategory['id'];
    final databaseRef = FirebaseFirestore.instance.collection("groceryitems").doc(cId).collection(category);
    final databaseReference = FirebaseFirestore.instance.collection("groceryitems").doc(cId).collection(category);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 15, 16, 1),
          width: 400,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(4,4,13,4),
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
              StreamBuilder<QuerySnapshot>(
                stream: databaseRef.snapshots(),
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState==ConnectionState.active) {
                    if(snapshot.hasData){
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> books = snapshot.data!.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

                      // Filter books based on the search query
                      List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredBooks = books
                          .where((book) =>
                          book.data()['name'].toString().toLowerCase().contains(searchQuery))
                          .toList();


                      return filteredBooks.isEmpty ? Center(
                        child: Center(child: Text("No matching books found.")),
                      ) :
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 11,
                            mainAxisSpacing: 11,
                            childAspectRatio: 9/12,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {

                            if (index >= filteredBooks.length) {
                              // Prevent accessing an invalid index
                              return SizedBox.shrink(); // Return an empty widget if index is out of bounds
                            }

                            String id = filteredBooks[index].data()['id'].toString();
                            String image = filteredBooks[index].data()['img'].toString();
                            String name = filteredBooks[index].data()['name'].toString();
                            String dozen = filteredBooks[index].data()['dozen'].toString();
                            String price = filteredBooks[index].data()['price'].toString();
                            String mPrice = filteredBooks[index].data()['oldprice'].toString();
                            String isselect = filteredBooks[index].data()['isselect'].toString();
                            bool? isLike;
                            bool? isCart;
                            if(containsEqualMap(likeItemsList,filteredBooks[index].data())){
                              isLike = false;
                            }else{
                              isLike = true;
                            }
                            if(containsEqualName(cartItemsList,filteredBooks[index].data())){
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
                                              'isselect' : isselect,
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

                                                    RoundButton(
                                                      color: isCart ? Colors.red.shade100:Colors.white,
                                                      title: isCart ? "Remove":"ADD",
                                                      onTab: (){
                                                        var cartItemRef = FirebaseFirestore.instance.collection("Usernames");
                                                        User? user = auth.currentUser;
                                                        var uid = user!.uid;
                                                        if(isCart!){
                                                          cartItemRef.doc(uid).collection("CartItem").doc(id).delete().then((value) {
                                                            context.read<CartProvider>().decrementCount();
                                                            context.read<CartProvider>().removeTotalPrice(double.parse(price));
                                                            getCartList();
                                                          });
                                                        }else{
                                                          cartItemRef.doc(uid).collection("CartItem").doc(id).set({
                                                            'id' : id,
                                                            'img' : image,
                                                            'productName' : name,
                                                            'productPrice' : price,
                                                            'initialPrice' : mPrice,
                                                            'quantity' : 0,
                                                            'dozen' : dozen,
                                                            'type' : category
                                                          }).then((value) {
                                                            context.read<CartProvider>().incrementCount();
                                                            context.read<CartProvider>().addTotalPrice(double.parse(price));
                                                            getCartList();
                                                          });
                                                        }

                                                      },
                                                    )

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
                                Container(
                                    margin: EdgeInsets.only(top: 5,left: 100),
                                    height:40,
                                    width:40,
                                    child: InkWell(
                                      onTap: (){
                                        var likeItemRef = FirebaseFirestore.instance.collection("Usernames");
                                        User? user = auth.currentUser;
                                        var uid = user!.uid;
                                        if(!isLike!){
                                          likeItemRef.doc(uid).collection("likesItem").doc(id).delete();
                                        }else{
                                          likeItemRef.doc(uid).collection("likesItem").doc(id).set({
                                            'id' : id,
                                            'img' : image,
                                            'name' : name,
                                            'price' : price,
                                            'oldprice' : mPrice,
                                            'isselect' : true,
                                            'dozen' : dozen
                                          });
                                        }
                                        getLikeList();
                                      },
                                      child: Icon(Icons.favorite,size: 25,color: isLike? Colors.grey:Colors.red),
                                    )
                                ),

                              ],
                            );
                          },),
                      );

                    }
                    else if(snapshot.hasError){
                      return Center(child: Text("An Error Occured"),);
                    }
                    else{
                      return Text("No Data Found!!");
                    }
                  }
                  else{
                    return Center(child: Center(child: CircularProgressIndicator()),);
                  }

              },),
            ],
          )
        ),
      ),
    );
  }


}
