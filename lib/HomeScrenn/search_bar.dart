import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  // Create an empty list to store the data
  var uid;
  List<Map<String, dynamic>> data = [];

  @override
  void initState(){
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    uid = user!.uid;
    getLikeList();
  }

  Future<void> getLikeList() async {
    final firestoreRef = FirebaseFirestore.instance.collection('groceryitems');
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = firestoreRef.snapshots();


      print(snapshots);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(4,4,13,4),
              height : 50,
              child: TextFormField(
                // controller: searchFilter,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                  contentPadding: EdgeInsets.only(top: 6,left: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                ),
              ),
            // StreamBuilder<QuerySnapshot>(
            //   stream: databaseRef.snapshots(),
            //   builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
            //   return Container();
            // },)
          ],
        ),
      ),
    );
  }
}
