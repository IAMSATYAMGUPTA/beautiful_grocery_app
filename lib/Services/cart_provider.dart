import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier{

  var firestoreRef = FirebaseFirestore.instance.collection('Usernames');
  User? user = FirebaseAuth.instance.currentUser;

  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void fetchCartData()async{
    var uID = user!.uid;
    DocumentSnapshot snapshot = await firestoreRef.doc(uID).get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    _counter = data['totalItem'];
    _totalPrice = data['totalIPrice'];
    notifyListeners();
  }

  void incrementCount(){
    var uID = user!.uid;
    _counter++;
    firestoreRef.doc(uID).update({
      'totalItem' : _counter
    }).then((value) {
      fetchCartData();
    });
  }

  void decrementCount(){
    var uID = user!.uid;
    _counter--;
    firestoreRef.doc(uID).update({
      'totalItem' : _counter
    }).then((value) {
      fetchCartData();
    });
  }

  void addTotalPrice(double productPrice){
    var uID = user!.uid;
    _totalPrice = _totalPrice + productPrice ;
    firestoreRef.doc(uID).update({
      'totalIPrice' : _totalPrice
    }).then((value) {
      fetchCartData();
    });
  }

  void removeTotalPrice(double productPrice){
    var uID = user!.uid;
    _totalPrice = _totalPrice - productPrice ;
    firestoreRef.doc(uID).update({
      'totalIPrice' : _totalPrice
    }).then((value) {
      fetchCartData();
    });
  }

}