import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class UserDetailCubit extends Cubit<Map<String, dynamic>>{
  UserDetailCubit():super({});

  final FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic> userDetail = {};

  void GetUserData()async{
    userDetail = state;
    User? user = auth.currentUser;
    var uid = user!.uid;
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    DocumentSnapshot snapshot = await firestoreRef.doc(uid).get();
    userDetail = snapshot.data() as Map<String, dynamic>;
    emit(userDetail);
  }

  void updateUserData(Map<String, dynamic> map)async{
    User? user = auth.currentUser;
    var uid = user!.uid;
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    firestoreRef.doc(uid).update(map).then((value) => emit(map));
  }

}