import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/user_details/add_user_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilrPageState();
}

class _UserProfilrPageState extends State<UserProfilePage> {

  String userImg="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiDXNpK_n1Hz88mdwYx7j78rJXQHCViUnaI0d8iRgLSjMBgxmVvRWDqK4cLZ6Gyr6FjXo&usqp=CAU";
  String uName = "username" ;
  String uEmail = "user@gmail.com" ;
  String uAddress = "address" ;
  String uphone = "+91 123 4567 890" ;
  var uid;

  var iconList = [Icons.person,Icons.email,Icons.phone,Icons.location_disabled];
  var titleList = ["Name","E-Mail","Phone Number","Address"];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState(){
    super.initState();
    User? user = auth.currentUser;
    uid = user!.uid;
    fetchData();
  }

  Future<void> fetchData() async {
    DataSnapshot snapshot = await databaseReference.child("Usernames/$uid").get();
    this.userImg = snapshot.child("profile").value.toString();
    this.uName = snapshot.child("name").value.toString();
    this.uEmail = snapshot.child("email").value.toString();
    this.uAddress = snapshot.child("address").value.toString();
    this.uphone = snapshot.child("phone").value.toString();
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    List dataList = ["$uName","$uEmail","$uphone","$uAddress"];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 280,
                width: double.infinity,
                color: Colors.green,
                child: Column(
                  children: [
                    SizedBox(height: 44,),
                    Row(children: [SizedBox(width: 18,),Icon(Icons.keyboard_backspace,color: Colors.white,size: 30,)],),
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userImg.toString()),

                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(uName,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                    Text(uEmail,style: TextStyle(color: Colors.white),),
                  ],
                )
              ),
            ),
            SizedBox(height: 35,),
            Container(
              margin: EdgeInsets.all(18),
              height: 300,
              child: Card(
                elevation: 6,
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                    itemCount: iconList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(iconList[index]),
                        title: Text(titleList[index],style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(dataList[index]),
                        trailing: Icon(Icons.arrow_forward),
                      );
                    },
                ),
              ),
            ),

            SizedBox(height: 35,),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: ElevatedButton(
                onPressed: (){},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Container(
                    color: Colors.green,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Update profile")],)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
