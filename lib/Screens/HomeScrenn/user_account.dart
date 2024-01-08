import 'package:beautiful_grocery_app/Screens/user_details/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screen5 extends StatefulWidget{
  @override
  State<Screen5> createState() => _Screen5State();
}

class _Screen5State extends State<Screen5> {

  List orderList = ["Your Orders","Cart Items"];
  List accountList = ["Manage Your Profile","Change Password","Membershiips & Suscription","Coupon History"];
  List helpList = ["Help Center","Message alert"];
  List addAcountList = ["Logout","Add Account"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Account Satus"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0,left: 20.0,right: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //---------------------------Order Status---------------------------
              Text("Orders",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Container(
                margin: EdgeInsets.only(top: 9),
                height: 100,
                child: ListView.builder(physics: NeverScrollableScrollPhysics(),
                  itemCount: orderList.length,itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400)
                    ),
                    child: Align(alignment: Alignment(-0.9, 0),
                        child: Text(orderList[index],style: TextStyle(fontWeight: FontWeight.w400),)),
                  );
                },),
              ),


              //-----------------------------Settings-----------------------------
              const Padding(
                padding: EdgeInsets.only(top: 18.0,bottom: 9),
                child: Text("Account Settings",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 200,
                child: ListView.builder(physics: NeverScrollableScrollPhysics(),
                  itemCount: accountList.length,itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      if(index==0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage(),));
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400)
                      ),
                      child: Align(alignment: Alignment(-0.9, 0),
                          child: Text(accountList[index],style: TextStyle(fontWeight: FontWeight.w400),)),
                    ),
                  );
                },),
              ),


              //---------------------------Messege Status--------------------------
              const Padding(
                padding: const EdgeInsets.only(top: 18.0,bottom: 9),
                child: Text("Message Center",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 100,
                child: ListView.builder(physics: NeverScrollableScrollPhysics(),
                  itemCount: helpList.length,itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400)
                    ),
                    child: Align(alignment: Alignment(-0.9, 0),
                        child: Text(helpList[index],style: TextStyle(fontWeight: FontWeight.w400),)),
                  );
                },),
              ),


              //----------------------Add Account/Logout---------------------------
              const Padding(
                padding: const EdgeInsets.only(top: 18.0,bottom: 9),
                child: Text("Your Accounts",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Container(
                height: 100,
                child: ListView.builder(physics: NeverScrollableScrollPhysics(),
                  itemCount: addAcountList.length,itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400)
                      ),
                      child: Align(alignment: Alignment(-0.9, 0),
                          child: Text(addAcountList[index],style: TextStyle(fontWeight: FontWeight.w400),)),
                    );
                  },),
              ),

              SizedBox(height: 25,)
            ],
          ),
        ),
      ),
    );
  }
}