import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/ModelProvider.dart';
import '../reusable_widgets/apis.dart';
import 'CustomerPage.dart';
import 'Notifications.dart';
import 'Orders.dart';
import 'login/Login.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RentedItemScreen extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const RentedItemScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'DashBoard',
            theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.black,
                brightness: Brightness.light,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.white,
                brightness: Brightness.dark,
                primaryColorDark:Colors.black ),

            themeMode: ThemeMode.system,
            home: const RentedItemsPage(),
          );
        });
  }
}
class RentedItemsPage extends StatefulWidget {
  const RentedItemsPage({Key? key,}) : super(key: key);
  @override
  State<RentedItemsPage> createState() => _RentedItemsState();
}
class _RentedItemsState extends State<RentedItemsPage> {

  bool ActiveConnection = false;
  String T = "";
  final menulistkey= GlobalKey();
  final menufloatkey= GlobalKey();
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        Fluttertoast.showToast(msg: "Kindly check your internet connection.");
      });
    }
  }
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> filteritem = [];
  final String item = "Hour , Day , Month , Year ";
  String filtervalue="";
  String inputString = "";
  TextFormField? input;
  final _testList = ['Date',];
  bool additem=false, additembtn=true, edititem=false, edititembtn= true;
  String imgurl= "https://dominionmartialarts.com/wp-content/uploads/2017/04/default-image-620x600.jpg";
  File? file;
  List<String> itemlist=["item1", "item2"];
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  var doc;
  String date="";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  String time="";
  String userid= "";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String restroname="", phoneno="", address="", areacode="", profileimg="";
  String itemimage="";
  bool fetched= false;
  AuthUser? us;

  @override
  void initState() {
    CheckUserConnection();
    getcurrentuser();
    String wordPair = "";
    if(_testList.isNotEmpty){
      for(int i=0; i<_testList.length; i++){
        filteritem.add(DropdownMenuItem(child: Text(_testList[i]), value: _testList[i],));
      }}
    item
    // .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .split(" ")
        .forEach((word) {
      if (wordPair.isEmpty) {
        wordPair = word + "";
      } else {
        wordPair += word;
        if (items.indexWhere((item) {
          return (item.value == wordPair);
        }) ==
            -1) {
          items.add(DropdownMenuItem(
            child: Text(wordPair),
            value: wordPair,
          ));
        }
        wordPair = "";
      }
    });
    input = TextFormField(
      validator: (value) {
        return ((value?.length ?? 0) < 6
            ? "must be at least 6 characters long"
            : null);
      },
      initialValue: inputString,
      onChanged: (value) {
        inputString = value;
      },
      autofocus: true,
    );

    super.initState();
  }
 Future<List> getservicelist(us)async{
   var servicelist=[];
   var url= Uri.https(rentedapi, 'RentedItem/renteditems',);
   var response= await http.get(url );
   var tagObjsJson = jsonDecode(response.body)['products'] as List;
   for(int i=0; i<tagObjsJson.length; i++){
     var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
     if(jnResponse['user_id']==us){
     setState((){
       servicelist.add(jnResponse);
     });
     }
   }
   return servicelist;
  }
  Future<void>  getcurrentuser()async  {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
      var response= await http.get(url );
      if(response.body.isNotEmpty){
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print("stocklosy-uhgyuj-  ${jsonDecode(response.body)}");
        if (this.mounted) {
          setState(() {
            restroname = jsonResponse['shop_name'].toString();
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }}
    else{runApp(LoginScreen());}
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();
    var fileName = file != null ? basename(file!.path) : 'No File Selected';
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            body: RefreshIndicator(onRefresh:() async{},
                child: FutureBuilder<List>(
                  future:  getservicelist(userid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else if (snapshot.hasData || snapshot.data != null) {
                      return snapshot.data!.isNotEmpty?ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              child: ListTile(
                                leading: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey,width: 1)),
                                   child:IconButton(
                                      icon: const Icon(Icons.edit,),
                                      onPressed: ()async {
                                        await FirebaseAnalytics.instance.logEvent(
                                          name: "selected_to_edit_rent_item",
                                          parameters: {
                                            "user_id":  userid,
                                          },
                                        );
                                        String?selectedValueSingleMenu;
                                        String itemduration=  snapshot.data![index]['rented_duration'].toString();
                                        String itemname= snapshot.data![index]['rented_item_name'].toString();
                                        String itemcost= snapshot.data![index]['charger_per_duration'].toString();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return StatefulBuilder(builder: (BuildContext context, setState) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)),
                                                  title: const Text("Edit Items"),
                                                  content: Container(
                                                    width: 400,
                                                    height: 300,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            child: TextField(decoration: InputDecoration(
                                                              labelText: "Service name",
                                                              border: OutlineInputBorder(
                                                                borderSide: BorderSide(),
                                                              ),
                                                              hintText: "Service name".tr(),
                                                              prefixIcon: Icon(
                                                                  Icons.storage),),
                                                              controller: TextEditingController(text: itemname),
                                                              onChanged: (value) {
                                                                itemname = value.trim();
                                                              },)
                                                        ),
                                                        Container(
                                                            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                                                borderRadius: BorderRadius.circular(5)),
                                                            child:SearchChoices.single(
                                                              displayClearIcon: false,
                                                              isExpanded: true,
                                                              hint: "Select service duration",
                                                              searchHint: "Select service duration",
                                                              items: items,
                                                              value: itemduration,
                                                              onChanged: (value) {
                                                                setState(() {selectedValueSingleMenu= value;
                                                                itemduration = value;
                                                                });
                                                              },
                                                            )),
                                                        Text(selectedValueSingleMenu!=null?
                                                        "Service charge per $itemduration (including taxes)"
                                                            :"Selling price per duration (including taxes)"),
                                                        Container(
                                                            child: TextField(decoration: InputDecoration(
                                                              labelText: selectedValueSingleMenu!=null?
                                                              "Service charge per $itemduration (including taxes)"
                                                                  :"Selling price per duration (including taxes)",
                                                              border: OutlineInputBorder(
                                                                borderSide: BorderSide(),
                                                              ),
                                                              hintText: selectedValueSingleMenu!=null?
                                                              "Service charge per $itemduration (including taxes)"
                                                                  :"Selling price per duration (including taxes)",
                                                              prefixIcon: Icon(
                                                                  Icons.currency_rupee),),
                                                              controller:TextEditingController(text:itemcost),
                                                              onChanged: (value) {
                                                                itemcost = value.trim();
                                                              },)
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Column(
                                                      crossAxisAlignment:CrossAxisAlignment.center,
                                                      children: [
                                                        Visibility(
                                                            maintainSize: true,
                                                            maintainAnimation: true,
                                                            maintainState: true,
                                                            visible: edititem,
                                                            child: Container(width:30,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),),
                                                                child: CircularProgressIndicator()
                                                            )
                                                        ),
                                                        Visibility(
                                                            maintainSize: true,
                                                            maintainAnimation: true,
                                                            maintainState: true,
                                                            visible: edititem,
                                                            child: Container(
                                                                child:
                                                                Text("Please wait & do not press back!"))),
                                                        Visibility(
                                                          maintainSize: true,
                                                          maintainAnimation: true,
                                                          maintainState: true,
                                                          visible: edititembtn,
                                                          child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                            color: Colors.blue,
                                                          ),width: double.maxFinite,
                                                            height: 40,
                                                            child: TextButton(
                                                              onPressed:()async {setState((){edititem= true;
                                                              edititembtn= false;});
                                                           CheckUserConnection();
                                                              if(itemname.isEmpty ||itemcost.isEmpty || itemcost.startsWith("0",0) || itemduration.isEmpty){
                                                                setState((){edititem= false;
                                                                edititembtn= true;});
                                                                Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");}
                                                              else{
                                                                var url= Uri.https(rentedapi, 'RentedItem/renteditem',{'id':snapshot.data![index]['id'].toString() });
                                                                var response = await http.post(url,
                                                                  headers: <String, String>{
                                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                                  },
                                                                  body: jsonEncode(<String, String>{
                                                                    "id":snapshot.data![index]['id'].toString(),
                                                                    "user_id":snapshot.data![index]['user_id'],
                                                                    "product_id": snapshot.data![index]['product_id'],
                                                                    "rented_item_name": itemname,
                                                                    "charger_per_duration": itemcost,
                                                                    "product_engagement": snapshot.data![index]['product_engagement'],
                                                                    "rented_duration": itemduration,
                                                                    "rentout_to_client_id": snapshot.data![index]['rentout_to_client_id']}),);

                                                                print(response.statusCode);
                                                                if(response.statusCode==200){
                                                                  // await updateStockifexist(menulist[index]['item_id'].toString(),
                                                                  //     itemname, itemcost);
                                                                  setState((){edititem= false;
                                                                  edititembtn= true;
                                                                  });Navigator.pop(context);
                                                                }

                                                              }
                                                            /*  else{
                                                                final updatedItem = servicelist[index].copyWith(
                                                                    user_id: servicelist[index].user_id,
                                                                    product_id: servicelist[index].product_id,
                                                                    rented_item_name: itemname,
                                                                    rented_duration: itemduration,
                                                                    charger_per_duration: itemcost,
                                                                    product_engagement: servicelist[index].product_engagement,
                                                                    rentout_to_client_id: servicelist[index].rentout_to_client_id);
                                                                await Amplify.DataStore.save(updatedItem)
                                                                    .whenComplete(() async {
                                                                  setState((){edititem= false;
                                                                  edititembtn= true;
                                                                  setdocument();
                                                                  });Navigator.pop(context);
                                                                  await FirebaseAnalytics.instance.logEvent(
                                                                    name: "edited_to_edit_rent_item",
                                                                    parameters: {
                                                                      "user_id":  userid,
                                                                    },
                                                                  );
                                                                  debugPrint("finished");}
                                                                );}*/
                                                              },child: Text('UPDATE', style: TextStyle(color: Colors.white),),
                                                            ),),),],)
                                                  ],
                                                );});
                                            });
                                      },
                                    )),
                                title: Text(snapshot.data![index]['rented_item_name'].toString()),
                                 subtitle: Container(child:Text("₹"+snapshot.data![index]['charger_per_duration'].toString()),),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      var id=snapshot.data![index]['id'] ;
                                      var murl = Uri.https(rentedapi, 'RentedItem/renteditem',);
                                      final http.Response response = await http.delete(
                                          murl,
                                          headers: <String, String>{
                                            'Content-Type': 'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(<String, String>{
                                            "id":snapshot.data![index]['id'],})
                                      );
                                      if(response.statusCode==200){
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "Something went wring please try again!");
                                      }
                                    }
                                ),
                                // onLongPress: ,
                              ),
                            );
                          }):
                      Center(child:
                      Column(children:[
                        SizedBox(height: 15,),
                        Lottie.asset("assets/animations/noserviceadded.json", height: 250, width: 300),
                        SizedBox(height: 10,),
                        Text("You haven't added any services yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        TextButton(onPressed: (){
                          String productname="", productrentduration="", productchargeperduration="", productid="",
                              productengagement="", productissuedbyclient="";
                          String? selectedValueSingleMenu;
                          showDialog(
                              context: context,
                              builder:  (BuildContext context)
                              {
                                return StatefulBuilder(builder: (BuildContext context, setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    content: Container(
                                      width: 350,
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Container(
                                              child: TextField(decoration: InputDecoration(
                                                labelText: "Service name",
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(),
                                                ),
                                                hintText: "Service name".tr(),
                                                prefixIcon: Icon(
                                                    Icons.storage),),
                                                onChanged: (value) {
                                                  productname = value.trim();
                                                },)
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5)),
                                              child:SearchChoices.single(
                                                displayClearIcon: false,
                                                isExpanded: true,
                                                hint: "Select service duration",
                                                searchHint: "Select service duration",
                                                items: items,
                                                value: selectedValueSingleMenu,
                                                onChanged: (value) {
                                                  setState(() {selectedValueSingleMenu= value;
                                                  productrentduration = value;
                                                  });
                                                },
                                              )),
                                          SizedBox(height: 10,),
                                          Text( selectedValueSingleMenu!=null?
                                          "Service charge per $productrentduration (including taxes)"
                                              :"Selling price per duration (including taxes)"),
                                          SizedBox(height: 10,),
                                          Container(
                                              child: TextField(
                                                decoration: InputDecoration(
                                                    labelText:selectedValueSingleMenu!=null?
                                                    "Service charge per $productrentduration (including taxes)"
                                                        :"Selling price per duration (including taxes)",
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                    hintText: selectedValueSingleMenu!=null?
                                                    "Service charge per $productrentduration (including taxes)"
                                                        :"Selling price per duration (including taxes)",
                                                    prefixIcon: Icon(
                                                        Icons.currency_rupee)),
                                                keyboardType:TextInputType.number,
                                                onChanged: (value) {
                                                  productchargeperduration = value.trim();
                                                },)
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Column(crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Visibility(
                                              maintainSize: true,
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: additem,
                                              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                              ),width: 30,
                                                  margin: EdgeInsets.only(bottom: 12),
                                                  child: CircularProgressIndicator()),
                                            ),
                                            Visibility(
                                              maintainSize: true,
                                              maintainAnimation: true,
                                              maintainState: true,
                                              visible: additembtn,
                                              child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                color: Colors.blue,
                                              ),width: double.maxFinite,
                                                height: 40,
                                                child:  TextButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      additem = true;
                                                    });
                                                    if(productname.isEmpty || productchargeperduration.isEmpty ||
                                                        productrentduration.isEmpty || productchargeperduration.startsWith("0",0)){
                                                      Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");
                                                    }else{
                                                      createOn_rent(userid, productname, productrentduration, productchargeperduration);}
                                                    Navigator.of(context).pop();
                                                    String id = DateFormat("yyyyMMddHHmmss").format(
                                                        DateTime.now());
                                                  }, child: Text('ADD', style: TextStyle(color: Colors.white),),
                                                ),
                                              ),
                                            ),]),
                                    ],
                                  );
                                });
                              });
                        }, child: Container(
                            decoration: BoxDecoration(
                                color:Colors.blue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.all(15),
                            child:Text("ADD YOUR SURVICES", style:TextStyle(color:Colors.white))))
                      ]));
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueGrey,
                        ),
                      ),
                    );
                  },
                )
            ),
            floatingActionButton: TextButton(
                onPressed: ()async {  await FirebaseAnalytics.instance.logEvent(
                  name: "selected_to_add_rent_item",
                  parameters: {
                    "user_id":  userid,
                  },
                );
                  String productname="", productrentduration="", productchargeperduration="", productid="",
                      productengagement="", productissuedbyclient="";
                  String? selectedValueSingleMenu;
                  showDialog(
                      context: context,
                      builder:  (BuildContext context)
                      {
                        return StatefulBuilder(builder: (BuildContext context, setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content: Container(
                              width: 350,
                              height: 300,
                              child: Column(
                                children: [
                                  Container(
                                      child: TextField(decoration: InputDecoration(
                                        labelText: "Service name",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                        hintText: "Service name".tr(),
                                        prefixIcon: Icon(
                                            Icons.storage),),
                                        onChanged: (value) {
                                          productname = value.trim();
                                        },)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                          borderRadius: BorderRadius.circular(5)),
                                      child:SearchChoices.single(
                                        displayClearIcon: false,
                                        isExpanded: true,
                                        hint: "Select service duration",
                                        searchHint: "Select service duration",
                                        items: items,
                                        value: selectedValueSingleMenu,
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {selectedValueSingleMenu= value;
                                          productrentduration = value;
                                          });
                                        },
                                      )),
                                  SizedBox(height: 10,),
                                  Text( selectedValueSingleMenu!=null?
                                  "Service charge per $productrentduration (including taxes)"
                                      :"Selling price per duration (including taxes)"),
                                  Container(
                                      child: TextField(decoration: InputDecoration(
                                        labelText: selectedValueSingleMenu!=null?
                                        "Service charge per $productrentduration (including taxes)"
                                            :"Selling price per duration (including taxes)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),
                                        hintText: selectedValueSingleMenu!=null?
                                        "Service charge per $productrentduration (including taxes)"
                                            :"Selling price per duration (including taxes)",
                                        prefixIcon: Icon(
                                            Icons.currency_rupee),),
                                        keyboardType:TextInputType.number,
                                        onChanged: (value) {
                                          productchargeperduration = value.trim();
                                        },)
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: additem,
                                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                      ),width: 30,
                                          margin: EdgeInsets.only(bottom: 12),
                                          child: CircularProgressIndicator()),
                                    ),
                                    Visibility(
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      visible: additembtn,
                                      child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                        color: Colors.blue,
                                      ),width: double.maxFinite,
                                        height: 40,
                                        child:  TextButton(
                                          onPressed: () async {
                                            setState(() {
                                              additem = true;
                                            });
                                            if(productname.isEmpty || productchargeperduration.isEmpty ||
                                                productrentduration.isEmpty || productchargeperduration.startsWith("0",0)){
                                              Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");
                                            }else{
                                            createOn_rent(userid, productname, productrentduration, productchargeperduration);}
                                            Navigator.of(context).pop();
                                            setState(() {
                                              additem = false;
                                            });
                                            String id = DateFormat("yyyyMMddHHmmss").format(
                                                DateTime.now());
                                          }, child: Text('ADD', style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    ),]),
                            ],
                          );
                        });
                      });
                },
                child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                  // border: Border.all(3),
                  color: Colors.blue,),
                    padding:EdgeInsets.all(10),
                    width:220,
                    // height: 40,
                    child:Row(
                        children:[Icon(Icons.add, color: Colors.white,),
                          Text("NEW RENTALS/SERVICES", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center, )
                        ])),
              ),
        ));
  }

  Future<void> createOn_rent(String userid,String title, String duration, String charge) async {
    var url= Uri.https(rentedapi, 'RentedItem/renteditem',);
    final http.Response response = await http.post(url,
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id":userid,
          "product_id":  DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "rented_item_name": title,
          "charger_per_duration": charge,
          "product_engagement": "",
          "rented_duration": duration,
          "rentout_to_client_id": ""
        })
    ); print("created  -- ${response.body}");

      await FirebaseAnalytics.instance.logEvent(
        name: "added_rent_item",
        parameters: {
          "user_id":  userid,
        },
      );

  }
}

