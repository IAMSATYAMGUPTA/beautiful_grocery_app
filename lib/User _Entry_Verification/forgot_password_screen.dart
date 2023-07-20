import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:beautiful_grocery_app/Custom_widget/custom_toast.dart';
import 'package:beautiful_grocery_app/Custom_widget/gradient_button.dart';
import 'package:beautiful_grocery_app/Custom_widget/textfeild_decoration.dart';
import 'package:beautiful_grocery_app/Custom_widget/validator_mixin.dart';
import 'package:beautiful_grocery_app/User%20_Entry_Verification/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with ValidatorMixin {

  var emailController = TextEditingController();
  bool isLoading = false;

  var formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage("assets/images/verifications_image/forgot.jpg")),
            SizedBox(height: 108,),

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

                        // Here i used Animated ForgotPassword Text
                        Row(
                          children: [
                            AnimatedTextKit(
                              totalRepeatCount: 2,
                              animatedTexts: [
                                TyperAnimatedText("ForgotPassword",
                                    speed: Duration(milliseconds: 50)
                                    ,textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),

                        // user name Text Feild
                        TextFormField(
                          controller: emailController,
                          validator: emailValidate,
                          style: TextStyle(fontSize: 16),
                          decoration: TextFeildDecoration.getCustomDecoration(
                            labelText: "User Email ...",
                            hint: "email@gmail.com",
                            mSuffixIcon: Icons.email_outlined,
                            suffixcolor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),

            // Forgot password Button
            Row(
              children: [
                SizedBox(width: 20,),
                GradientButton(title: "Send Verification Link", width: 320.0, loading: isLoading,
                    onTab: (){
                      if(formKey.currentState !=null){
                        if(formKey.currentState!.validate()){
                          setState(() {
                            isLoading = true;
                          });
                          _auth.sendPasswordResetEmail(email: emailController.text.toString()
                          ).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            CustomToast().toastMessage(msg: "We have sent you email to recover password");
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreenPage(),));
                          }
                          ).onError((error, stackTrace){
                            setState(() {
                              isLoading = false;
                            });
                            CustomToast().toastMessage(msg: error.toString());
                          } );
                        }
                      }
                    }
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
