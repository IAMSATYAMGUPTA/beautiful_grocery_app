abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  List<Map<String,dynamic>> cartItemList;
  CartLoadedState({required this.cartItemList});
}

class CartErrorState extends CartState {
  String errorMsg;
  CartErrorState({required this.errorMsg});
}
