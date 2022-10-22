import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:upi_india/upi_india.dart';
import '../models/CustomerLis.dart';
import '../models/MenuItems.dart';
import '../models/PendingOrderItems.dart';
import '../models/PendingOrders.dart';
import '../models/RentedItems.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../models/Suppliers.dart';
import '../models/TempIte.dart';
import '../reusable_widgets/apis.dart';
import 'Orders.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Addorder extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Addorder({Key? key, this.ccid}) : super(key: key);
  final ccid;
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
            home:  ChatorderPage(clid: ccid),
          );
        });
  }
}
class ChatorderPage extends StatefulWidget {
  const ChatorderPage({Key? key,this.clid}) : super(key: key);
  final clid;
  @override
  State<ChatorderPage> createState() => _ChatItemsState(clientid: clid);
}
class _ChatItemsState extends State<ChatorderPage> with SingleTickerProviderStateMixin {
  _ChatItemsState({this.clientid});
  final clientid;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var sum=0.0;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  var upistatus;
  var engaged= "Occupied", vaccant= "Vaccant";
  var doc;
  bool ActiveConnection = false;
  var blue;
  String T = "", supplier= "Supplier";
  String pending= "Pending", delivered= "Delivered", cancelled= "Cancelled", sent="Sent", received="Received";
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
  String imgurl= "https://dominionmartialarts.com/wp-content/uploads/2017/04/default-image-620x600.jpg";
  File? file;
  var total=0.0;
  List<String> itemlist=[];
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  String date="", transactionid="";
  String time="";
  String userid= "";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String month="Month", day="Day", hour= "Hour", minute= "Minute", year="Year";

  String restroname="", phoneno="", address="", areacode="", profileimg="",paystatus="", paymode= "", deliverymode="";
  String itemimage="", shopname="", shopmobno="", cuid="", cshpname="";
  String? selectedValueSingleMenu;
  String dmodesdel= "delivery", demodestk= "takeaway",  shno="";
  List<DropdownMenuItem> items = [];
  var  orderlist=[];
  var totalcost=0;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  String customerid="", customername="";
  bool addorder= false, addorderbtn=true, senddata= false;
  String? selectedValueSingleDialog;
  @override
  void initState() {
    CheckUserConnection();
    // init();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    getuserdetails();
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
  }
  getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){    await getorderlist(counter);
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
      var response= await http.get(url );
      if(response.body.isNotEmpty){
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        if (this.mounted) {
          setState(() {
            restroname = jsonResponse['shop_name'].toString();
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }


    }
    else{runApp(LoginScreen());}
  }
  Future<void> getorderlist(us)async{
    var url = Uri.https(pendingorderapi, 'Pendingorder/pendingorders');
    var response = await http.get(url);
    var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++) {
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if (jnResponse['user_id'] == us) {
        setState(() {
          orderlist.add(jnResponse);
        });
      }
    }
    print(orderlist);
  }
  Future <List> gettemp(us)async {
    var temp=[];
    var turl = Uri.https(tempitemapi, 'TempItemList/tempitems',);
    var tresponse = await http.get(turl);
    if(tresponse.body.isNotEmpty){
      print(tresponse);
    sum = 0.0;
    var tagObjsJson = convert.jsonDecode(tresponse.body)['products'] as List;
    for (int i = 0; i < tagObjsJson.length; i++) {
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if (jnResponse['user_id'] == us && jnResponse['token_no'] == "") {
        setState(() {
          temp.add(jnResponse);
          sum = sum + double.parse(jnResponse['item_total'].toString());
        });
      }
    }
  }
    return temp;
  }
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'logofront',
            ),
          ),
        );
      }
    });
  }
  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  String paid= "Paid", payltr= "Pay later", payondelivery= "Pay on delivery";
  bool upi=false, cash= false, nw= false, timdel= false, paylater= false, delivery= false, takeaway= false;
  List<int> selectedItemsMultiMenu = [];
  List<String> itemid= <String>[];
  List<String> itemimg= <String>[];
  List<String> itemnamelist= <String>[];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
          padding:EdgeInsets.all(4),
          child:Icon(Icons.arrow_back, color:Theme.of(context).primaryColor,))
            ,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>  IncompleteOrders()));}, ),
          title: Text("Add order", style:TextStyle(color:Theme.of(context).primaryColor,)),
        ),
        body:RefreshIndicator(onRefresh: ()async{},
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
            child:
          Container(
            child: Column(children: [
              FutureBuilder<List>(
          future:  gettemp(userid),
          builder: (context, napshot) {
            if (napshot.hasError) {
              return Text('Something went wrong');
            } else if (napshot.hasData || napshot.data!= null) {
              return
              ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: napshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                          elevation: 4,
                          child: ListTile(
                              leading: Text((index+1).toString(), style:TextStyle(fontSize:17)),
                              title: Row(children: [Container(width:120,child:Text(napshot.data![index]['item_name'].toString())) ,
                                SizedBox(width:10,),Text("₹"+napshot.data![index]['item_total'].toString()), ],),
                              subtitle: Row(children:[Container(width:120,child:
                              Text("₹"+napshot.data![index]['item_price_per_unit'].toString()+"/"+napshot.data![index]['item_unit'].toString())),
                                SizedBox(width: 10,),Text(napshot.data![index]['item_quantity'].toString()!=""?
                                "Qty: "+napshot.data![index]['item_quantity'].toString():
                                "🕝 "+napshot.data![index]['rented_duration'].toString()+"/"+napshot.data![index]['item_unit'].toString()), ]),
                              trailing: IconButton(icon:Icon(Icons.delete), onPressed: ()async{
                                print("delete item ${napshot.data![index]['item_id']}");
                                var url= Uri.https(rentedapi, 'RentedItem/renteditem',
                                  {'id':napshot.data![index]['item_id']}, );
                                var response= await http.get(url );
                                if(response.body.isNotEmpty){
                                  print("exist     ${response.body}");
                                  var tagObjsJson = jsonDecode(response.body)as Map<String, dynamic>;
                                  var resp = await http.post(url,
                                    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
                                    body: jsonEncode(<String, String>{
                                      "id":tagObjsJson['id'].toString(),
                                      "user_id":tagObjsJson['user_id'],
                                      "product_id": tagObjsJson['product_id'],
                                      "rented_item_name": tagObjsJson['rented_item_name'],
                                      "charger_per_duration": tagObjsJson['charger_per_duration'],
                                      "product_engagement": "",
                                      "rented_duration": tagObjsJson['rented_duration'],
                                      "rentout_to_client_id": tagObjsJson['rentout_to_client_id']}),);
                                  if(resp.statusCode==200){
                                    print("rent deleted  ${resp.statusCode}");
                                    var turl= Uri.https(tempitemapi, 'TempItemList/tempitem',);
                                    var response = await http.delete(turl,   headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                      body: jsonEncode(<String, String>{
                                        "id": napshot.data![index]['id'],
                                       }));
                                    if(response.statusCode==200){
                                      sum= sum-double.parse(napshot.data![index]['item_total']);
                                      print("temp deleted  ${response.statusCode}");
                                    }
                                  }
                                }
                                else{
                                 var turl= Uri.https(tempitemapi, 'TempItemList/tempitem',);
                                  var response = await http.delete(turl,   headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  }, body: jsonEncode(<String, String>{
                                        "id": napshot.data![index]['id'],
                                      }));
                                  if(response.statusCode==200){
                                    
                                  }
                                }
                              },),
                          )
                      ) ;
                    });
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.blueGrey,
                ),
              ),
            );
          },
        ),
             Divider(height:2),
             Container( padding:EdgeInsets.all(15),
                 margin:EdgeInsets.only(right:10),child: Row(mainAxisAlignment:MainAxisAlignment.end,children: [
                   Text("Total: "), Text(sum.toString())],))
            ],),
          ), ),),
        floatingActionButton:Column(  mainAxisAlignment: MainAxisAlignment.end,
            children: [Container(width:160,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: TextButton(
              onPressed: () async {
                await FirebaseAnalytics.instance.logEvent(
                  name: "Rentals_service",
                  parameters: {
                    "user_id": userid,
                  },
                );
                CheckUserConnection();
                openrentaldialog(context);
                },
              child:Row(children:[Icon(Icons.add_shopping_cart,color: Colors.white),SizedBox(width:8),Text("ADD RENTALS".tr(),style: TextStyle(fontSize: 15,color: Colors.white ),textAlign: TextAlign.center,
              )])  ,
            )),
          SizedBox(height:15),
        Container(width:130,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child: TextButton(
            onPressed: () async {
              await FirebaseAnalytics.instance.logEvent(
                name: "Items_service",
                parameters: {
                  "user_id": userid,
                },
              );
              CheckUserConnection();
              opendialog(context);
            },
                child:Row(children:[Icon(Icons.add_shopping_cart,color: Colors.white),SizedBox(width:8),Text("ADD ITEMS".tr(),style: TextStyle(fontSize: 15,color: Colors.white ),textAlign: TextAlign.center,
            ),]),
          )),]
        ),
        bottomNavigationBar:senddata==false? Container(width:130,
            height: 45,
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child:TextButton(child:Text("ADD ORDER", style: TextStyle(color: Colors.white),),onPressed: () async {
             var templist=await gettemp(userid);
              print(templist.length);
           if(templist.isNotEmpty){
              await FirebaseAnalytics.instance.logEvent(
                name: "Added_Order",
                parameters: {
                  "user_id": userid,
                },
              );
              setState((){senddata==true;});
            var total =0.0;
            var id=  DateFormat("yyyyMMddHHmmss").format(DateTime.now());
            await sendorders(context, id,"");
              setState((){senddata==false;});
                Navigator.push(context, MaterialPageRoute(builder: (context) => IncompleteOrders()));
           }
              else{
                Fluttertoast.showToast(msg: "Kindly add items to place order.");
           }
        }, )):Center(child: CircularProgressIndicator(),),
      ),);
  }
  additemquantityfromstock(String stockname, String quantity, String od) async {
    var url = Uri.https(stockapi, 'StockItemList/stockitem', {'id':od});
    var res= await http.get(url);
    if(res.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(res.body) as Map<String, dynamic>;
      var response = await http.post(url,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":tagObjsJson['id'].toString(),
          "user_id": tagObjsJson['user_id'],
          "stock_id":tagObjsJson['stock_id'],
          "stock_name": tagObjsJson['stock_name'],
          "stock_quantity": (double.parse(tagObjsJson['stock_quantity'])+double.parse(quantity)).toString(),
          "stock_investment": tagObjsJson['stock_investment'],
          "selling_price_per_unit": tagObjsJson['selling_price_per_unit'],
          "constant_quantity":tagObjsJson['constant_quantity'],
          "stock_status": tagObjsJson['stock_status'],
          "stock_unit": tagObjsJson['stock_unit']}),);
      if(response.statusCode==200){
        updateadditionstockrecords(tagObjsJson['stock_id'], quantity, stockname,tagObjsJson['selling_price_per_unit'] ,tagObjsJson['stock_unit'] );
      }
    }
  }
  updateadditionstockrecords(String stockid, String quantity, String stockname, String sellprice, String unit) async {
    var url = Uri.https(stockrecapi, 'Stockrecord/stockrecord');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      "id":userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
      "user_id": userid,
      "stock_id": stockid,
      "stock_record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
      "stock_quantity": quantity,
      "stock_investment": (double.parse(sellprice)*double.parse(quantity)).toString(),
      "stock_unit": unit,
      "selling_price_per_unit": sellprice,
      "stock_name": stockname,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "time": DateFormat("HH:mm:ss").format(DateTime.now())}),);
    print('stockreport status: ${response.statusCode}');
  }
  opendialog(BuildContext context) async{
    await FirebaseAnalytics.instance.logEvent(
      name: "open_items_to_order",
    );
    String itemimage="", itemname="", itemprice="", quantity="", itemid='';
    CheckUserConnection();
    showDialog(
        context: context,
        builder: (BuildContext context)
        {var unit="";
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("Add Item".tr()),
              content:   Container(
                width: 400,
                margin: EdgeInsets.only(top: 15, bottom: 16),
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, left: 5, right: 5),
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      children:[
                        FutureBuilder<List>(
                            future:  menulist(userid),
                            builder: (BuildContext context, snapshot) {
                               if (!snapshot.hasData) return Container();
                              return SearchChoices.single(
                                items: snapshot.data!.map((value) {
                                  return DropdownMenuItem(
                                    value: value['id'],
                                    child: Row(children: [Container(width: 100,child: Text('${value['item_name']}'),) ,Text('₹'+'${value['item_price_per_unit']}'), ],),
                                  );
                                }).toList(),
                                value: selectedValueSingleDialog,
                                hint: "Select one",
                                searchHint: "Select one",
                                onChanged: (value) {
                                  setState(() async {
                                    selectedValueSingleDialog = value;
                                    var url= Uri.https(menuapi, 'Item/item',{'id': value});
                                    var response= await http.get(url );
                                    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                                    itemid= jsonResponse['id'].toString();
                                      unit= jsonResponse['item_unit'].toString();
                                      itemname=jsonResponse['item_name'].toString();
                                      itemprice=jsonResponse['item_price_per_unit'].toString();
                                      price= jsonResponse['item_price_per_unit'].toString();
                                  });
                                },
                                isExpanded: true,
                              );}),
                        SizedBox(height: 10,),
                        Row(children:[
                          Container(width:170,
                            child:  TextField(
                              decoration: InputDecoration(
                                  hintText: "Quantity".tr(),
                                  labelText: "Quantity",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  prefixIcon: Icon(Icons.production_quantity_limits)),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(()=>total= double.parse(itemprice)* double.parse(value.trim()));
                                quantity = value;
                              },),), Text(unit)]),
                        SizedBox(height: 10,),
                        Container(
                            child:Row(children: [Container(width:125,
                                padding: EdgeInsets.only(left: 35, top: 8, bottom: 8),
                                child:Text("Total")),
                              Container(
                                  padding: EdgeInsets.only(right: 15, top: 8, bottom: 8),
                                  child:Text(total.toString()))],)
                        ),
                      ]
                  ),
                ),
              ),
              actions: <Widget>[
                Column(children: [
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: additem,
                      child: Container(
                          margin: EdgeInsets.only(top: 50, bottom: 30),
                          child: CircularProgressIndicator()
                      )
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: additembtn,
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius
                            .circular(15), color: Colors.blue,
                        ), width: double.maxFinite,
                        height: 45,
                        child:  TextButton(onPressed: ()async{setState((){additem=true; additembtn= false;});
                        if(itemname.isEmpty || itemname.startsWith("0")){
                          setState((){additem=false; additembtn= true;});
                          Fluttertoast.showToast(msg: "Kindly select item.");
                        }
                        else if(quantity.isEmpty|| quantity.startsWith("0")){
                          setState((){additem=false; additembtn= true;});
                          Fluttertoast.showToast(msg: "Kindly enter quantity.");
                        }
                        else{
                          var turl= Uri.https(tempitemapi, 'TempItemList/tempitem',);
                          var response = await http.post(turl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                            "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                            "user_id": userid,
                            "orderid": "",
                            "token_no": "",
                            "item_id": itemid,
                            "item_name": itemname,
                            "item_price_per_unit": itemprice,
                            "item_unit": unit,
                            "item_quantity": quantity,
                            "rented_duration": "",
                            "item_total": (double.parse(quantity)*double.parse(itemprice)).toString()}),);
                          if(response.statusCode==200){
                          await FirebaseAnalytics.instance.logEvent(
                            name: "selected_items_to_order",
                          );
                          Navigator.pop(context);
                          }
                         }

                        }, child: Container(height:35, child:Text("ADD", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
                  ),]),
              ],
            );
          });
        });
  }

  Future<List> renteditems(user)async{
    var rentedlist=[];
    var url= Uri.https(rentedapi, 'RentedItem/renteditems', );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if(jnResponse['user_id']==user) {
          setState(() {
            rentedlist.add(jnResponse);
          });
        }
      }
    }
    return rentedlist;
  }

  openrentaldialog(BuildContext context)async {
   await FirebaseAnalytics.instance.logEvent(
     name: "open_service_to_book",
   ); var ttl=0.0;var unit="";
   String itemid="", itemname="", itemprice="", quantity="" ;  var additem=false, additembtn=true;
    CheckUserConnection();
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
        return StatefulBuilder(builder: (BuildContext context, setState) {

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: Text("Add Rental Item".tr()),
            content:   Container(
              width: 400,
              margin: EdgeInsets.only(top: 15, bottom: 16),
              padding: EdgeInsets.only(
                  top: 10, bottom: 10, left: 5, right: 5),
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    children:[
                      FutureBuilder<List>(
                          future:  renteditems(userid),
                          builder: (BuildContext context, snapshot) {
                             if (!snapshot.hasData) return Container();
                            return SearchChoices.single(
                              items: snapshot.data!.map((value) {
                                return DropdownMenuItem(
                                  value: value['id'],
                                  child:Container(padding:EdgeInsets.all(6),decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),
                                      color: value['product_engagement']==engaged?Colors.blueAccent:null),child:
                                  Row(children: [Container(width: 100,child: Text('${value['rented_item_name']}', )),
                                    Text('₹'+'${value['charger_per_duration']}'),],))
                                );
                              }).toList(),
                              value: selectedValueSingleDialog,
                              hint: "Select one",
                              searchHint: "Select one",
                              onChanged: (value) async {
                                var url= Uri.https(rentedapi, 'RentedItem/renteditem',{'id': value});
                                var response= await http.get(url );
                                if(response.body.isNotEmpty){
                                  var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                                    if(tagObjsJson['product_engagement']!=engaged) {
                                      selectedValueSingleDialog= value;
                                      setState((){ itemid= tagObjsJson['id'].toString();
                                      itemname=tagObjsJson['rented_item_name'].toString();
                                      itemprice=tagObjsJson['charger_per_duration'].toString();
                                      price= tagObjsJson['charger_per_duration'].toString();
                                      unit= tagObjsJson['rented_duration'].toString();   });
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "Select item is not available. Try again later.");
                                    }
                                }
                              },
                              isExpanded: true,
                            );}),
                      SizedBox(height: 10,),
                     Row(children: [
                       Container(width:170,
                         child: TextField(
                           decoration: InputDecoration(
                               hintText: "Duration".tr(),
                               labelText: "Duration",
                               border: OutlineInputBorder(
                                 borderSide: BorderSide(),
                               ),
                               prefixIcon: Icon(
                                   Icons.timer_sharp)),
                           keyboardType: TextInputType.number,
                           onChanged: (value) {
                             setState(()=>ttl= double.parse(price)* double.parse(value));
                             quantity = value;
                           },)
                     ),Container(width:60,
                           margin: EdgeInsets.only(left: 5),
                         child: Text(unit)
                     ),],) ,
                      SizedBox(height: 10,),
                      Container(
                          child:Row(children: [Container(width:125,
                              padding: EdgeInsets.only(left: 35, top: 8, bottom: 8),
                              child:Text("Total")),
                            Container(
                                padding: EdgeInsets.only(right: 15, top: 8, bottom: 8),
                                child:Text(ttl.toString()))],)
                      ),
                    ]
                ),
              ),
            ),
            actions: <Widget>[
              Column(children: [
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: additem,
                    child: Container(
                        margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CircularProgressIndicator()
                    )
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: additembtn,
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius
                          .circular(15),
                        color: Colors.blue,
                      ), width: double.maxFinite,
                      height: 45,
                      child:  TextButton(onPressed: ()async{setState((){additem=true; additembtn= false;});
                      String orderid= DateFormat("yyMMddHHmmss").format(DateTime.now());
                      print(clientid);
                      if(itemname.isEmpty && quantity.isEmpty){
                        print("oiuytrfgbn");
                        setState((){additem=false; additembtn= true;});
                        Fluttertoast.showToast(msg: "Kindly fill all required fields.");
                      }
                      else{
                        print("$itemname  vgyuikmnbvfrtyu $quantity" );
                        var turl= Uri.https(tempitemapi, 'TempItemList/tempitem',);
                        var response = await http.post(turl,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":userid+ DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                            "user_id": userid,
                            "orderid": "",
                            "token_no": "",
                            "item_id": itemid,
                            "item_name": itemname,
                            "item_price_per_unit": itemprice,
                            "item_unit": unit,
                            "item_quantity": "",
                            "rented_duration": quantity,
                            "item_total": (double.parse(quantity)*double.parse(itemprice)).toString()}),);
                        if(response.statusCode==200){ var rurl= Uri.https(rentedapi, 'RentedItem/renteditem',{"id":itemid});
                        var res= await http.get(rurl);
                        if(res.body.isNotEmpty){
                          var tagObjsJson = jsonDecode(res.body)as Map<String, dynamic>;
                          final http.Response response = await http.post(rurl,
                              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
                              body: jsonEncode(<String, String>{
                                "id":tagObjsJson['id'],
                                "user_id":tagObjsJson['user_id'],
                                "product_id":  tagObjsJson['product_id'],
                                "rented_item_name": tagObjsJson['rented_item_name'],
                                "charger_per_duration": tagObjsJson['charger_per_duration'],
                                "product_engagement": engaged,
                                "rented_duration": tagObjsJson['rented_duration'],
                                "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                              }));
                          if(response.statusCode==200){
                            print("rent enfgaeds");
                          }
                        }}
                          setState((){ additem=false; additembtn= true;
                          selectedValueSingleDialog="";});
                            
                         }
                      Navigator.pop(context);
                     }, child: Container(height:35, child:Text("ADD", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
                ),]),
            ],
          );
        });
        });
  }
  sendorders(BuildContext context, String id,String cid)  async {
    var templist=await gettemp(userid);
    print("tempnfbdgfd     ${templist.length}");
    var canplaceorder = false;
    Random random = Random();
    var ttl = 0.0;
    var tempit=[];
    int randomNumber = random.nextInt(80) + 10;
    var ran = randomNumber;
    String rndm = ran.toString();
    if(orderlist.isNotEmpty){
    for(int i=0; i<orderlist.length; i++){
      if(orderlist[i]['token_no']!=rndm) {print("not exist  $rndm");
      for (int i = 0; i < templist.length; i++) {
        print("object   fdsgvfbrtb   mf --- ${templist.length}");
        tempit.add(templist[i]['id'] );
        var sturl = Uri.https(stockapi, 'StockItemList/stockitem',
            {"id": templist[i]['item_id']});
        var response = await http.get(sturl);
        if (response.body.isNotEmpty) {
          print("object  ${response.body}");
          var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
          if (double.parse(tagObjsJson['stock_quantity']) >=
              double.parse(templist[i]['item_quantity'])) {
            canplaceorder = true;
            substractitemquantityfromstock(
                templist[i]['item_id'].toString(),
                templist[i]['item_name'].toString(),
                templist[i]['item_quantity'].toString());
            var url = Uri.https(
                pendingorderitemapi, 'Pendingitems/pendingitem');
            var response = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": userid +
                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "order_id": id,
                "token_no": rndm,
                "item_id": templist[i]['item_id'].toString(),
                "item_name": templist[i]['item_name'].toString(),
                "item_quantity": templist[i]['item_quantity']
                    .toString(),
                "item_price": templist[i]['item_price_per_unit']
                    .toString(),
                "item_total": templist[i]['item_total'].toString(),
                "item_unit": templist[i]['item_unit'].toString(),
                "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now()),
                "renting_duration": templist[i]['rented_duration']
                    .toString(),
                "Check_out_time": "",
                "item_status": pending}),);
            if (response.statusCode == 200) {
              print("stockitem added${templist[i]['item_name']}");
              await FirebaseAnalytics.instance.logEvent(
                name: "placed_orderitem",
              );
              ttl=ttl+double.parse( templist[i]['item_total'].toString());
            }
          }
          else {
            Fluttertoast.showToast(
                msg: "Sorry for inconvenience ${templist[i]['item_name']} is not available is not available in your stock, Kindly update your stock then place order.");
          }
        }
        else {
          var renturl = Uri.https(rentedapi, 'RentedItem/renteditem',
              {"id": templist[i]['item_id']});
          var response = await http.get(renturl);
          if (response.body.isNotEmpty) {
            var tagObjsJson = jsonDecode(response.body) as Map<
                String,
                dynamic>;
            canplaceorder = true;
            var url = Uri.https(
                pendingorderitemapi, 'Pendingitems/pendingitem');
            var ronse = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": userid +
                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "order_id": id,
                "token_no": rndm,
                "item_id": templist[i]['item_id'].toString(),
                "item_name": templist[i]['item_name'].toString(),
                "item_quantity": templist[i]['item_quantity']
                    .toString(),
                "item_price": templist[i]['item_price_per_unit']
                    .toString(),
                "item_total": templist[i]['item_total'].toString(),
                "item_unit": templist[i]['item_unit'].toString(),
                "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now()),
                "renting_duration": templist[i]['rented_duration']
                    .toString(),
                "Check_out_time": "",
                "item_status": pending}),);
            if (ronse.statusCode == 200) {
              print("pending addede ${ronse.statusCode}");
              var reonse = await http.post(renturl,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  "id": tagObjsJson['id'].toString(),
                  "user_id": tagObjsJson['user_id'],
                  "product_id": tagObjsJson['product_id'],
                  "rented_item_name": tagObjsJson['rented_item_name'],
                  "charger_per_duration": tagObjsJson['charger_per_duration'],
                  "product_engagement": "",
                  "rented_duration": tagObjsJson['rented_duration'],
                  "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                }),);
              if (reonse.statusCode == 200) {
                print("renteditem added${templist[i]['item_name']}");

                if (templist[i]['item_unit'].toString() == year) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: 365 *
                              int.parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == month) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: 30 *
                              int.parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == day) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: int
                              .parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == hour) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(
                              minutes: (double.parse(
                                  templist[i]['rented_duration']) * 60)
                                  .toInt()))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
              }
              await FirebaseAnalytics.instance.logEvent(
                name: "placed_orderitem",
              ); ttl=ttl+double.parse( templist[i]['item_total'].toString());

            }
          }
          else {print("exist in menu");
          canplaceorder = true;
          var url = Uri.https(
              pendingorderitemapi, 'Pendingitems/pendingitem');
          var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id": userid +
                  DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
              "user_id": userid,
              "order_id": id,
              "token_no": rndm,
              "item_id": templist[i]['item_id'].toString(),
              "item_name": templist[i]['item_name'].toString(),
              "item_quantity": templist[i]['item_quantity']
                  .toString(),
              "item_price": templist[i]['item_price_per_unit']
                  .toString(),
              "item_total": templist[i]['item_total'].toString(),
              "item_unit": templist[i]['item_unit'].toString(),
              "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                  DateTime.now()),
              "renting_duration": templist[i]['rented_duration']
                  .toString(),
              "Check_out_time": "",
              "item_status": pending}),);
          if (response.statusCode == 200) {print("added in menu");
          await FirebaseAnalytics.instance.logEvent(
            name: "placed_orderitemitem",
          );
          ttl=ttl+double.parse( templist[i]['item_total'].toString());
          }
          }
        }
      }
      if (canplaceorder == true) {
        var url = Uri.https(pendingorderapi, 'Pendingorder/pendingorder');
        var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": userid + id,
            "user_id": userid,
            'order_id': id,
            'token_no': rndm,
            'total': sum.toString(),
            'discount_amount': "0",
            'discount_percent': "0",
            'additional_amount': "0",
            'date': DateFormat("yyyy-MM-dd").format(
                DateTime.now()),
            'time': DateFormat("HH:mm:ss").format(
                DateTime.now()),
            'Advance_amount': "0",
            'pending_amount': sum.toString(),}),);
        if (response.statusCode == 200) {print("placedddbjhg");
        for (int i = 0; i < tempit.length; i++) {
          var url = Uri.https(tempitemapi, 'TempItemList/tempitem',
              {"id": tempit[i]});
          var response = await http.delete(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{"id": tempit[i]}),);
          if(response.statusCode==200){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>  IncompleteOrders()));
          }
          print("deletfg  ${tempit}  ${response.statusCode}");
        }
        setState(() {
          canplaceorder = false;
          addorder = false;
          addorderbtn = true;
        });
        }
      }
      }
      else {
        print("randhfhdh  exist $rndm");
        sendorders(context, id, cid);
      }
    }}
    else {
      print(" temp      ${templist.length}");
      for (int i = 0; i < templist.length; i++) {
        print("$i object   fdsgvfbrtb   mf --- ${templist.length}");
        tempit.add(templist[i]['id']);
        var url = Uri.https(stockapi, 'StockItemList/stockitem',
            {"id": templist[i]['item_id']});
        var response = await http.get(url);
        if (response.body.isNotEmpty) {
          print("object  ${response.body}");
          var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
          if (double.parse(tagObjsJson['stock_quantity']) >=
              double.parse(templist[i]['item_quantity'])) {
            canplaceorder = true;
            substractitemquantityfromstock(
                templist[i]['item_id'].toString(),
                templist[i]['item_name'].toString(),
                templist[i]['item_quantity'].toString());
            var url = Uri.https(
                pendingorderitemapi, 'Pendingitems/pendingitem');
            var response = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": userid +
                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "order_id": id,
                "token_no": rndm,
                "item_id": templist[i]['item_id'].toString(),
                "item_name": templist[i]['item_name'].toString(),
                "item_quantity": templist[i]['item_quantity']
                    .toString(),
                "item_price": templist[i]['item_price_per_unit']
                    .toString(),
                "item_total": templist[i]['item_total'].toString(),
                "item_unit": templist[i]['item_unit'].toString(),
                "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now()),
                "renting_duration": templist[i]['rented_duration']
                    .toString(),
                "Check_out_time": "",
                "item_status": pending}),);
            if (response.statusCode == 200) {
              print("stockitem added${templist[i]['item_name']}");
              await FirebaseAnalytics.instance.logEvent(
                name: "placed_orderitem",
              );
              ttl = ttl + double.parse(templist[i]['item_total'].toString());
            }
          }
          else {
            Fluttertoast.showToast(
                msg: "Sorry for inconvenience ${templist[i]['item_name']} is not available is not available in your stock, Kindly update your stock then place order.");
          }
        }
        else {
          var url = Uri.https(rentedapi, 'RentedItem/renteditem',
              {"id": templist[i]['item_id']});
          var response = await http.get(url);
          if (response.body.isNotEmpty) {
            var tagObjsJson = jsonDecode(response.body) as Map<
                String,
                dynamic>;
            canplaceorder = true;
            var url = Uri.https(
                pendingorderitemapi, 'Pendingitems/pendingitem');
            var ronse = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": userid +
                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "order_id": id,
                "token_no": rndm,
                "item_id": templist[i]['item_id'].toString(),
                "item_name": templist[i]['item_name'].toString(),
                "item_quantity": templist[i]['item_quantity']
                    .toString(),
                "item_price": templist[i]['item_price_per_unit']
                    .toString(),
                "item_total": templist[i]['item_total'].toString(),
                "item_unit": templist[i]['item_unit'].toString(),
                "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now()),
                "renting_duration": templist[i]['rented_duration']
                    .toString(),
                "Check_out_time": "",
                "item_status": pending}),);
            if (ronse.statusCode == 200) {
              var reonse = await http.post(url,
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(<String, String>{
                  "id": tagObjsJson['id'].toString(),
                  "user_id": tagObjsJson['user_id'],
                  "product_id": tagObjsJson['product_id'],
                  "rented_item_name": tagObjsJson['rented_item_name'],
                  "charger_per_duration": tagObjsJson['charger_per_duration'],
                  "product_engagement": engaged,
                  "rented_duration": tagObjsJson['rented_duration'],
                  "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                }),);
              if (reonse.statusCode == 200) {
                print("renteditem added${templist[i]['item_name']}");

                if (templist[i]['item_unit'].toString() == year) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: 365 *
                              int.parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == month) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: 30 *
                              int.parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == day) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(days: int
                              .parse(templist[i]['rented_duration'])))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
                if (templist[i]['item_unit'].toString() == hour) {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                        id: 6,
                        channelKey: 'alarm_channel',
                        title: 'Time alloted for ' +
                            templist[i]['item_name'].toString() +
                            ' has been expired ',
                        fullScreenIntent: true,
                        body: "Request your customer to checkout.",
                        // la NotificationLayout.Default,
                        displayOnBackground: true,
                        wakeUpScreen: true,
                        displayOnForeground: true,
                        category: NotificationCategory.Alarm,
                      ),
                      schedule: NotificationCalendar.fromDate(
                          date: DateTime.now().add(Duration(
                              minutes: (double.parse(
                                  templist[i]['rented_duration']) * 60)
                                  .toInt()))),
                      actionButtons: [
                        NotificationActionButton(key: "d", label: "Okay"),
                      ]
                  );
                }
              }
              await FirebaseAnalytics.instance.logEvent(
                name: "placed_orderitem",
              );
              ttl = ttl + double.parse(templist[i]['item_total'].toString());
            }
          }
          else {
            print("exist in menu");
            canplaceorder = true;
            var url = Uri.https(
                pendingorderitemapi, 'Pendingitems/pendingitem');
            var response = await http.post(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": userid +
                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "order_id": id,
                "token_no": rndm,
                "item_id": templist[i]['item_id'].toString(),
                "item_name": templist[i]['item_name'].toString(),
                "item_quantity": templist[i]['item_quantity']
                    .toString(),
                "item_price": templist[i]['item_price_per_unit']
                    .toString(),
                "item_total": templist[i]['item_total'].toString(),
                "item_unit": templist[i]['item_unit'].toString(),
                "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now()),
                "renting_duration": templist[i]['rented_duration']
                    .toString(),
                "Check_out_time": "",
                "item_status": pending}),);
            if (response.statusCode == 200) {
              print("added in menu");
              await FirebaseAnalytics.instance.logEvent(
                name: "placed_orderitemitem",
              );
              ttl = ttl + double.parse(templist[i]['item_total'].toString());
            }
          }
        }
      }
      if (canplaceorder == true) {
        var url = Uri.https(pendingorderapi, 'Pendingorder/pendingorder');
        var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": userid + id,
            "user_id": userid,
            'order_id': id,
            'token_no': rndm,
            'total': sum.toString(),
            'discount_amount': "0",
            'discount_percent': "0",
            'additional_amount': "0",
            'date': DateFormat("yyyy-MM-dd").format(
                DateTime.now()),
            'time': DateFormat("HH:mm:ss").format(
                DateTime.now()),
            'Advance_amount': "0",
            'pending_amount': sum.toString(),}),);
        if (response.statusCode == 200) {
          print("placedddbjhg");
          for (int i = 0; i < tempit.length; i++) {
            var url = Uri.https(tempitemapi, 'TempItemList/tempitem',
                {"id": tempit[i]});
            var response = await http.delete(url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{"id": tempit[i]}),);
            if (response.statusCode == 200) {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>  IncompleteOrders()));
            }
            print("deletfg  ${tempit}  ${response.statusCode}");
          }
          setState(() {
            canplaceorder = false;
            addorder = false;
            addorderbtn = true;
          });
        }
      }
    }
  }
  substractitemquantityfromstock(String sid, String stockname, String quantity) async {
    var url = Uri.https(stockapi, 'StockItemList/stockitem', {'id':sid});
    var res= await http.get(url);
    if(res.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(res.body) as Map<String, dynamic>;
      var response = await http.post(url,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":tagObjsJson['id'].toString(),
          "user_id": tagObjsJson['user_id'],
          "stock_id":tagObjsJson['stock_id'],
          "stock_name": tagObjsJson['stock_name'],
          "stock_quantity": (double.parse(tagObjsJson['stock_quantity'])-double.parse(quantity)).toString(),
          "stock_investment": tagObjsJson['stock_investment'],
          "selling_price_per_unit": tagObjsJson['selling_price_per_unit'],
          "constant_quantity":tagObjsJson['constant_quantity'],
          "stock_status": tagObjsJson['stock_status'],
          "stock_unit": tagObjsJson['stock_unit']}),);
      if(response.statusCode==200){
        updatestockrecords( tagObjsJson['stock_id'].toString(), quantity, stockname,tagObjsJson['selling_price_per_unit'].toString(), tagObjsJson['stock_unit'].toString());
      }
    }
  }
  updatestockrecords(String stockid, String quantity, String stockname, String sellprice, String unit) async {

    var url = Uri.https(stockrecapi, 'Stockrecord/stockrecord');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id":userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        "user_id": userid,
        "stock_id": stockid,
        "stock_record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        "stock_quantity": "-"+ quantity,
        "stock_investment": (double.parse(sellprice)*double.parse(quantity)).toString(),
        "stock_unit": unit,
        "selling_price_per_unit": sellprice,
        "stock_name": stockname,
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "time": DateFormat("HH:mm:ss").format(DateTime.now())}),);
    print('stockreport status: ${response.statusCode}');
  }
  Future<List> menulist(user)async{
    var menulist=[];
    var url= Uri.https(menuapi, 'Item/items',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==user){
      setState((){
        menulist.add(jnResponse);
      });
      }
    }
   return menulist;
  }
}


