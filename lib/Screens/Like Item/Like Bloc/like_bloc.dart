import 'dart:async';

import 'package:beautiful_grocery_app/Screens/Like%20Item/like_model.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  var auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> likeItemsList = [];

  LikeBloc() : super(LikeInitialState()) {

    on<AddLikeItem>((event, emit) async{
      User? user = auth.currentUser;
      var uid = user!.uid;
      final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
      firestoreRef.doc(uid).collection("likesItem").doc(event.likeItem.id).set(event.likeItem.toMap()).then((value) {
        getLikeList();
      });
    });

    on<DeleteLikeItem>((event, emit) async{
      User? user = auth.currentUser;
      var uid = user!.uid;
      final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
      firestoreRef.doc(uid).collection("likesItem").doc(event.id).delete().then((value) {
        getLikeList();
      });
    });
    emit(LikeLoadedState(likeItemList: likeItemsList));

  }

  void getLikeList() async {
    User user = auth.currentUser!;
    var uID = user.uid;
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    QuerySnapshot snapshot = await firestoreRef.doc(uID).collection("likesItem").get();

    likeItemsList.clear();
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      likeItemsList.add(docData);
    });

    emit(LikeLoadedState(likeItemList: likeItemsList));

  }

}
