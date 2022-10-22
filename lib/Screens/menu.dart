import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webappbillingcoach/reusable_widgets/apis.dart';
import '../models/ModelProvider.dart';
import 'login/Login.dart';
class MenuViewScreen extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const MenuViewScreen({Key? key}) : super(key: key);
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
            home: /*FirebaseAuth.instance.currentUser == null
                ?  LoginScreen():FirebaseFirestore.instance.collection("Subscription").doc(FirebaseAuth.instance.currentUser!.uid)
                .get().then((value){value.get("status");})!="Inactive"?*/
            const MenuItemsPage(),//:SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class MenuItemsPage extends StatefulWidget {
  const MenuItemsPage({Key? key,}) : super(key: key);
  @override
  State<MenuItemsPage> createState() => _itemPageState();
}
class _itemPageState extends State<MenuItemsPage> {
  bool ActiveConnection = false;
  String T = "";
  final menulistkey= GlobalKey();
  final menufloatkey= GlobalKey();
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> filteritem = [];
  String filtervalue="";
  String inputString = "";
  TextFormField? input;
  final _testList = ['Date',];
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
  bool additem=false, additembtn=true, edititem=false, edititembtn= true;
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
  var itemunitlist=["Pieces", "Packets","Bottle", "Centimeter","Meter", "Kilometer", "SqMeter", "Yard", "Pouch", "Gram", "KiloGram", "Litre",
    "MiliLitre", "Feet", "SqFeet", "Dozens", "Tonnes" , "Inches" ];
  final String item = "pcs , pkt , btl , cm , m , km , sqm , yd , pch , gm , kg , l , ml , ft , sqft , dzs , t , in ";
  var doc;
  var menulist=[];
  String date="";
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
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

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
        }) == -1) {
          items.add(DropdownMenuItem(
            child:  Row(children: [Container(width: 100,child: Text('${wordPair}'),) ,Text('${itemunitlist[items.length]}'), ],),
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
  Future<List> getmenulist(us)async{
    var menulist=[];
    var url= Uri.https(menuapi, 'Item/items',);
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
        if(this.mounted){
      setState((){
        menulist.add(jnResponse);
      });}
      }
    }
    return menulist;
  }
  Future<void> getcurrentuser()async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
      var response= await http.get(url );
      print(response.body);
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
                child:FutureBuilder<List>(
                  future:  getmenulist(userid),
                  builder: (context, snapshot) {
                  if (snapshot.hasError) {
                  return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                  return snapshot.data!.isNotEmpty?ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        print('uytrfdxcvbhjuytgf  ----    ${snapshot.data![index]}');
                            return Card(
                          elevation: 4,
                          child: ListTile(
                            leading:  Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey,width: 1)),
                                 child:IconButton(
                                  icon: const Icon(Icons.edit,),
                                  onPressed: ()async {String?selectedValueSingleMenu;
                                  String itemname= snapshot.data![index]['item_name'].toString();
                                  String itemcost= snapshot.data![index]['item_price_per_unit'].toString();
                                  await FirebaseAnalytics.instance.logEvent(
                                    name: "edit_menu_item",
                                    parameters: {
                                      "user_id":  userid,
                                    },
                                  );
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
                                              height: 350,
                                              child:SingleChildScrollView(child:Column(
                                                children: [
                                                  TextField(
                                                    decoration: InputDecoration( border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                      prefixIcon:Icon(Icons.shopping_cart),hintText: 'Enter Item Name'),
                                                    controller: TextEditingController(text: itemname),
                                                    onChanged: (String value) {
                                                      itemname = value.trim();
                                                    },
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Container(
                                                      decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                                          borderRadius: BorderRadius.circular(5)),
                                                      child:SearchChoices.single(
                                                        displayClearIcon: false,
                                                        isExpanded: true,
                                                        hint: "Select stock unit",
                                                        searchHint: "Select stock unit",
                                                        items: items,
                                                        value: selectedValueSingleMenu,
                                                        onChanged: (value) {
                                                          print(value);
                                                          setState(() {
                                                            selectedValueSingleMenu = value;
                                                          });
                                                        },
                                                      )),
                                                  SizedBox(height: 10,),
                                                  Text(selectedValueSingleMenu!=null?
                                                  "Selling price per $selectedValueSingleMenu (including taxes)"
                                                      :"Selling price per unit (including taxes)"),
                                                  SizedBox(height: 10,),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                      borderSide: BorderSide(),
                                                    ),
                                                        prefixIcon: Icon(Icons.currency_rupee),
                                                        hintText: 'Price per unit (including taxes)'),
                                                    controller: TextEditingController(text: itemcost),keyboardType: TextInputType.number,
                                                    onChanged: (String value) {
                                                      itemcost = value.trim();
                                                    },
                                                  ),
                                                ],
                                              )),
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
                                                        print(file);CheckUserConnection();
                                                        if(itemname.isEmpty ||itemcost.isEmpty || itemcost.startsWith("0",0)||selectedValueSingleMenu
                                                            ==null){
                                                          setState((){edititem= false;
                                                          edititembtn= true;});
                                                          Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");}
                                                        else{
                                                         /* var url = Uri.https(menuapi, 'Item/item',);
                                                          var response= await http.get(url );
                                                          if (response.body.isEmpty) {*/
                                                            var murl = Uri.https(menuapi, 'Item/item',{'id':snapshot.data![index]['id'].toString() });
                                                            var response = await http.post(murl,
                                                              headers: <String, String>{
                                                                'Content-Type': 'application/json; charset=UTF-8',
                                                              },
                                                              body: jsonEncode(<String, String>{
                                                                "id":snapshot.data![index]['id'].toString(),
                                                                "user_id": userid,
                                                                "item_id": snapshot.data![index]['item_id'].toString(),
                                                                "item_unit": selectedValueSingleMenu.toString(),
                                                                "item_name": itemname,
                                                                "item_price_per_unit": itemcost}),);
                                                            print(response.body );
                                                            print(response.statusCode);
                                                            if(response.statusCode==200){
                                                              // await updateStockifexist(snapshot.data![index]['item_id'].toString(),
                                                              //     itemname, itemcost);
                                                              setState((){edititem= false;
                                                              edititembtn= true;
                                                              });Navigator.pop(context);
                                                            }
                                                          }
                                                      // }
                                                        },child: Text('UPDATE', style: TextStyle(color: Colors.white),),
                                                      ),),),],)
                                            ],
                                          );});
                                      });
                                  },
                                )),
                            title: Text(snapshot.data![index]['item_name'].toString()),
                            subtitle:Container(
                              child:Text(snapshot.data![index]['item_price_per_unit'].toString()),),
                            trailing: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey,width: 1)),
                                child:IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                var id=snapshot.data![index]['id'] ;
                                var murl = Uri.https(menuapi, 'Item/item',);
                                final http.Response response = await http.delete(
                                  murl,
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                    body: jsonEncode(<String, String>{
                                    "id":id,})
                                );
                                print(id);
                                print(response.body);
                                print(response.statusCode);
                               }
                            )),
                          ),
                        );
                      }): Center(child:
                  Column(children:[
                    SizedBox(height: 15,),
                    Lottie.asset("assets/animations/noitemerror.json", height: 250, width: 300),
                    SizedBox(height: 10,),
                    Text("You haven't added any inventory yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    TextButton(onPressed: ()async{
                      await FirebaseAnalytics.instance.logEvent(
                        name: "selected_add_menu_item",
                        parameters: {
                          "user_id":  userid,
                        },
                      );
                      openmenuentrydialog(context);
                    }, child: Container(
                        decoration: BoxDecoration(
                            color:Colors.blue,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        padding: EdgeInsets.all(15),
                        child:Text("ADD INVENTORIES/ITEMS", style:TextStyle(color:Colors.white))))
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
        floatingActionButton:  TextButton(
              onPressed: () {String ?selectedValueSingleMenu;
                showDialog(
                    context: context,
                    builder:  (BuildContext context)
                    {
                      return StatefulBuilder(builder: (BuildContext context, setState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          title: const Text("Add Items"),
                          content: Container(
                            width: 400,
                            height: 350,
                            child:SingleChildScrollView(child: Column(
                              children: [
                                TextField(decoration: InputDecoration( border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),prefixIcon:Icon(Icons.shopping_cart_outlined),
                                    hintText: 'Enter Item Name'),
                                  onChanged: (String value) {
                                    description = value.trim();
                                  },
                                ),
                                SizedBox(height: 10,),
                                Row(children:[
                                  Container(width:250,
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5)),
                                    child:SearchChoices.single(
                                      searchInputDecoration: InputDecoration(
                                          hintText: "Unit",
                                          labelText: "Unit",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                          prefixIcon: Icon(
                                              Icons.production_quantity_limits)),
                                      isExpanded: true,
                                      hint: "Select item unit",
                                      searchHint: "Select item unit",
                                      items: items,
                                      value: selectedValueSingleMenu,
                                      onChanged: (value) {
                                        print(value);
                                        setState(() {
                                          selectedValueSingleMenu = value;
                                        });
                                      },
                                    )),
                                ]),
                                SizedBox(height: 10,),
                                Text(selectedValueSingleMenu!=null?
                                "Selling price per $selectedValueSingleMenu (including taxes)"
                                    :"Selling price per unit (including taxes)"),
                                SizedBox(height: 10,),
                                TextField(
                                  decoration: InputDecoration( border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                   prefixIcon: Icon(Icons.currency_rupee), hintText: 'Price per unit (including taxes)'),
                                  keyboardType:TextInputType.number,
                                  onChanged: (String value) {
                                    investment = value.trim();
                                  },
                                ),
                              ],
                            )),
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
                    additembtn=false;
                    additem = true;
                    });
                    CheckUserConnection();
                    if(description.isEmpty || investment.isEmpty ||investment.startsWith("0") || selectedValueSingleMenu==null){
                    Fluttertoast.showToast(msg: "Fields  cannot be empty or 0.");
                    setState(() {
                    additembtn= true;
                    additem = false;
                    });}else{
                   /* List<MenuItems> MenuItemss = await Amplify.DataStore.query(MenuItems.classType,
                    where:MenuItems.USER_ID.eq(userid).and(MenuItems.ITEM_NAME.eq(description)));
                    if(MenuItemss.isEmpty){*/
                    String id = DateFormat("yyyyMMddHHmmss").format(
                    DateTime.now());
                    await createitem(id, description, investment, selectedValueSingleMenu);
                    setState((){additembtn= true;
                    additem = false;});
                    Navigator.pop(context);
                    // await Future.delayed(const Duration(seconds: 1), (){
                    showDialog(context: context, builder: (BuildContext context){
                    return StatefulBuilder(builder: (BuildContext context, setState) {
                    return AlertDialog(
                    content:Container(height: 300,
                    child:
                    Center(child: Lottie.asset("assets/animations/placeorder.json"),)
                    ));
                    });//});
                    });Navigator.pop(context);/*}
                    else{setState((){additembtn= true;
                    additem = false;});setdocument();
                    Fluttertoast.showToast(msg: "Itemname already exist.");}*/}

                                        }, child: Text('ADD', style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),]),
                          ],
                        );
                      });
                    });
              },
              child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                // border: Border.all(3),
                color: Colors.blue,),
                  padding:EdgeInsets.all(10),
                  width:120,
                  // height: 40,
                  child:Row(
                      children:[Icon(Icons.add, color: Colors.white,),
                        Text("NEW ITEM", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center, )
                      ])),
            ),
      ));
  }
  openmenuentrydialog(context){
    String ?selectedValueSingleMenu;
    showDialog(
        context: context,
        builder:  (BuildContext context)
        {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text("Add Items"),
              content: Container(
                width: 400,
                height: 250,
                child: Column(
                  children: [
                    TextField(decoration: InputDecoration( border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),prefixIcon:Icon(Icons.shopping_cart_outlined),
                        hintText: 'Enter Item Name'),
                      onChanged: (String value) {
                        description = value.trim();
                      },
                    ),
                    SizedBox(height: 10,),
                    Row(children:[
                      Container(width:250,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child:SearchChoices.single(
                            searchInputDecoration: InputDecoration(
                                hintText: "Unit",
                                labelText: "Unit",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                prefixIcon: Icon(
                                    Icons.production_quantity_limits)),
                            isExpanded: true,
                            hint: "Select item unit",
                            searchHint: "Select item unit",
                            items: items,
                            value: selectedValueSingleMenu,
                            onChanged: (value) {
                              print(value);
                              setState(() {
                                selectedValueSingleMenu = value;
                              });
                            },
                          )),
                    ]),
                    SizedBox(height: 10,),
                    TextField(
                      decoration: InputDecoration( border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                          prefixIcon: Icon(Icons.currency_rupee), hintText: 'Price per unit (including taxes)'),
                      keyboardType:TextInputType.number,
                      onChanged: (String value) {
                        investment = value.trim();
                      },
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
                                additembtn=false;
                                additem = true;
                              });
                              CheckUserConnection();
                              if(description.isEmpty || investment.isEmpty ||investment.startsWith("0") || selectedValueSingleMenu==null){
                                Fluttertoast.showToast(msg: "Fields  cannot be empty or 0.");
                                setState(() {
                                  additembtn= true;
                                  additem = false;
                                });}else{
                                /*List<MenuItems> MenuItemss = await Amplify.DataStore.query(MenuItems.classType,
                                    where:MenuItems.USER_ID.eq(userid).and(MenuItems.ITEM_NAME.eq(description)));
                                if(MenuItemss.isEmpty){*/
                                  String id = DateFormat("yyyyMMddHHmmss").format(
                                      DateTime.now());
                                  await createitem(id, description, investment, selectedValueSingleMenu);
                                  setState((){additembtn= true;
                                  additem = false;});
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (BuildContext context){
                                    return StatefulBuilder(builder: (BuildContext context, setState) {
                                      return AlertDialog(
                                          content:Container(height: 300,
                                              child:
                                              Center(child: Lottie.asset("assets/animations/placeorder.json"),)
                                          ));
                                    });//});
                                  });Navigator.pop(context);/*}
                                else{setState((){additembtn= true;
                                additem = false;});setdocument();
                                Fluttertoast.showToast(msg: "Itemname already exist.");}*/}

                            }, child: Text('ADD', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),]),
              ],
            );
          });
        });
  }
  String getHumanReadableDate( int dt ) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);

    return DateFormat('dd MMM yyyy').format(dateTime);
  }
  Future<void> createitem(String itid, itnam, itprice, unit) async {

    var url = Uri.https(menuapi, 'Item/item',{'id': userid+itnam});
    var response= await http.get(url );
    if (response.body.isEmpty) {
      var murl = Uri.https(menuapi, 'Item/item',);
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+itnam,
          "user_id": userid,
          "item_id": itid,
          "item_unit": unit,
          "item_name": itnam,
          "item_price_per_unit": itprice}),);
    }
    else{
      var murl = Uri.https(menuapi, 'Item/item',);
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+itnam,
          "user_id": userid,
          "item_id": itid,
          "item_unit": unit,
          "item_name": itnam,
          "item_price_per_unit": itprice}),);
    }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

  }
  updateStockifexist(String id, String name, String cost) async{
      List<StockList> StockLists = await Amplify.DataStore.query(StockList.classType,
      where: StockList.USER_ID.eq(userid).and(StockList.STOCK_ID.eq(id)));
      if(StockLists.isNotEmpty){
        final updatedItem = StockLists[0].copyWith(
            user_id: StockLists[0].user_id,
            stock_id: StockLists[0].stock_id,
            stock_name:name,
            stock_quantity: StockLists[0].stock_quantity,
            stock_investment: StockLists[0].stock_investment,
            selling_price_per_unit: cost,
            constant_quantity: StockLists[0].constant_quantity,
            stock_status: StockLists[0].stock_status,);
        await Amplify.DataStore.save(updatedItem).whenComplete((){print("finished");
        updateexpanseitemname(id, name);});
      }else{ setState((){edititem= false;
      edititembtn= true;
      });}
  }

  updateexpanseitemname(String stockid, String itemname) async {
    print("diwjdhufe");
      List<ExpanseRecord> ExpanseRecords = await Amplify.DataStore.query(ExpanseRecord.classType,
     where: ExpanseRecord.USER_ID.eq(userid).and(ExpanseRecord.EXPANSE_RECORD_ID.eq(stockid)));
    if(ExpanseRecords.isNotEmpty){
      final updatedItem = ExpanseRecords[0].copyWith(
          user_id: ExpanseRecords[0].user_id,
          expanse_id: ExpanseRecords[0].expanse_id,
          expanse_record_id: ExpanseRecords[0].expanse_record_id,
          expanse_name: itemname,
          description: ExpanseRecords[0].description,
          investment: ExpanseRecords[0].investment,
          date: ExpanseRecords[0].date,
          time: ExpanseRecords[0].time,
          status: ExpanseRecords[0].status);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete(() async {print("expansetckreportnamefinished");

      setState((){edititem= false;
      edititembtn= true;
      });
      });
    }else{ setState((){edititem= false;
    edititembtn= true;
    });}
  }
}

