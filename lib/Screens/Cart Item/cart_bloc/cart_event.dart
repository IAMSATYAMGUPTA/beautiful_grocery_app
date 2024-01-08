import 'package:beautiful_grocery_app/Screens/Cart%20Item/cart_model.dart';

abstract class CartEvent {}

class AddCartItem extends CartEvent{
  CartModel cartItem;
  AddCartItem({required this.cartItem});
}

class DeleteCartItem extends CartEvent{
  String id;
  DeleteCartItem({required this.id});
}
