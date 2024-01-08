class CartModel{
  String id;
  String img;
  String initialPrice;
  String totalProductPrice;
  int quantity;
  String productName;
  String dozen;
  String type;


  CartModel({required this.id,required this.img,required this.initialPrice, required this.totalProductPrice,
    required this.quantity,required this.productName,required this.dozen,required this.type});

  factory CartModel.fromMap(Map<dynamic,dynamic> map){
    return CartModel(
        id: map['id'],
        productName: map['productName'],
        totalProductPrice: map['productPrice'],
        quantity: map['quantity'],
        initialPrice: map['initialPrice'],
        dozen: map['dozen'],
        type: map['type'],
        img: map['img']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'productName' : productName,
      'productPrice' : totalProductPrice,
      'quantity' : quantity,
      'initialPrice' : initialPrice,
      'dozen' : dozen,
      'type' : type,
      'img' : img,
    };
  }

}