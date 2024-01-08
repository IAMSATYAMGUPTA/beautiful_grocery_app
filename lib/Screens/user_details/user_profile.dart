import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/Screens/user_details/add_user_detail.dart';
import 'package:beautiful_grocery_app/Services/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilrPageState();
}

class _UserProfilrPageState extends State<UserProfilePage> {

  var iconList = [Icons.person,Icons.email,Icons.phone,Icons.location_disabled];
  var titleList = ["Name","E-Mail","Phone Number","Address"];

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    context.read<UserDetailCubit>().GetUserData();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailCubit,Map<String,dynamic>>(
        builder: (context, state) {
          var data = state;
          var dataList = [data['name'].toString(),data['email'].toString(),data['phone'].toString(),data['address'].toString()];
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
                            Row(children: [
                              SizedBox(width: 18,),
                              InkWell(
                                  onTap: (){Navigator.pop(context);},
                                  child: Icon(Icons.keyboard_backspace,color: Colors.white,size: 30,))],),
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(data['profile'].toString()),

                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(data['name'].toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),),
                            Text(data['email'].toString(),style: TextStyle(color: Colors.white),),
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
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserDetailPage(
                          imgUrl: data['profile'].toString(),
                          uEmail: data['email'].toString(),
                          uAddress: data['address'].toString(),
                          uName: data['name'].toString(),
                          uMob: data['phone'].toString(),
                        ),));
                      },
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
        },
    );
  }
}
