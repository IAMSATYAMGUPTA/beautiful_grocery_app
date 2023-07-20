import 'package:beautiful_grocery_app/Custom_widget/RoundButton.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class ItemPageScreen extends StatefulWidget {
  const ItemPageScreen({Key? key}) : super(key: key);

  @override
  State<ItemPageScreen> createState() => _ItemPageScreenState();
}

class _ItemPageScreenState extends State<ItemPageScreen> {

  bool addItem = false;

  final List colorList = [Colors.lightGreen.shade100,Colors.lightBlue.shade100,
    Colors.orangeAccent.shade100,Colors.red.shade100,
    Colors.purple.shade100,Colors.lime.shade100];

  var rive_path = "assets/rive/heart.riv";
  StateMachineController? machineController;
  Artboard? mainArtboard;
  SMIInput<bool>? riveInput;

  @override
  void initState() {
    super.initState();

    rootBundle.load(rive_path).then((riveByteData) {
      var file = RiveFile.import(riveByteData);
      var artboard = file.mainArtboard;
      machineController = StateMachineController.fromArtboard(artboard, "heartFav");

      if(machineController!=null){
        artboard.addController(machineController!);
        riveInput = machineController!.findInput("Boolean 1");
        mainArtboard = artboard;
        riveInput!.value = false;
        setState(() {

        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final String itemCategory = ModalRoute.of(context)!.settings.arguments as String;
    final databaseRef = FirebaseDatabase.instance.ref().child("groceryitems/$itemCategory");
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 15, 16, 1),
          width: 400,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder(stream: databaseRef.onValue,builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    else{
                      List<dynamic>? list = snapshot.data?.snapshot.value as List<dynamic>?;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 11,
                            mainAxisSpacing: 11,
                            childAspectRatio: 9/12
                        ),
                        itemCount: list!.length-1,
                        itemBuilder: (context, index) {
                          index++;
                          if (list != null && index < list.length) {
                            if (list[index] != null && list[index] is Map<dynamic, dynamic>) {
                              Map<dynamic, dynamic> itemList = list[index] as Map<dynamic, dynamic>;
                              return Stack(
                                children: [
                                  Card(
                                    elevation: 5,
                                    shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.white)
                                    ),
                                    child: Container(
                                      height: 210,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        color: colorList[index % colorList.length],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            child: Container(margin: EdgeInsets.only(top: 4,right: 8),
                                                height:110,width:110,child: Image.network(itemList['img'])),
                                          ),
                                          Container(
                                            height: 80,
                                            width: 140,
                                            color: Colors.grey.shade100,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("${itemList['name']}"),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(itemList['price']),
                                                          Text(itemList['discount']),
                                                        ],
                                                      ),

                                                      RoundButton(title: "ADD", onTab: (){})

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5,left: 100),
                                    height:40,
                                    width:40,
                                    child: mainArtboard == null ? Container() : InkWell(
                                        onTap: (){
                                          if(riveInput!=null){
                                            if(riveInput!.value == false && riveInput!.controller.isActive == false ){
                                              riveInput!.value = true;
                                            }
                                            else if(riveInput!.value == true && riveInput!.controller.isActive == false ){
                                              riveInput!.value = false;
                                            }
                                          }
                                        },
                                        child: Rive(artboard: mainArtboard!,fit: BoxFit.cover,)),
                                  ),



                                ],
                              );
                            }

                          }

                          return Container();
                        },);
                    }
                  },)
              ),
            ],
          )
        ),
      ),
    );
  }


}
