import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../models/AcceptedSuppliers.dart';
import '../models/ChatItems.dart';
import '../models/ChatMessage.dart';
import '../models/CustomerRecord.dart';
import '../models/MenuItems.dart';
import '../models/Notifications.dart';
import '../models/PaymentRecords.dart';
import '../models/PendingPayments.dart';
import '../models/RentedItems.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../models/Suppliers.dart';
import '../models/TempIte.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'ChatPage.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class generatechatorder extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const generatechatorder({Key? key, this.ccid}) : super(key: key);
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
  Future<UpiResponse>? _transaction;
  late AnimationController delivercontroller;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var sum=0.0;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  var upistatus;
  bool ActiveConnection = false;
  var doc;
  String T = "", supplier= "Supplier";
  var engaged= "Occupied", vaccant= "Vaccant", offline="Offline", online="Online";
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
  String restroname="", phoneno="", suppliername="",paystatus="", paymode= "", deliverymode="";
  String itemimage="", shopname="", shopmobno="", cuid="", cshpname="", deliverycharge="0.0";
  String? selectedValueSingleMenu;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String dmodesdel= "delivery", demodestk= "takeaway",  shno="";
  List<DropdownMenuItem> items = [];
  var totalcost=0;
  var templist=[];
  bool addorder= false, addorderbtn=true;
  String? selectedValueSingleDialog;
  loadclientdetails(clientid) async {
    var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': clientid} );
    var response= await http.get(url );
    print(response.body);
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy--  ${jsonDecode(response.body)}");
      if (this.mounted) {
        setState(() {
          shopname = jsonResponse['shop_name'].toString();
          shopmobno = jsonResponse['username'].toString();
          cshpname = jsonResponse['supplier_name'].toString();
          deliverycharge = jsonResponse['delivery_charges'].toString();
        });}
    }
  }
  @override
  void initState() {
    CheckUserConnection();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    getuserdetails();
    loadclientdetails(clientid);
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
    delivercontroller= AnimationController(vsync: this, duration: Duration(seconds: 2));
    delivercontroller.addStatusListener((status)async {if(status==AnimationStatus.completed){
      Navigator.pop(this.context);
      delivercontroller.reset();
    }});
  }
  getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      templist=[];
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
      var response= await http.get(url );
      print(response.body);
      if(response.body.isNotEmpty){
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print("stocklosy--  ${jsonDecode(response.body)}");
        if (this.mounted) {
          setState(() {
            restroname = jsonResponse['shop_name'].toString();
            phoneno = jsonResponse['username'].toString();
            suppliername = jsonResponse['supplier_name'].toString();
          });}
      }
      var turl= Uri.https(tempitemapi, 'TempItemList/tempitems',);
      var tresponse= await http.get(url );
      sum=0.0;
      var tagObjsJson = jsonDecode(tresponse.body)['products'] as List;
      for(int i=0; i<tagObjsJson.length; i++){
        if(tagObjsJson[i]['user_id']==counter && tagObjsJson[i]['token']==clientid){
          templist.add(tagObjsJson[i]);
          setState((){sum=sum+double.parse(tagObjsJson[i]['item_total'].toString());});
        }
      }
    }
    else{runApp(LoginScreen());}
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
        appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor,))
            ,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>  ChatItemsPage(clid:clientid)));}, ),
          title:Column(children: [Text(shopname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color:Theme.of(context).primaryColor,),),
            Text(shopmobno, style: TextStyle(color:Theme.of(context).primaryColor,fontWeight: FontWeight.bold, fontSize: 15),)],),
        ),
        body:RefreshIndicator(onRefresh: ()async{
          setState((){sum=0;
          getuserdetails();});},
          child: SingleChildScrollView(scrollDirection: Axis.vertical,child:
           Container(//color: Theme.of(context).primaryColorDark,
          margin: EdgeInsets.only(top:10,bottom: 10, ),
          child: Column(children: [
         templist.length!=0? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: templist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  ListTile(
                          leading: Text((index+1).toString()),
                          title: Row(children: [Container(width:120,child:Text(templist[index]['item_name'].toString())) ,
                            SizedBox(width:10,),Text("₹"+templist[index]['item_total'].toString()), ],),
                          subtitle: Row(children:[Container(width:120,child:Text("₹"+templist[index]['item_price_per_unit'].toString()+"/"+templist[index]['item_unit'].toString())),
                            SizedBox(width: 10,),Text(templist[index]['item_quantity'].toString()!=""?
                            "Qty: "+templist[index]['item_quantity'].toString():"🕝 "+templist[index]['rented_duration'].toString()+"/"+templist[index]['item_unit'].toString()), ]),

                        );
                  }):
              Container(width: double.infinity,
                margin: EdgeInsets.only(left: 20, ),
                padding: EdgeInsets.all(8),
                child: TextButton(child: Text("Select Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),),
                  onPressed: (){opendialog(context);},),),
            Container(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
            padding:EdgeInsets.only(left:30, right: 30),
            alignment: Alignment.topRight,  child:Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: [
                TableRow(
                    children: [
                      Column(children:[Text(delivery==true?'Total+Delivery charge':"Total", style: TextStyle(fontSize:16.0))]),
                      SizedBox(width:20),
                      Column(children:[Text(sum.toString(), style: TextStyle(fontSize:16.0))]),
                    ]),
              ],),
            ),
            Container(   margin: EdgeInsets.only(top: 10, left: 25, right: 25),
              width:double.infinity,child: Text("Delivery Mode", style: TextStyle(fontSize: 18),),),
            Container(margin: EdgeInsets.only(left: 25, right: 25, top: 10),child: Row(children: [
             Card(child:  Row(children: [
                Checkbox(
                  value: this.delivery,
                  onChanged: (value) {
                    if(value==true){
                    setState(() {
                      this.delivery =true;
                      sum=sum+double.parse(deliverycharge);
                      takeaway = false;
                    });}else{
                      setState(() {
                        sum=sum-double.parse(deliverycharge);
                        this.delivery =false;
                      });}
                  },
                ),
                Icon(Icons.delivery_dining),
                Text(
                'Delivery',
                style: TextStyle(
                    fontSize: 17.0),
              ), SizedBox(width: 10), //Text
              ]), ),
             Card(child:  Row(children: [
                Checkbox(
                  value: this.takeaway,
                  onChanged: (bool? value) {
                    if(value==true) {
                      if(delivery==true){
                      setState(() {
                        sum=sum-double.parse(deliverycharge);
                        this.takeaway =true;
                        delivery = false;
                      });}else{setState(() {
                        this.takeaway =true;
                        delivery = false;
                      });}
                    }else{
                      setState(() {
                        this.takeaway =false;
                      });
                    }
                  },
                ),
                Icon(Icons.takeout_dining),
                Text('Take away',
                style: TextStyle(
                    fontSize: 17.0),
              ),
                SizedBox(width: 10), //Text
              ]), ),
            ],),),
            Container(height: 30, child: Text("Note: Delivery charges will be based on suppliers choice."),),
            Container(margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child:  Column(
                children: [
                  Container(width:double.infinity,
                    margin: EdgeInsets.only(left: 15),
                    child: Text("Payment Option: ", style: TextStyle(fontSize: 18),),),
                   ListTile(
                       onTap: (){   if(nw==false) {
                      showDialog(
                          context: context,
                          builder: (
                              BuildContext context) {
                            // return StatefulBuilder(builder: (BuildContext context, setState) {
                            return AlertDialog(
                              content: Container(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      Container(
                                            child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    nw =
                                                    true;
                                                    paylater =
                                                    false;
                                                    paystatus =
                                                    paid;
                                                    paymode =
                                                        offline;
                                                    timdel =
                                                    false;
                                                  });
                                                  Navigator
                                                      .pop(
                                                      context);
                                                },
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .money),
                                                    Text(
                                                        offline)
                                                  ],)),),
                                  Container(
                                            child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    nw =
                                                    true;
                                                    paystatus =
                                                        paid;
                                                    paylater =
                                                    false;
                                                    paymode =
                                                        online;
                                                    timdel =
                                                    false;
                                                  });
                                                  Navigator
                                                      .pop(
                                                      context);
                                                },
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .payment),
                                                    Text(
                                                        online)
                                                  ],)),),
                                    ],)),
                            );
                          });
                    }else{setState((){
                      nw=false;
                      paystatus="";
                    });}},
                     leading: Checkbox(
                      value: this.nw,
                      onChanged: ( value) {
                        if(value==true){
                          showDialog(
                              context: context,
                              builder: (
                                  BuildContext context) {
                                // return StatefulBuilder(builder: (BuildContext context, setState) {
                                return AlertDialog(
                                  content: Container(
                                      height: 100,
                                      child: Row(
                                        children: [
                                          Card(
                                            child: Container(
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        nw =
                                                        true;
                                                        paylater =
                                                        false;
                                                        paystatus =
                                                        "Paid";
                                                        paymode =
                                                            offline;
                                                        timdel =
                                                        false;
                                                      });
                                                      Navigator
                                                          .pop(
                                                          context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .money),
                                                        Text(
                                                            offline)
                                                      ],))),),
                                          Card(
                                            child: Container(
                                                child: TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        nw =
                                                        true;
                                                        paylater =
                                                        false;
                                                        paymode =
                                                            online;
                                                        timdel =
                                                        false;
                                                      });
                                                      Navigator
                                                          .pop(
                                                          context);
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .payment),
                                                        Text(
                                                            online)
                                                      ],))),),
                                        ],)),
                                );
                              });
                        }else{setState((){
                          nw=false;
                          paystatus="";
                        });}
                      },
                    ),
                     title: Text("Pay Now")),
                  ListTile(onTap: (){
                    if(paylater==false){
                        setState((){paylater=true;paystatus= pending;
                        nw=false; timdel=false;});}
                    else{
                      setState(() {
                        this.paylater = false;
                      });
                    }},
                        leading:Checkbox(
                      value: this.paylater,
                      onChanged: ( value) {
                        if(value==true){
                            setState((){paylater=true;paystatus= pending;
                            nw=false; timdel=false;});
                        }else{
                          setState(() {
                            this.paylater = false;
                          });
                        }
                      },
                    ),
                      title:Text("Pay Later")),
                ],),),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: addorder,
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: CircularProgressIndicator()
                )
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: addorderbtn,
              child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius
                      .circular(15),
                    color: Colors.blue,
                  ), width: double.maxFinite,
                  height: 45,
                  margin: EdgeInsets.only(left:15, right: 15, bottom: 20),
                  child:  TextButton(onPressed: ()async{
                    final ppt= await  _transaction;
                    if(paymode=="UPI"){
                      print(ppt!.status);
                    print("result");
                    print(_transaction);
                    if(ppt.status=="failure"){
                      setState((){upistatus= 'upistatus';});
                      print("fails");
                    }else{
                      setState((){upistatus= 'upistatus';
                      transactionid= ppt.transactionId!;});
                      print("success");}}// failure
                    setState((){addorder=true; addorderbtn= false;});
                    var add=0.0;
                  String orderid= DateFormat("yyMMddHHmmss").format(DateTime.now());
                    if(delivery==true){deliverymode= dmodesdel;}if(takeaway==true){deliverymode= demodestk;}
                    if(nw==true){
                     setState((){paystatus= paid;});
                          print("success");}//
                    if(paylater==true){setState((){paystatus= pending;});}
                    if(templist.isEmpty){ setState((){addorder=false; addorderbtn= true;});
                    Fluttertoast.showToast(msg: "Kindly select items to process further.");}
                  else if(deliverymode.isEmpty){setState((){addorder=false; addorderbtn= true;});
                    Fluttertoast.showToast(msg: "Kindly select delivery mode.");}

                 else if(paystatus.isEmpty){print("paystatus   --- $paystatus");
                   setState((){addorder=false; addorderbtn= true;});
                    Fluttertoast.showToast(msg: "Your payment has not completed yet."
                        " Kindly complete it to proceed further.");}
                 else if(paystatus==paid&&paymode.isEmpty){setState((){addorder=false; addorderbtn= true;});
                    Fluttertoast.showToast(msg: "Kindly select payment option.");}
                   else{
                  for(int i= 0; i<templist.length; i++)  {
                    print("durationgf=-098765========================   "+templist[i]['rented_duration'].toString());
                    itemlist.add(templist[i]['item_name'].toString());
                    add= add+ double.parse(templist[i]['item_total'].toString());
                    var turl= Uri.https(chatitemsapi, 'ChatItem/chatitem',);
                    var response = await http.post(turl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id": userid+clientid+ templist[i]['item_id'].toString(),
                        "user_id": userid,
                        "client_id": clientid,
                        "chat_id": orderid,
                        "item_id": templist[i]['item_id'].toString(),
                        "item_name": templist[i]['item_name'].toString(),
                        "item_quantity": templist[i]['item_quantity'].toString(),
                        "item_price": templist[i]['item_price_per_unit'].toString(),
                        "item_total": templist[i]['item_total'].toString(),
                        "item_unit": templist[i]['item_unit'],
                        "renting_duration": templist[i]['rented_duration'].toString(),
                        "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                        "Check_out_time": "",
                        "item_status":""}),);
                   if(response.statusCode==200){print("Data stored successfullyat user" );}
                    var clresponse = await http.post(turl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id": clientid+userid+ templist[i]['item_id'].toString(),
                        "user_id":clientid ,
                        "client_id":userid ,
                        "chat_id": orderid,
                        "item_id": templist[i]['item_id'].toString(),
                        "item_name": templist[i]['item_name'].toString(),
                        "item_quantity": templist[i]['item_quantity'].toString(),
                        "item_price": templist[i]['item_price_per_unit'].toString(),
                        "item_total": templist[i]['item_total'].toString(),
                        "item_unit": templist[i]['item_unit'],
                        "renting_duration": templist[i]['rented_duration'].toString(),
                        "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                        "Check_out_time": "",
                        "item_status":""}),);
                    if(clresponse.statusCode==200){print("Data stored successfullyat user" );}
                  }
                  var paidamount="0", pendingamount="0";
                  if(paystatus==paid){
                    setState((){paidamount= sum.toString();});
                  }else{
                    setState((){pendingamount= sum.toString();});
                  }
                  var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',);
                 var respe = await http.post(url,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":userid+clientid+orderid,
                        'user_id': userid,
                        'client_id': clientid,
                        'message_id': orderid,
                        'Chat_status': sent,
                        'payment_mode': paymode,
                        'payment_status':paystatus,
                        'transaction_id': transactionid,
                        'delivery_mode': deliverymode,
                        'status': pending,
                        'total': sum.toString(),
                        'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                        'Advance_amount': paidamount,
                        'pending_amount': pendingamount,
                        'file_url'   :""  ,
                        'file_type'  :""  ,
                        'file_key'   :""
                      }),);
                  var clrespe = await http.post(url,   headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                    body: jsonEncode(<String, String>{
                      "id":clientid+userid+orderid,
                      'user_id': clientid ,
                      'client_id': userid,
                      'message_id': orderid,
                      'Chat_status': received,
                      'payment_mode': paymode,
                      'payment_status':paystatus,
                      'transaction_id': transactionid,
                      'delivery_mode': deliverymode,
                      'status': pending,
                      'total': sum.toString(),
                      'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                      'Advance_amount': paidamount,
                      'pending_amount': pendingamount}),);
                  if(paystatus==paid){
                    String id= DateFormat("yyyyMMddHHmmss").format(DateTime.now());
                    var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
                    var response = await http.post(
                        url,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                          "user_id": userid,
                          "record_id": id,
                          "token_no": supplier,
                          "order_id": orderid,
                          "client_id": clientid,
                          "received_amount": "0",
                          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
                          "payment_mod": paymode,
                          "sent_amount": sum.toString(),
                          "description":"For order no. $orderid \nYou have sent "+cshpname.toString()+
                              " advance of ₹ $sum for your order request of "+itemlist.toString()
                        }));
                    var rense = await http.post(
                        url,
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          "id": clientid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                          "user_id": clientid,
                          "record_id": id,
                          "token_no": supplier,
                          "order_id": orderid,
                          "client_id": userid,
                          "received_amount": "0",
                          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
                          "payment_mod": paymode,
                          "sent_amount": sum.toString(),
                          "description":"For order no. $orderid \nYou have received "
                              " advance of ₹ $sum from ${restroname.toString()} for their order request of "+itemlist.toString()
                        }));
                    var csurl = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
                    var csresponse = await http.post(csurl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":userid+orderid,
                        'user_id': userid,
                        'client_id': clientid,
                        'record_id': DateFormat("yyyyMMddHHmmss").format(
                            DateTime.now()),
                        'payment_status': "Paid",
                        'payment_mode': "",
                        'transaction_id': "",
                        'received_amount':"0",
                        'sent_amount': sum.toString(),
                        'party_name':cshpname,
                        'date': DateFormat("yyyy-MM-dd").format(
                            DateTime.now()),
                        'time': DateFormat("HH:mm:ss").format(
                            DateTime.now()),
                        'party': "Customer",
                        'description':"For order no. $orderid \nYou have sent "+cshpname.toString()+
                            " advance of ₹ $sum for your order request of "+itemlist.toString()
                      }),);
                    var clsresponse = await http.post(csurl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":clientid+orderid,
                        'user_id': clientid,
                        'client_id': userid,
                        'record_id': DateFormat("yyyyMMddHHmmss").format(
                            DateTime.now()),
                        'payment_status': "Paid",
                        'payment_mode': "",
                        'transaction_id': "",
                        'received_amount':sum.toString(),
                        'sent_amount': "0",
                        'party_name':restroname,
                        'date': DateFormat("yyyy-MM-dd").format(
                            DateTime.now()),
                        'time': DateFormat("HH:mm:ss").format(
                            DateTime.now()),
                        'party': "Customer",
                        'description':"For order no. $orderid\n "+restroname.toString()+" have sent you advance of ₹ $sum "
                            "for their order request of"+itemlist.toString()
                      }),);
                    var acurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':userid+clientid});
                    var acresponse= await http.get(acurl );
                    if(acresponse.body.isNotEmpty){
                      var jnResponse = convert.jsonDecode(acresponse.body) as Map<String, dynamic>;
                      if (double.parse(jnResponse['Advance_amount'])>=0) {
                        var remain = double.parse(jnResponse['Advance_amount'].toString()) - sum;
                        if (remain > 0) {
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              'Advance_amount': remain.toString(),
                              'Pending_amount': jnResponse['Pending_amount'],
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);
                        }
                        else {
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              'Advance_amount': '0',
                              'Pending_amount': (- remain).toString(),
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);
                        }
                      }
                      else {
                        var remain = double.parse(jnResponse['Pending_amount'].toString()) + sum;
                        print("0987654567890=-0988-==============  $remain");
                        if (remain > 0) {
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              'Advance_amount': jnResponse['Advance_amount'],
                              'Pending_amount': remain.toString(),
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);
                        }
                        else {
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              'Advance_amount':(-remain).toString() ,
                              'Pending_amount': jnResponse['Pending_amount'],
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);

                        }
                      }
                    }
                    var clurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':clientid+userid});
                    var clresponse= await http.get(clurl );
                    if(clresponse.body.isNotEmpty){
                      var jnResponse = convert.jsonDecode(clresponse.body) as Map<String, dynamic>;
                      if (jnResponse['Pending_amount'] != "0") {
                        var remain = double.parse(
                            jnResponse['Pending_amount'].toString()) -
                            sum;
                        if (remain > 0) {
                          var response = await http.post(clurl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              "Advance_amount":jnResponse['Advance_amount'],
                              "Pending_amount": remain.toString(),
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);
                        }
                        else {
                          var response = await http.post(clurl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              "Advance_amount": (-remain).toString(),
                              "Pending_amount": "0",
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);

                        }
                      }
                      else {
                        var remain = double.parse(
                            jnResponse['Advance_amount'].toString()) +
                            sum;
                        if (remain > 0) {
                          var response = await http.post(clurl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              "Advance_amount":  remain.toString(),
                              "Pending_amount":  jnResponse['Pending_amount'],
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);

                        }
                        else {
                          var response = await http.post(clurl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":jnResponse['id'],
                              'user_id': jnResponse['user_id'],
                              'supplier_id': jnResponse['supplier_id'],
                              "Advance_amount":  "0",
                              "Pending_amount": (- remain).toString(),
                              'shop_name': jnResponse['shop_name'],
                              'supplier_name': jnResponse['supplier_name'],
                              'username': jnResponse['username'],
                              'supplier_phone_no': jnResponse['supplier_phone_no']
                            }),);

                        }
                      }
                    }
                  var noturl=Uri.https(notifyapi, "Notification/notification");
                  var notsponse = await http.post(noturl,   headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                  "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                  "user_id": clientid,
                  "title":  "$restroname has sent you advance of ₹ $sum for their order request of $itemlist.",
                  "subtitle": "",
                  "payload": "",
                  "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  "time": DateFormat("HH-mm-ss").format(DateTime.now())
                  }),);
                  var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                  var tkresponse= await http.get(tkurl );
                  if(tkresponse.body.isNotEmpty){
    var jsonResponse = convert.jsonDecode(tkresponse.body) as Map<String, dynamic>;
    sendPushMessage(jsonResponse['token'], "$restroname has sent you advance of ₹ $sum for their order request of $itemlist.", "");
    }

                  } var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                  var noturl=Uri.https(notifyapi, "Notification/notification");
                  var notisponse = await http.post(noturl,   headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                    body: jsonEncode(<String, String>{
                      "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                      "user_id": clientid,
                      "title":  "$restroname has sent you a order request.",
                      "subtitle": "",
                      "payload": "",
                      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      "time": DateFormat("HH-mm-ss").format(DateTime.now())
                    }),);
                  var tknresponse= await http.get(tkurl );
                  if(tknresponse.body.isNotEmpty){
                    var jsonResponse = convert.jsonDecode(tknresponse.body) as Map<String, dynamic>;
                    sendPushMessage(jsonResponse['token'],  restroname.toString()+" has sent you a order request.", "");
                  }
                 for(int i= 0; i<templist.length; i++)  {
                   var url = Uri.https(tempitemapi, 'TempItemList/tempitem', {"id": templist[i]['id']});
                   var response = await http.delete(url,
                     headers: <String, String>{
                       'Content-Type': 'application/json; charset=UTF-8',
                     },
                     body: jsonEncode(<String, String>{"id": templist[i]['id']}),);}
                  showDialog(context: context, builder: (BuildContext context) {
                     return StatefulBuilder(builder: (BuildContext context, setState) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            content:Lottie.asset("assets/animations/placeorder.json",
                            repeat: false,
                          ));});});
                  await FirebaseAnalytics.instance.logEvent(
                    name: "addedorder_forchatorder",
                    parameters: {
                      "user_id": userid,
                    },
                  );
                  // Navigator.of(context, rootNavigator: true).pop(context);
                  setState((){addorder=false; addorderbtn= true;});
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatItemsPage(clid:clientid)));
                  }}, child: Container(height:35, child:Text("Order", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: Colors.white),)))),
            ),
          ],),
        ), ),),
        floatingActionButton:Column(  mainAxisAlignment: MainAxisAlignment.end,
          children: [Container(width:130,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child: TextButton(
                onPressed: () async {//print(_userid);
                  CheckUserConnection();
                await openrentaldialog(context);
                  await FirebaseAnalytics.instance.logEvent(
                    name: "open_service_list_forchatorder",
                    parameters: {
                      "user_id": userid,
                    },
                  );
                 // setdocument();
                },
                child:Row(children:[Icon(Icons.add_shopping_cart,color: Colors.white),SizedBox(width:8),Text("Add Rentals".tr(),style: TextStyle(fontSize: 15,color: Colors.white ),textAlign: TextAlign.center,
                )])  ,
              )),
            SizedBox(height:15),
            Container(width:120,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
                child: TextButton(
                  onPressed: ()async {
                    CheckUserConnection();
                    opendialog(context);
                    await FirebaseAnalytics.instance.logEvent(
                      name: "open_item_list_forchatorder",
                      parameters: {
                        "user_id": userid,
                      },
                    );
                  },
                  child:Row(children:[Icon(Icons.add_shopping_cart,color: Colors.white),SizedBox(width:8),Text("Add items".tr(),style: TextStyle(fontSize: 15,color: Colors.white ),textAlign: TextAlign.center,
                  ),]),
                )),]),
      ),);
  }
  openrentaldialog(BuildContext context) {
    String?selectedValueSingleDialog;
    String itemid="", itemname="", itemprice="", quantity="";
    var ttl=0.0;var unit="";
    CheckUserConnection();
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
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
                            future:  getrenteditem(clientid),
                            builder: (BuildContext context, snapshot) {
                              if (!snapshot.hasData) return Container();
                              return SearchChoices.single(
                                items: snapshot.data!.map((value) {
                                  return DropdownMenuItem(
                                      value: value['id'],
                                      child:Container(padding:EdgeInsets.all(6),decoration:BoxDecoration(borderRadius: BorderRadius.circular(10), color: value['product_engagement']==engaged?Colors.blueAccent:null),child:
                                      Row(children: [Container(width: 120,child: Text('${value['rented_item_name']}', )), Text('₹'+'${value['charger_per_duration']}'),],))
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
                                      selectedValueSingleDialog = value;
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
                                  setState(() {ttl= double.parse(price)* double.parse(value.toString());
                                    quantity = value.trim();
                                  });

                                },)
                          ),
                          Container(width:60,
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
                        if(itemname.isEmpty ||itemname.startsWith("0", 0)){
                          setState((){additem=false; additembtn= true;});
                          Fluttertoast.showToast(msg: "Kindly select item.");
                        }
                        else if(quantity.isEmpty){
                          setState((){additem=false; additembtn= true;});
                          Fluttertoast.showToast(msg: "Kindly enter duration.");
                        }
                        else{
                          print("stockrecordupdated finished");
                          var turl= Uri.https(tempitemapi, 'TempItemList/tempitem',);
                          var response = await http.post(turl,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                              "user_id": userid,
                              "orderid": "",
                              "token_no": clientid,
                              "item_id": itemid,
                              "item_name": itemname,
                              "item_price_per_unit": itemprice,
                              "item_unit": unit,
                              "item_quantity": "",
                              "rented_duration": quantity,
                              "item_total": (double.parse(quantity)*double.parse(itemprice)).toString()}),);
                        setState((){additem=false; additembtn= true;});
                          setdocument();
                        }
                        Navigator.pop(context);
                        }, child: Container(height:35, child:Text("Add", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
                  ),]),
              ],
            );
          });
        });
  }

  Future<List> getrenteditem(clid)async{
    var rentedlist=[];
    var url= Uri.https(rentedapi, 'RentedItem/renteditems', );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if(jnResponse['user_id']==clid) {
          print("outgj-- ");
          setState(() {
            rentedlist.add(jnResponse);
          });
        }
      }
    } return rentedlist;
  }
 Future<List> getmenuitem(clid)async{
    var menu=[];
    var url= Uri.https(menuapi, 'Item/items',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==clid){print("outgj-- $jnResponse");
      setState((){
        menu.add(jnResponse);
      });
      }
    }}
    return menu;
  }
  setdocument(){
    getuserdetails();
   }
  Future<UpiResponse> initiateTransaction(UpiApp app, String clntupid,String clntshopname , sum) async {
    print(double.parse(sum.toString()).toString());
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: cuid,
      receiverName: clntshopname,
      transactionRefId: "UPITXREF"+DateFormat("yyMMddHHmmss").format(DateTime.now()),
      transactionNote: 'Payment to '+clntshopname+".",
      amount: double.parse(sum.toString()),
    );
  }
  Widget displayUpiApps() {
    print(shopname);
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app, cuid, shopname ,sum);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }
  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }
  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:

        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }
  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", ),
          Flexible(
              child: Text(
                body,
              )),
        ],
      ),
    );
  }
  opendialog(BuildContext context) {
    String itemid="", itemname="", itemprice="", quantity="";
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
                          future: getmenuitem(clientid),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return SearchChoices.single(
                              items: snapshot.data!.map((value) {
                                return DropdownMenuItem(
                                  value: value['id'],
                                  child: Row(children: [Container(width: 100,child: Text('${value['item_name']}'),)
                                    ,Text('₹'+'${value['item_price_per_unit']}'), ],),
                                );
                              }).toList(),
                              value: selectedValueSingleDialog,
                              hint: "Select one",
                              searchHint: "Select one",
                              onChanged: (value) {
                                setState(() async {
                                  var url= Uri.https(menuapi, 'Item/item',{'id': value});
                                  var response= await http.get(url );
                                  if(response.body.isNotEmpty){
                                    var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                                      selectedValueSingleDialog = value;
                                      setState((){ itemid= tagObjsJson['id'].toString();
                                      itemname=tagObjsJson['rented_item_name'].toString();
                                      itemprice=tagObjsJson['charger_per_duration'].toString();
                                      price= tagObjsJson['charger_per_duration'].toString();
                                      unit= tagObjsJson['rented_duration'].toString();   });
                                  }
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
                              setState(()=>total= double.parse(price)* double.parse(value));
                              quantity = value.trim();
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
                    ]//get()
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
                      String orderid= DateFormat("yyMMddHHmmss").format(DateTime.now());
                      print(clientid);
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
                        var response = await http.delete(turl,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        }, body: jsonEncode(<String, String>{
                          "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                          "user_id": userid,
                          "orderid": "",
                          "token_no": clientid,
                          "item_id": itemid,
                          "item_name": itemname,
                          "item_price_per_unit": itemprice,
                          "item_unit": unit,
                          "item_quantity": quantity,
                          "rented_duration": "",
                          "item_total": (double.parse(quantity)*double.parse(itemprice)).toString()
                        }));
                        setState((){additem=false; additembtn= true;});
                       setdocument();Navigator.pop(context);}

                      }, child: Container(height:35, child:Text("Add", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
                ),]),
            ],
          );
        });
        });
  }
   addpendingpayment( String orderid, String supplier, String shpname, String total,String paystatus,) async {
    if(paystatus==pending){
      print("shopname----- $shpname");
      var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id':clientid +userid});
      var response= await http.get(url );
      if(response.body.isNotEmpty){
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        var pend=0.0;
      var esponse = await http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id": jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "client_id": jsonResponse['client_id'],
              "record_id": jsonResponse['record_id'],
              "party": jsonResponse['party'],
              "party_name": jsonResponse['party_name'],
              "Pending_amount": (double.parse(total)+double.parse(jsonResponse['Pending_amount'].toString())).toString()
            }));
        if(esponse.statusCode==200){
        }
      }
      else{
        var esponse = await http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":  clientid+userid,
              "user_id": clientid,
              'client_id': userid,
              'record_id': clientid+userid,
              'party': supplier,
              'party_name': shpname,
              "Pending_amount": total}));
      }
   }
  }
  void sendPushMessage(String token, String body, String title) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAJar-Hqk:APA91bFIJP21yCDov5m95sLLjgi298b7-2N2Qjdy-VMmCjZvXFZC1dMVMoIzVUlpPc4YYezuAu7JqYaWftXNMRT40Ttlhtw5n0RixcQjy4pqzIu0BNuhUiKGc4g9rfes5heRSiJBB8ki'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }
}


