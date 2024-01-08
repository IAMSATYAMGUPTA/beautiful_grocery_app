import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_event.dart';
import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_bloc/cart_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  var auth = FirebaseAuth.instance;

  CartBloc():super(CartInitialState()){

    on<AddCartItem>((event, emit) async{
      emit(CartLoadingState());
      User? user = auth.currentUser;
      var uid = user!.uid;
      final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
      firestoreRef.doc(uid).collection("CartItem").doc(event.cartItem.id).set(event.cartItem.toMap()).then((value) {
        GetCartItemListEvent();
      }).onError((error, stackTrace) {
        emit(CartErrorState(errorMsg: "Internet is not open"));
      });
    });

    on<DeleteCartItem>((event, emit) async{
      emit(CartLoadingState());
      User? user = auth.currentUser;
      var uid = user!.uid;
      final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
      firestoreRef.doc(uid).collection("CartItem").doc(event.id).delete().then((value) {
        GetCartItemListEvent();
      }).onError((error, stackTrace) {
        emit(CartErrorState(errorMsg: "Internet is not open"));
      });
    });
    

  }

  void GetCartItemListEvent()async{
    List<Map<String, dynamic>> mcartItemsList = [];
    User? user = auth.currentUser;
    var uid = user!.uid;
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    QuerySnapshot snapshot = await firestoreRef.doc(uid).collection("CartItem").get();

    mcartItemsList.clear();
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      mcartItemsList.add(docData);
    });

    emit(CartLoadedState(cartItemList: mcartItemsList));
  }

  void getLikeList() async {
    List<Map<String, dynamic>> likeItemsList = [];
    User user = auth.currentUser!;
    var uID = user.uid;
    final firestoreRef = FirebaseFirestore.instance.collection('Usernames');
    QuerySnapshot snapshot = await firestoreRef.doc(uID).collection("likesItem").get();

    likeItemsList.clear();
    snapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      likeItemsList.add(docData);
    });
  }

}