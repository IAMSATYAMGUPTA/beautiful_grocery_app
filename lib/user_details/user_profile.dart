import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilrPageState();
}

class _UserProfilrPageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              height: 240,
              width: double.infinity,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35,45,35,20),
                child: CircleAvatar(


                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
