class CartModel{
  String id;
  int initialPrice;
  int productPrice;
  int quantity;
  String name;

  CartModel({required this.id,required this.name,required this.productPrice,required this.quantity,required this.initialPrice});

  factory CartModel.fromMap(Map<dynamic,dynamic> map){
    return CartModel(
        id: map['id'],
        name: map['name'],
        productPrice: map['productPrice'],
        quantity: map['quantity'],
        initialPrice: map['initialPrice']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'productPrice' : productPrice,
      'quantity' : quantity,
      'initialPrice' : initialPrice,
    };
  }

}