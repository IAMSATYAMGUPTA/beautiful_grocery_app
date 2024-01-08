class LikeModel{
  String id;
  String img;
  String price;
  String oldprice;
  String productName;
  String dozen;
  String type;


  LikeModel({required this.id,required this.img,required this.price, required this.oldprice,
    required this.productName,required this.dozen,required this.type});

  factory LikeModel.fromMap(Map<dynamic,dynamic> map){
    return LikeModel(
        id: map['id'],
        img: map['img'],
        price: map['price'],
        oldprice: map['oldprice'],
        productName: map['productName'],
        dozen: map['dozen'],
        type: map['type'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'img' : img,
      'price' : price,
      'oldprice' : oldprice,
      'productName' : productName,
      'dozen' : dozen,
      'type' : type,
    };
  }

}