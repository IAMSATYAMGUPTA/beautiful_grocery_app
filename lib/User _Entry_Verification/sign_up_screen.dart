import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beautiful_grocery_app/Custom_widget/custom_toast.dart';
import 'package:beautiful_grocery_app/Custom_widget/gradient_button.dart';
import 'package:beautiful_grocery_app/Custom_widget/textfeild_decoration.dart';
import 'package:beautiful_grocery_app/Custom_widget/validator_mixin.dart';
import 'package:beautiful_grocery_app/HomeScrenn/home_dart.dart';
import 'package:beautiful_grocery_app/HomeScrenn/manage_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignupScreenPage extends StatefulWidget {
  const SignupScreenPage({Key? key}) : super(key: key);

  @override
  State<SignupScreenPage> createState() => _SignupScreenPageState();
}

class _SignupScreenPageState extends State<SignupScreenPage> with ValidatorMixin {

  final emailController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final passwordcController = TextEditingController();
  final usernameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  bool isLoading = false;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage("assets/images/verifications_image/signup.jpg")),
            SizedBox(height:3,),

            Container(
              width: 330,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),

                        // Here i used to Animated Login Text
                        Row(
                          children: [
                            AnimatedTextKit(
                              totalRepeatCount: 2,
                              animatedTexts: [
                                TyperAnimatedText("Created New Accunt",
                                    speed: Duration(milliseconds: 50)
                                    ,textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),

                        // user Original name Text Feild
                        TextFormField(
                          style: TextStyle(fontSize: 16),
                          controller: usernameController,
                          decoration: TextFeildDecoration.getCustomDecoration(
                            labelText: "Name",
                            suffixcolor: Colors.green,

                          ),
                        ),
                        SizedBox(height: 22,),

                        // username or email Text Feild
                        TextFormField(
                          validator: emailValidate,
                          controller: emailController,
                          style: TextStyle(fontSize: 16),
                          decoration: TextFeildDecoration.getCustomDecoration(
                            labelText: "Email...",
                            hint: "email@gmail.com",
                            mSuffixIcon: Icons.email_outlined,
                            suffixcolor: Colors.green,

                          ),
                        ),
                        SizedBox(height: 22,),

                        // user Password Text Feild
                        TextFormField(
                          controller: passwordcController,
                          validator: passValidate,
                          decoration: TextFeildDecoration.getCustomDecoration(
                            labelText: "Password",
                            mSuffixIcon: Icons.visibility_off,
                            suffixcolor: Colors.green,
                          ),
                        ),
                        SizedBox(height: 22,),

                        // user confirm Password Text Feild
                        TextFormField(
                          validator: passValidate,
                          controller: passwordConfirmController,
                          decoration: TextFeildDecoration.getCustomDecoration(
                            labelText: "Confirm Password",
                            suffixcolor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),

            // use row to take Signup button
            Row(
              children: [
                SizedBox(width: 188,),
                GradientButton(loading: isLoading,title: "Sign up", onTab: (){
                  if(formKey.currentState!=null){
                    if(formKey.currentState!.validate()){
                      if(passwordcController.text.toString()==passwordConfirmController.text.toString()){
                        setState(() {
                          isLoading = true;
                        });
                        _auth.createUserWithEmailAndPassword(
                            email: emailController.text.toString(),
                            password: passwordcController.text.toString()
                        ).then((value) {
                          setState(() {
                            isLoading = false;
                          });
                          formKey.currentState!.reset();
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => ManageBottonNav()));
                          CustomToast().toastMessage(msg: "Account created succesfully");
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          User? user = auth.currentUser;
                          var uid = user!.uid;
                          final databaseRef = FirebaseDatabase.instance.ref("Usernames");
                          databaseRef.child(uid.toString()).set({
                            'name' : usernameController.text.toString()
                          }).onError((error, stackTrace) => CustomToast().toastMessage(msg: error.toString()));

                        }
                        ).onError((error, stackTrace) {
                          setState(() {
                            isLoading = false;
                          });
                          CustomToast().toastMessage(msg: error.toString(),color: Colors.red);
                        }
                        );
                      }
                      else{
                        setState(() {
                          isLoading = false;
                        });
                        CustomToast().toastMessage(msg: "Both Password are not same");
                      }
                    }
                  }
                }),
              ],
            ),
            SizedBox(height: 10,),

            // back to Login Screen Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",style: TextStyle(fontSize: 17)),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Login",style: TextStyle(color: Colors.green,fontSize: 18)))
              ],),
          ],
        ),
      ),
    );
  }
}
