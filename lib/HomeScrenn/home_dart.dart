import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/Custom_widget/custom_toast.dart';
import 'package:beautiful_grocery_app/User%20_Entry_Verification/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomeScreenPage extends StatefulWidget {

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {

  String? username;
  var uid;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();
  final categoryRef = FirebaseDatabase.instance.ref("categories");
  final discountRef = FirebaseDatabase.instance.ref("discount");
  final dodRef = FirebaseDatabase.instance.ref("dealday");
  final mPopularRef = FirebaseDatabase.instance.ref("mostpopular");
  final List _color = [Colors.lightGreen.shade100,Colors.lightBlue.shade100,Colors.orangeAccent.shade100
    ,Colors.lightGreen.shade100,Colors.purpleAccent.shade100,Colors.lightBlue.shade100
    ,Colors.lightGreen.shade100,Colors.purpleAccent.shade100,Colors.lightBlue.shade100];
  final discountColor = [Colors.greenAccent.shade100,Colors.orangeAccent.shade100];

  @override
  void initState(){
    super.initState();
    User? user = auth.currentUser;
    uid = user!.uid;
    fetchData();
  }

  Future<void> fetchData() async {
    DataSnapshot snapshot = await databaseReference.child("Usernames/$uid/name").get();
    this.username = snapshot.value.toString();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.green,
              child: Column(
                children: [
                  SizedBox(height: 45,),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:29.0,right: 20.0),
                        child: CircleAvatar(
                          child: Image.network("https://tricky-photoshop.com/wp-content/uploads/2017/08/final-1.png"),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi,",),
                          Text("${username}", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      const Expanded(child: Align(
                        alignment: Alignment.centerRight,
                        child: Card(
                          shape: CircleBorder(),
                          elevation: 3,
                          child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.notification_add,color: Colors.black,)),
                        ),
                      ),),
                      SizedBox(width: 29,),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0,bottom: 9),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Container(
                        height: 45,
                        width: 310,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0,right: 6),
                              child: Icon(Icons.search,color: Colors.grey.shade400,size: 23,),
                            ),
                            Text("Search your daily Grocery Food",style: TextStyle(color: Colors.grey.shade400,fontSize: 15),),
                          ],
                        ),

                      ),
                    ),
                  ),

                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 10,left: 11,right: 11),
              child: Column(
                children: [
                  Container(
                      height: 183,
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Text("    Categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(width: 179,),
                                Text("See all",style: TextStyle(color: Colors.green,fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Expanded(
                              child: FirebaseAnimatedList(
                                  scrollDirection: Axis.horizontal,
                                  query: categoryRef,
                                  itemBuilder: (context, snapshot, animation, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          Navigator.pushNamed(context, "/itempage",arguments: snapshot.child('name').value.toString());
                                        },
                                        child: Column(
                                          children: [
                                            Container(height: 100,width: 85,
                                              decoration: BoxDecoration(
                                                color: _color[index],
                                                borderRadius: BorderRadius.circular(12)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(9.0),
                                                child: Image.network(snapshot.child('image').value.toString()),
                                              ),
                                            ),
                                            SizedBox(height: 4,),
                                            Text(snapshot.child('name').value.toString(),style: TextStyle(fontWeight: FontWeight.w400),)
                                          ],
                                        ),
                                      ),
                                    );
                                  },),
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: 16,top: 10),
              height: 110,
              child: Expanded(
                child: FirebaseAnimatedList(
                  scrollDirection: Axis.horizontal,
                    query: discountRef,
                    itemBuilder: (context, snapshot, animation, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 13),
                        height: 115,
                        width: 260,
                        decoration: BoxDecoration(
                            color: discountColor[index],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                height: 80,
                                width: 70,
                                child: Image.network(snapshot.child('img').value.toString(),fit: BoxFit.cover,)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(snapshot.child('title').value.toString(),style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold,fontSize: 19),),
                                SizedBox(height: 4,),
                                Text("Order any food from app\nand get thr discount",style: TextStyle(fontSize: 12),),
                                SizedBox(height: 10,),
                                Text("Order now",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                              ],
                            )

                          ],
                        ),
                      );
                    },
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 10,left: 11,right: 11),
              child: Column(
                children: [
                  Container(
                      height: 183,
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12,),
                            Row(
                              children: [
                                Text("    Deal of the day",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(width: 150,),
                                Text("See all",style: TextStyle(color: Colors.green,fontSize: 14),),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Expanded(
                              child: FirebaseAnimatedList(
                                scrollDirection: Axis.horizontal,
                                query: dodRef,
                                itemBuilder: (context, snapshot, animation, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 9.0),
                                    child: Column(
                                      children: [
                                        Container(height: 100,width: 135,
                                          margin: EdgeInsets.only(right: 6),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(52)
                                          ),
                                          child: Image.network(snapshot.child('img').value.toString(),fit: BoxFit.cover,),
                                        ),
                                        SizedBox(height: 6,),
                                        Row(
                                          children: [
                                            Text(snapshot.child('name').value.toString(),style: TextStyle(fontWeight: FontWeight.w500),),
                                            Text(snapshot.child('discount').value.toString(),style: TextStyle(fontWeight: FontWeight.w500,color: Colors.green),),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },),
                            )
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(13),
              height: 470,width: 400,color: Colors.lightGreen.shade100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 4, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Most Popular Item",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21),),
                    SizedBox(height: 10,),

                    Expanded(
                        child: StreamBuilder(stream: mPopularRef.onValue,builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {

                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          else {
                            List<dynamic>? list = snapshot.data?.snapshot.value as List<dynamic>?;
                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 11,
                                  mainAxisSpacing: 11,
                                  childAspectRatio: 16/11
                              ),
                              itemCount: list!.length-1,
                              itemBuilder: (context, index) {
                                index++;
                                if (list != null && index < list.length) {
                                  if (list[index] != null && list[index] is Map<dynamic, dynamic>) {
                                    Map<dynamic, dynamic>? popularItem = list[index] as Map<dynamic, dynamic>?;
                                    return Container(
                                      height: 210,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.green.shade500),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.network(popularItem!['img']),
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
                                                  Text(popularItem['name']),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(popularItem['offerprice']),
                                                          Text(popularItem['oldprice']),
                                                        ],
                                                      ),
                                                      RoundButton(title: "ADD", onTab: () {}),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }else{
                                    print("---------------error-----------");
                                  }

                                }

                                return Container();
                              },);
                          }
                        }
                        )
                    )

                  ],
                ),
              ),
            ),

            Image(image: AssetImage("assets/images/homeimg/homeone.jpg")),

            Image(image: AssetImage("assets/images/homeimg/hometwo.jpg")),

          ],
        ),
      )
    );
  }

  void SignOut() {
    FirebaseAuth.instance.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreenPage(),))
    ).onError((error, stackTrace) => CustomToast().toastMessage(msg: error.toString()));
  }

}

// Container(
// height: 204,
// width: 140,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(6),
// border: Border.all(color: Colors.green.shade500)
// ),
// child: Column(
// children: [
// Container(
// height: 120,
// child: Image.network("https://firebasestorage.googleapis.com/v0/b/flutter-dumy-38ec9.appspot.com/o/mostpopular%2Fei_1689666981190-removebg-preview.png?alt=media&token=952e95eb-dceb-481b-94c8-b0860f2d8393"),
// ),
// Container(
// height: 80,
// width: 140,
// color: Colors.grey.shade100,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text("Anar 1 kg"),
// Row(
// crossAxisAlignment: CrossAxisAlignment.end,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// children: [
// Text("129"),
// Text("1̶4̶9̶")
// ],
// ),
// RoundButton(title: "Add", onTab: (){})
//
// ],
// )
// ],
// ),
// ),
// )
// ],
// ),
// )
