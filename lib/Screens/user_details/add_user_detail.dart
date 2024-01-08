import 'dart:io';

import 'package:beautiful_grocery_app/Custom_widget/custom_toast.dart';
import 'package:beautiful_grocery_app/Screens/HomeScrenn/manage_bottom_navigation.dart';
import 'package:beautiful_grocery_app/Services/user_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class AddUserDetailPage extends StatefulWidget {
  String? imgUrl;
  String? uName;
  String? uEmail;
  String? uMob;
  String? uAddress;
  AddUserDetailPage({this.imgUrl="data:image/png;base64,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",
    this.uName,this.uEmail,this.uMob,this.uAddress});

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
    if(widget.uName!=null){
      nameController.text = widget.uName!;
      emailController.text = widget.uEmail!;
      phoneController.text = widget.uMob!;
      addController.text = widget.uAddress!;
    }
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
                        ) :CircleAvatar(
                          radius: 73,
                          backgroundImage: widget.imgUrl!=null? NetworkImage("https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png")
                              :NetworkImage(widget.imgUrl!),
                        ),

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

                      setState(() {
                        isLoading = true;
                      });

                      var id = DateTime.now().millisecondsSinceEpoch;
                      firebase_storage.Reference? reference;
                      firebase_storage.UploadTask uploadTask;
                      var newUrl;
                      if(_image!=null){
                        reference = firebase_storage.FirebaseStorage.instance.ref("/foldername/"+id.toString());
                        uploadTask = reference.putFile(_image!.absolute);

                        // yha se upload ho rha hai
                        await Future.value(uploadTask);
                        newUrl = await reference.getDownloadURL();
                      }


                      final FirebaseAuth auth = FirebaseAuth.instance;
                      User? user = auth.currentUser;
                      var uid = user!.uid;
                      final databaseRef = FirebaseFirestore.instance.collection("Usernames");
                      if(widget.uName==null){
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
                          setState(() {
                            isLoading=false;
                          });
                        }
                        ).onError((error, stackTrace) => CustomToast().toastMessage(msg: error.toString()));
                      }else{
                        context.read<UserDetailCubit>().updateUserData(
                          {
                            'name' : nameController.text.toString(),
                            'email' : emailController.text.toString(),
                            'phone' : phoneController.text.toString(),
                            'address' : addController.text.toString(),
                            'profile' : _image !=null ?newUrl.toString():widget.imgUrl,
                          }
                        );
                        Navigator.pop(context);
                      }

                      },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading ? Center(child: CircularProgressIndicator(color: Colors.white),):
                        Text(widget.uName!=null?"Update detail":"Save And Go",style: TextStyle(fontSize: 16),)
                      ],),
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
