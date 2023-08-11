import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:beautiful_grocery_app/Custom_widget/circle_icon_button.dart';
import 'package:beautiful_grocery_app/Custom_widget/gradient_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class ItemDisplayPage extends StatefulWidget {
  const ItemDisplayPage({Key? key}) : super(key: key);

  @override
  State<ItemDisplayPage> createState() => _ItemDisplayPageState();
}

class _ItemDisplayPageState extends State<ItemDisplayPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String,dynamic> displayItem = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic> ;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 330,
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(180, 75),bottomRight: Radius.elliptical(180, 75))
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,40,10,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: CircleBorder(),
                          elevation: 3,
                          child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.keyboard_backspace,color: Colors.black,)),
                        ),
                        Column(
                          children: [
                            Card(
                              shape: CircleBorder(),
                              elevation: 3,
                              child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.shopping_bag_outlined,color: Colors.black,)),
                            ),
                            SizedBox(height: 5,),
                            Card(
                              shape: CircleBorder(),
                              elevation: 3,
                              child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.favorite,color: Colors.grey,)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100,left: 80),
                    height: 200,
                    width: 200,
                    child: Image.network(displayItem['img']),
                  )
                ],
              ),
            ),
            SizedBox(height: 18,),
            Container(
              margin: EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(displayItem['name'],style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                      Text(displayItem['price']+".00",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),),
                    ],
                  ),
                  SizedBox(height: 17,),
                  Row(
                    children: [
                      SizedBox(
                        height: 30,
                          width: 100,
                          child: Image.asset("assets/images/itemdisplay/displaystar.png")
                      ),
                      SizedBox(width: 145,),
                      IconCircleButton(iconColor: Colors.green,backGroundColor: Colors.lightGreen.shade100,icon : Icons.remove),
                      Text("  1kg  ",style: TextStyle(fontWeight: FontWeight.w500),),
                      IconCircleButton(iconColor: Colors.white,backGroundColor: Colors.green,icon : Icons.add),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Divider(color: Colors.grey,),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 208.0,bottom: 10),
                    child: Text('Description',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  ),
                  ExpandableText('apple, (Malus domestica), domesticated tree and fruit of the rose family (Rosaceae), one of the most widely'
                      ' cultivated tree fruits. Apples are predominantly grown for sale as fresh fruit, though apples are also used '
                      'commercially for vinegar, juice, jelly, applesauce, and apple butter and are canned as pie stock. A significant '
                      'portion of the global crop also is used for cider, wine, and brandy. Fresh apples are eaten raw or cooked. There '
                      'are a variety of ways in which cooked apples are used; frequently, they are used as a pastry filling, apple pie'
                      ' being perhaps the archetypal American dessert. Especially in Europe, fried apples characteristically accompany '
                      'certain dishes of sausage or pork. Apples provide vitamins A and C, are high in carbohydrates, and are an excellent '
                      'source of dietary fibre.',
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 3,
                    linkColor: Colors.blue,
                  ),
                  SizedBox(height: 15,),
                  Divider(color: Colors.grey,),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 229.0,bottom: 8),
                    child: Text('Return Time',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                  ),
                  Text("After received the product within one hour                  "),
                  SizedBox(height: 15,),
                  Divider(color: Colors.grey,),
                  SizedBox(height: 10,),
                  GradientButton(
                    width: 400.0,
                    title: "Add To Cart",
                    onTab: (){}
                  )
                ],
              )
            )

          ],
        ),
      ),
    );
  }
}
