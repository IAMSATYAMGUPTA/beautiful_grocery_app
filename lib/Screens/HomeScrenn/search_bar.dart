import 'package:beautiful_grocery_app/Custom_widget/add_remove_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  @override
  void initState(){
    super.initState();
  }

  var searchController = TextEditingController();

  var firestoreRef = FirebaseFirestore.instance.collection("groceryProduct");

  List<Map<String,dynamic>> arrData=[];

  var searchName = "";

  final List colorList = [Colors.lightGreen.shade100,Colors.lightBlue.shade100,
    Colors.orangeAccent.shade100,Colors.red.shade100,
    Colors.purple.shade100,Colors.lime.shade100];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    hintText: " Search",
                    contentPadding: EdgeInsets.only(top: 6,left: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(width: 3,color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(width: 3,color: Colors.grey)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(width: 3,color: Colors.grey)
                    ),
                  ),
                  onChanged: (value){
                    searchName = value.toLowerCase();
                    setState(() {

                    });
                  },
                  ),
              ),

              Expanded(
                child: StreamBuilder(
                    stream: firestoreRef.snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator(),);
                      } else if(snapshot.hasError){
                        return Center(child: Text(snapshot.error.toString()),);
                      }else if(snapshot.hasData){

                        var data = snapshot.data!.docs;

                        arrData.clear();
                        for(QueryDocumentSnapshot value in data){
                          // arrData.addAll(value['items']);
                          for(Map<String,dynamic> map in value['items']){
                            arrData.add(map);
                          }
                        }

                        var filteredData = arrData
                            .where((element) =>
                            element['name'].toString().toLowerCase().contains(searchName))
                            .toList();


                        return GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          itemCount: filteredData.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,childAspectRatio: 9/12.3,crossAxisSpacing: 11,mainAxisSpacing: 11),
                          itemBuilder: (context, index) {

                            String image = filteredData[index]['img'].toString();
                            String name = filteredData[index]['name'].toString();
                            String dozen = filteredData[index]['dozen'].toString();
                            String price = filteredData[index]['price'].toString();
                            String mPrice = filteredData[index]['oldprice'].toString();

                            return Card(
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
                                      onTap: (){},
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

                                                // AddRemoveButton(
                                                //   height: 26.0,
                                                //   color: isCart ? Colors.red.shade300:Colors.green.shade400,
                                                //   width: isCart ?70.0:50.0,
                                                //   title: isCart ? "Remove":"ADD",
                                                //   onTap: (){
                                                //     if(isCart!){
                                                //       context.read<CartBloc>().add(DeleteCartItem(id: id));
                                                //       context.read<CartProvider>().decrementCount();
                                                //       context.read<CartProvider>().removeTotalPrice(double.parse(price));
                                                //     }else{
                                                //       context.read<CartBloc>().add(AddCartItem(
                                                //         cartItem: CartModel(
                                                //             id: id,
                                                //             img: image,
                                                //             initialPrice: price,
                                                //             totalProductPrice: price,
                                                //             quantity: 1,
                                                //             productName: name,
                                                //             dozen: dozen,
                                                //             type: category
                                                //         ),
                                                //       ));
                                                //       context.read<CartProvider>().incrementCount();
                                                //       context.read<CartProvider>().addTotalPrice(double.parse(price));
                                                //     }
                                                //
                                                //   },
                                                // ),



                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: Text("No Data Found"),);
                    },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
