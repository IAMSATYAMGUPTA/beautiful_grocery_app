import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LikeItemsPage extends StatefulWidget{
  @override
  State<LikeItemsPage> createState() => _LikeItemsPageState();
}

class _LikeItemsPageState extends State<LikeItemsPage> {


  final FirebaseAuth auth = FirebaseAuth.instance;

  final firestore = FirebaseFirestore.instance.collection("Usernames");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          StreamBuilder<QuerySnapshot>(
            stream: firestore.doc(uid).collection("likesItem").snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator());
              }
              else if(snapshot.hasError){
                return Text("........... Error..........");
              }
              else{
                return Expanded(
                    child: ListView.builder(

                      padding: EdgeInsets.only(top: 4),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(13,7,7,7),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(color: Colors.grey.shade400)
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
                                    Container(height: 100,width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
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
                                              Text(snapshot.data!.docs[index]['name'].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                  onTap: (){
                                                    firestore.doc(uid).collection("likesItem").doc(snapshot.data!.docs[index]['id'].toString()).delete();
                                                  },
                                                  child: Icon(Icons.delete)),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Text("MRP "+snapshot.data!.docs[index]['oldprice'].toString(),
                                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w200),),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [

                                              Text(r"$"+snapshot.data!.docs[index]['price'].toString()+" ${snapshot.data!.docs[index]['dozen']}",
                                                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),

                                              InkWell(
                                                onTap: (){

                                                },
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.lightGreen,
                                                  ),
                                                  child: Center(child: Text("Add to cart",style: TextStyle(color: Colors.white),),),
                                                ),
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
                    )
                );
              }
            },
          ),

          // --------------show prices-------------------------------
          Card(

          )

        ],
      ),
    );
  }
}