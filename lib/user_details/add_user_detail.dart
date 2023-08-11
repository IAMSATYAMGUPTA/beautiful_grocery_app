import 'dart:io';

import 'package:beautiful_grocery_app/Custom_widget/custom_toast.dart';
import 'package:beautiful_grocery_app/HomeScrenn/manage_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddUserDetailPage extends StatefulWidget {
  const AddUserDetailPage({Key? key}) : super(key: key);

  @override
  State<AddUserDetailPage> createState() => _AddUserDetailPageState();
}

class _AddUserDetailPageState extends State<AddUserDetailPage> {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addController = TextEditingController();

  File? _image;
  bool isLoading = false;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance ;

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref("post");

  Future getGalleryImage()async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile!=null){
        _image = File(pickedFile.path);
      }else{
        print("no image picked");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(

          children: [

            Container(
              height: 230,
              width: double.infinity,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48,58,48,38),
                child: InkWell(
                  onTap: (){
                    getGalleryImage();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey.shade300,
                    radius: 73,
                    child: Stack(
                      children: [
                        _image !=null ? CircleAvatar(
                          radius: 73,
                          backgroundImage: FileImage(_image!.absolute,),
                        ) :Icon(Icons.person,size: 130,color: Colors.white,),

                        Padding(
                          padding: const EdgeInsets.only(top: 95.0,left: 90),
                          child: CircleAvatar(
                            backgroundColor: Colors.tealAccent.shade700,
                            child: Icon(Icons.camera_alt,color: Colors.white,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            Container(
              margin: EdgeInsets.all(25),
              child: Column(
                children: [
                  TitleTextFeild(title: "Name",icon: Icons.info_outline,controller: nameController,hint: "name.."),
                  TitleTextFeild(title: "Email",icon: Icons.email,controller: emailController,hint: "user@gamil.com"),
                  TitleTextFeild(title: "Phone no.",icon: Icons.phone,controller: phoneController,hint: "+91 123 4567 890"),
                  TitleTextFeild(title: "Address",icon: Icons.location_pin,controller: addController,hint: "Enter your address..."),

                  SizedBox(height: 50,),

                  ElevatedButton(
                    onPressed: ()async{

                      var id = DateTime.now().millisecondsSinceEpoch;
                      firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref("/foldername/"+id.toString());
                      firebase_storage.UploadTask uploadTask = reference.putFile(_image!.absolute);

                      // yha se upload ho rha hai
                      await Future.value(uploadTask);

                      var newUrl = await reference.getDownloadURL();

                      final FirebaseAuth auth = FirebaseAuth.instance;
                      User? user = auth.currentUser;
                      var uid = user!.uid;
                      final databaseRef = FirebaseFirestore.instance.collection("Usernames");
                      databaseRef.doc(uid.toString()).set({
                        'name' : nameController.text.toString(),
                        'email' : emailController.text.toString(),
                        'phone' : phoneController.text.toString(),
                        'address' : addController.text.toString(),
                        'profile' : newUrl.toString(),
                        'totalPrice' : 0,
                        'totalItem' : 0
                      }).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageBottonNav(),));
                      }
                      ).onError((error, stackTrace) => CustomToast().toastMessage(msg: error.toString()));
                      },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Container(
                        color: Colors.green,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("Save And Go")],)
                    ),
                  )

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget TitleTextFeild({required String title,required IconData icon,required TextEditingController controller,String hint=""}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text(title,style: TextStyle(fontSize: 15),),
        SizedBox(height: 4,),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 8),
              hintText: hint,
              prefixIcon: Icon(icon),
              prefixIconColor: Colors.grey,
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
        )
      ],
    );
  }

}
