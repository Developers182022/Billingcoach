import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:uuid/uuid.dart';
import '../Screens/GenerateRequest.dart';
import '../main.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/ChatMessage.dart';
import '../models/CustomerRecord.dart';
import '../models/CustomerLis.dart';
import '../models/Expanse.dart';
import '../models/ExpanseRecord.dart';
import '../models/MenuItems.dart';
import '../models/Notifications.dart';
import '../models/PaymentRecords.dart';
import '../models/PendingPayments.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/RentedItems.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'Additemssellprice.dart';
import 'Notifications.dart';
import 'SubscriptionModule.dart';
import 'package:http/http.dart' as http;

import 'SuppliersList.dart';
import 'login/Login.dart';
import 'print_order.dart';

class ChatPage extends StatelessWidget {

  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
   ChatPage({Key? key, this.cleid}) : super(key: key);
  final cleid;
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
            home : ChatItemsPage(clid: cleid),
          );
        });
  }
}
class ChatItemsPage extends StatefulWidget {
  const ChatItemsPage({Key? key,this.clid}) : super(key: key);
  final clid;
  @override
  State<ChatItemsPage> createState() => _ChatItemsState(clientid: clid);
}
class _ChatItemsState extends State<ChatItemsPage> with SingleTickerProviderStateMixin{
  _ChatItemsState({this.clientid});
  final clientid;
  var cuid, cshpname;
  var engaged= "Occupied", vaccant= "Vaccant";
  late AnimationController controller;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool addstockbtn= true, addstock= false, updatestock=false, updatestockbtn= true;
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  var doc;
 late AnimationController delivercontroller;
  bool ActiveConnection = false;
  String T = "", supplier="Supplier", transactionid="", notdeliverd= "NotDeliverd";
  String pending= "Pending", delivered= "Delivered", cancelled= "Cancelled",approved="Approved",paymode= "", sent="Sent", received="Received", paystatus="",
  refunded= "Refunded",month="Month", day="Day", hour="Hour", minute= "Minute", year="Year";
  String paid= "Paid", payltr= "Pay later", payondelivery= "Pay on delivery";
  var chatlist=[];
  bool upi=false, cash= false, nw= false, timdel= false, paylater= false, delivery= false, takeaway= false;
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
  List<String> itemlist=[];
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  String date="";
  String time="";
  String userid= "";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String restroname="", phoneno="", address="", areacode="", ussuppliername="";
  String tobedeliver= "To be deliver", take= "Customer will fetch";
  String dmodesdel= "delivery", dmodestk= "takeaway";
  String pmodeltr= "Payment pending", pmodecash= "Cash", pmodeupi= "UPI";
  String itemimage="";
  var message;
  String? selectedValueSingleMenu;
  List<DropdownMenuItem> items = [];
  bool addorder= false, addorderbtn=true, additemtoorder=false;
  String shopname="", shopmobno="",csupplier="", cusername="";
  String pend ="0", advance="0";
  var chatmessages;
  var approv= true, approvbtn=false;
  Future<List> getchatlist(us)async{
   var list=[];
    //https://1sbvstny52.execute-api.ap-south-1.amazonaws.com/ChatMessages/chatmessages
    var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessages',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us && jnResponse['client_id']==clientid){
        print("outgj-- $jnResponse");
      setState((){
        list.add(jnResponse);
        chatlist.add(jnResponse);
      });
      }
    }
    return list;

  }
  Future<void> getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      getdues( counter, clientid);
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
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
    }
    else{runApp(LoginScreen());}
  }
  Future<void>getdues(String uid, String cid)async {
    var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier',{'id': uid+clientid} );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy--  ${jsonDecode(response.body)}");
      setState(() {
        cusername=  jsonResponse['username'].toString();
        csupplier=  jsonResponse['supplier_name'].toString();
        shopname=   jsonResponse['shop_name'].toString();
        shopmobno=  jsonResponse['supplier_phone_no'].toString();
        pend=       jsonResponse['Pending_amount'].toString();
        advance=    jsonResponse['Advance_amount'].toString();
      });
    }
  }
  @override
  void initState() {
    CheckUserConnection();
    getuserdetails();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    var key;

    if (listScrollController.hasClients) {
      final position = listScrollController.position.maxScrollExtent;
      listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
    // delivercontroller= AnimationController(vsync: this);
    controller= AnimationController(vsync: this, duration: Duration(seconds: 4));
    controller.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        controller.reset();
      }});

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
  List<int> selectedItemsMultiMenu = [];
  List<String> itemprice= <String>[];
  List<String> itemid= <String>[];
  List<String> itemimg= <String>[];
  List<String> itemnamelist= <String>[];
  ScrollController listScrollController = ScrollController();
  Future<void>sendchatmessage(String message)async{
    var id= DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    var url = Uri.https(chatmessageapi, 'ChatMessages/chatMessage');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+id,
          "user_id": userid,
          "client_id": clientid,
          "message_id": id,
          "Chat_status": "Sent",
          "payment_status": "",
          "payment_mode": "",
          "transaction_id": "",
          "delivery_mode": "",
          "total": "",
          "status": "",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "Message": message
        }));
    if(response.statusCode==200){
      var respse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":clientid+id,
            "user_id": clientid,
            "client_id": userid,
            "message_id": id,
            "Chat_status": received,
            "payment_status": "",
            "payment_mode": "",
            "transaction_id": "",
            "delivery_mode": "",
            "total": "",
            "status": "",
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "time": DateFormat("HH:mm:ss").format(DateTime.now()),
            "Message": message
          }));
      if(respse.statusCode==200) {
        print("dsendkijuytrewsfghjkjhgfdsxcvbhjkuygfdxcvbnjuytrfdxcvbnjkgfdxcvbnjuytfdcvbnjuytfc");
        var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
        var response= await http.get(url );
        if(response.body.isNotEmpty){
          var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
          sendPushMessage(jsonResponse['token'], "$restroname has sent you a message.", "");
        }
      }


    }

  }
  @override
  Widget build(BuildContext context) {
    var fileName = file != null ? basename(file!.path) : 'No File Selected';
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
            leading:TextButton(child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
        padding:EdgeInsets.all(4),
        child:Icon(Icons.arrow_back, color:Theme.of(context).primaryColor)),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SuppliersList()));},),
          title:Column(children: [Text(shopname, style: TextStyle(fontSize: 20,color:Theme.of(context).primaryColor,),),
            Text(cusername, style: TextStyle( fontSize: 15,color:Theme.of(context).primaryColor,),)],),
          actions: [IconButton(tooltip:"Ask for address and mobile for delivery purpose.",
              icon:Icon(Icons.person_add_alt_rounded,color:Theme.of(context).primaryColor,),
              onPressed:()async{ await FirebaseAnalytics.instance.logEvent(
                name: "asked_supplier_for_details",
                parameters: {
                  "user_id": userid,
                },
              );
                await sendchatmessage("Dear sir/madam,\n We will be require your Business address and details to deliver your order"
                    "Kindly send us your details.\n"
                    "Thanks and Regards\n"
                    "$restroname.");
              }),
            Center(child:Text(pend==""?"↑ "+advance:"↓ "+pend, style:TextStyle(color:pend==""?Colors.red:Colors.green,
              fontWeight: FontWeight.bold, fontSize: 18 )) ,),
            SizedBox(width:10)
            ],
         ),
        body: RefreshIndicator(onRefresh:()async{ },
            child:SingleChildScrollView(scrollDirection: Axis.vertical,
            child:Container(
              margin: EdgeInsets.only(bottom: 10, ),
              child:  FutureBuilder<List>(
                future:  getchatlist(userid),
                builder: (context, napshot) {
                if (napshot.hasError) {
                return Text('Something went wrong');
                } else if (napshot.hasData || napshot.data!= null) {
                return napshot.data!.length!=0? ListView.builder(
                                controller: listScrollController,
                                shrinkWrap: true,
                                itemCount: napshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if(napshot.data![index]['Chat_status']==received&& napshot.data![index]['status']!=cancelled){
                                    return Container(
                                        alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(bottom: 15,top: 10 ),
                                      child:  napshot.data![index]['total'].toString().isNotEmpty?buildReceivedorder(context
                                        , napshot.data![index]['date'].toString() ,
                                          napshot.data![index]['time'].toString(), napshot.data![index]['total'].toString(),
                                          napshot.data![index]['message_id'].toString(), napshot.data![index]['delivery_mode'].toString(),
                                          napshot.data![index]['payment_mode'].toString(),   napshot.data![index]['payment_status'].toString(),
                                          napshot.data![index]['status'].toString(), ):
                                      napshot.data![index]['Message'].toString().isNotEmpty? Container(margin: EdgeInsets.only(right:50),//alignment:Alignment.topRight,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          ),color: Theme.of(context).primaryColorLight
                                          ), padding:EdgeInsets.only(left:15, right:15, top:8, bottom: 8),child:
                                          buildreceivedmessage(context, napshot.data![index]['date'].toString() ,
                                        napshot.data![index]['time'].toString(), napshot.data![index]['Message'].toString(),) ):
                                      buildreceivedfile(context,  napshot.data![index]['date'].toString(),  napshot.data![index]['time'].toString(),
                                          napshot.data![index]['file_url'].toString(),  napshot.data![index]['file_type'].toString(),  napshot.data![index]['file_key'].toString())
                                    );}
                                  else if(napshot.data![index]['Chat_status'].toString()==sent&& napshot.data![index]['status'].toString()!=cancelled){
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 15,top: 10 ),
                                      alignment: Alignment.topRight,
                                      child:
                                        napshot.data![index]['total'].toString().isNotEmpty? buildSentorder(context, napshot.data![index]['date'].toString() ,
                                          napshot.data![index]['time'].toString(), napshot.data![index]['total'].toString(),
                                          napshot.data![index]['message_id'].toString(), napshot.data![index]['delivery_mode'].toString(),
                                          napshot.data![index]['payment_mode'].toString(),
                                          napshot.data![index]['payment_status'].toString(), napshot.data![index]['status'].toString(),
                                          napshot.data![index]['Advance_amount'].toString(),
                                            napshot.data![index]['pending_amount'].toString()):
                                        napshot.data![index]['Message'].toString().isNotEmpty?
                                        Container(margin: EdgeInsets.only(left:50),//alignment:Alignment.topRight,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                      // bottomRight: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),color: Theme.of(context).backgroundColor
                                  ), padding:EdgeInsets.only(left:15, right:15, top:8, bottom: 8),
                                            child:  buildsentmessage(context,  napshot.data![index]['date'].toString(),
                                  napshot.data![index]['time'].toString(),  napshot.data![index]['Message'].toString())):
                                        buildsentfile(context,  napshot.data![index]['date'].toString(),  napshot.data![index]['time'].toString(),
                                            napshot.data![index]['file_url'].toString(),  napshot.data![index]['file_type'].toString(),
                                            napshot.data![index]['file_key'].toString())
                                  );}
                                  else{
                                    return Container(
                                        margin: EdgeInsets.only(bottom: 15,top: 10 ),
                                        child:  buildCancelledorder(context, napshot.data![index]['date'].toString(),
                                            napshot.data![index]['time'].toString(), napshot.data![index]['total'].toString(),
                                            napshot.data![index]['message_id'].toString(), napshot.data![index]['delivery_mode'].toString(),
                                            napshot.data![index]['payment_mode'].toString(),  napshot.data![index]['payment_status'].toString(),
                                            chatlist[index]['Chat_status'].toString()));}
                                }):
                Center(child:
                Column(children:[
                  SizedBox(height: 15,),
                  Lottie.asset("assets/animations/chat.json", height: 250, width: 300),
                  SizedBox(height: 10,),
                  Container(padding:EdgeInsets.all(25),
                      child: Text("Start adding orders and chat.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                  SizedBox(height: 10,),
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
            ),))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (listScrollController.hasClients) {
              final position = listScrollController.position.maxScrollExtent;
              listScrollController.animateTo(
                position,
                duration: Duration(milliseconds: 1),
                curve: Curves.easeOut,
              );
            }
          },
          backgroundColor: Colors.blueAccent,
          isExtended: true,
          tooltip: "Scroll to Bottom",
          child: Icon(Icons.arrow_downward),
        ),
       bottomNavigationBar: Row(crossAxisAlignment:CrossAxisAlignment.center,children: [
         IconButton(tooltip:"attach_file",
             onPressed: () async {
           await FirebaseAnalytics.instance.logEvent(
             name: "attached_file_from_chat",
           );
         var result = await FilePicker.platform
                 .pickFiles(allowMultiple: false);
             if (result == null) return;
             final path = result.files.single.path!;
             print(result.files.first.path.toString()+"                  -0987y6trfvbnjkiuytfc ");
             setState(() {
               file = File(path);
               fileName = file.toString();
             });
             if(file!=null){
                   var values="";
                   showModalBottomSheet<void>(
                     context: context,
                     builder: (BuildContext context) {     var visible= false;
                     return SizedBox(
                         height: 200,
                         child: SingleChildScrollView(scrollDirection: Axis.vertical,
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children:  <Widget>[
                               SizedBox(height:15),
                               Container(padding:EdgeInsets.all(10),
                               margin: EdgeInsets.only(left:10, right:10),
                               child:Text(file!.path.toString())),
                              Container(padding:EdgeInsets.all(10),
                                margin: EdgeInsets.only(left:10, right:10),
                              child:TextButton(onPressed: () async {
                                setState((){visible = true;});
                                fileName = basename(file!.path);
                                int sizeInBytes = file!.lengthSync();
                                double sizeInMb = sizeInBytes / (1024 * 1024);
                                if(sizeInMb>10){setState((){visible = false;});
                                  Fluttertoast.showToast(msg: "File size should not be greater then 10MB.");
                                }else{
                                final platformFile = result.files.single;
                                final path = platformFile.path!;
                                final key = platformFile.name;
                                final filess = File(path);
                                try {
                                  final UploadFileResult result = await Amplify.Storage.uploadFile(
                                    local: filess,
                                    key: "public/"+userid+"+"+clientid+"/"+key,
                                    onProgress: (progress) {
                                      Center(child:CircularProgressIndicator());
                                      Fluttertoast.showToast(msg:'Fraction completed: ${progress.getFractionCompleted()}');
                                    },
                                  ).whenComplete(() => setState((){visible = false;}));
                                  try {
                                    final result = await Amplify.Storage.getUrl(key: "public/"+userid+"+"+clientid+"/"+key);
                                    print('Got URL: ${result.url}');
                                    await sendfiletochat(result.url, "public/"+userid+"+"+clientid+"/"+key, key);

                                    // Navigator.pop(context);
                                    setState((){visible = false;});
                                  } on StorageException catch (e) {
                                    print('Error getting download URL: $e');
                                  }
                                  print('Successfully uploaded file: ${result.key}');
                                } on StorageException catch (e) {
                                  print('Error uploading file: $e');
                                }
                                Navigator.pop(context);
                              }
                        },child:Container(height:35,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                      color:Colors.blue),
                                      child:Row(crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children:[Icon(Icons.upload, color: Colors.white,),
                                        Text("Upload", style:TextStyle(color: Colors.white,))])))
                              ),
                             ],
                           ),
                         ),
                       );});}
           }, icon: Icon(Icons.attach_file)),
         Container( width:200,
           padding:EdgeInsets.all(8),
           child: TextField(decoration: InputDecoration(
             border: OutlineInputBorder(
               borderSide: BorderSide(),
             ),
             hintText: "Type message here.".tr(),
             prefixIcon: Icon(
                 Icons.keyboard),),
             controller: TextEditingController(text: message!=null?message.toString():""),
             keyboardType: TextInputType.text,
             onChanged: (value){
                message= value.trim();
             },),),
         IconButton(   tooltip:"send message",onPressed: () async {

           await FirebaseAnalytics.instance.logEvent(
             name: "sent_msg_from_chat",
             parameters: {
               "user_id": userid,
             },
           );
           if(message!=null){
            var id= DateFormat("yyyyMMddHHmmss").format(DateTime.now());
            //ChatMessages/chatmessages
            var curl = Uri.https(chatmessageapi, 'ChatMessages/chatmessage');
            var response = await http.post(curl,   headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
              body: jsonEncode(<String, String>{
                "id":userid+clientid+id,
                'user_id': userid,
                "client_id": clientid,
                "message_id": id,
                "Chat_status": sent,
                "payment_status": "",
                "payment_mode": "",
                "transaction_id": "",
                "delivery_mode": "",
                "total": "",
                "status": "",
                "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                "time": DateFormat("HH:mm:ss").format(DateTime.now()),
                "Message": message
              }),);
            if(response.statusCode==200){
              var respon = await http.post(curl,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":clientid+userid+id,
                  'user_id': clientid,
                  "client_id": userid,
                  "message_id": id,
                  "Chat_status": sent,
                  "payment_status": "",
                  "payment_mode": "",
                  "transaction_id": "",
                  "delivery_mode": "",
                  "total": "",
                  "status": "",
                  "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  "time": DateFormat("HH:mm:ss").format(DateTime.now()),
                  "Message": message
                }),);
              if(respon.statusCode==200){
                setState((){message="";});}
            }
            var url = Uri.https(tokenapi, 'UsertokenList/usertokens', {'id':clientid});
            var respo = await http.get(url);
            if(respo.body.isNotEmpty) {
              var jsonResponse = convert.jsonDecode(respo.body) as Map<String, dynamic>;
              sendPushMessage(jsonResponse['token'].toString(), restroname+ " has sent you a message.", "");

            }
              // Navigator.pop(context);
           }
         }, icon: Icon(Icons.send)),
           Container(width:80,
               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
               child:TextButton(
             onPressed: ()async{
               await FirebaseAnalytics.instance.logEvent(
               name: "add_order_from_chat",
               parameters: {
                 "user_id": userid,
               },
             );
               Navigator.push(context, MaterialPageRoute(builder: (context) => generatechatorder(ccid:clientid),));},
             child: Text("Add order",style: TextStyle(color: Colors.white),))),
       ]),
      ),);
  }
  Widget buildReceivedorder(BuildContext context,String date,String time, String total, String oid,
      String dmode, String pmode, String pstatus,String status)  {

    print(clientid);
    return Container(margin: EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            // bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
          ),color: Theme.of(context).primaryColorLight
          ),
          child:
          Column(children:[
            Row(children:[  Container(
              margin: EdgeInsets.only(left:12),
              child: Text("Order no: "+oid), ),  SizedBox(width: 75,),Column(children: [Text(time,style :TextStyle(fontSize:12)),
              Text(date,style :TextStyle(fontSize:12))],) ]),
            Card(
              elevation: 0,
              child: ListTile(
                title:Row(children: [Container(width:28,child:Text("sts",style:TextStyle(fontSize:14)),),
                  SizedBox(width:2),
                  Container(width:75,child:Center(child:Text("Itemname",style:TextStyle(fontSize:14)),)),
                  SizedBox(width: 2,),
                  Container(width:45,child:Center(child: Text("Qty/🕝",style:TextStyle(fontSize:14)),)),
                  SizedBox(width: 2,),
                  Container(width: 65,child: Center(child:Text("₹/unit",style:TextStyle(fontSize:14))))],) ,
                trailing:Container(child:Text("Total",style:TextStyle(fontSize:14)),),
              ),
            ),
            FutureBuilder<List>(
                future: getchatitem(oid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:  snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 1,
                            child: ListTile(
                               title:Row(children: [
                                 Container(width:25,child:Center(child:snapshot.data![index]['item_status'].toString()==delivered?Icon(Icons.check_circle_outlined, color:Colors.green):
                                 snapshot.data![index]['item_status'].toString()=="not delivered"?Icon(Icons.cancel_outlined, color:Colors.red):snapshot.data![index]['item_status'].toString()=="CheckedOut"?
                          Icon(Icons.check_box,color:Colors.blue ):Icon(Icons.help_outline,),),),
                                SizedBox(width:2),
                                Container(width:80,child:Center(child:Text(snapshot.data![index]['item_name'].toString(),
                                    style:TextStyle(fontSize:14))),),
                                SizedBox(width: 2,),
                                Container(width:50,child: Center(child:Text(snapshot.data![index]['item_quantity'].toString()!=""?
                                snapshot.data![index]['item_quantity'].toString():snapshot.data![index]['renting_duration'].toString(),
                                    style:TextStyle(fontSize:14))),),
                                SizedBox(width:2),
                                Container(width:65,child:Center(child: Text("₹"+snapshot.data![index]['item_price'].toString()+
                                    "/\n"+snapshot.data![index]['item_unit'].toString(),style:TextStyle(fontSize:14)),))],) ,
                              trailing:Container(child:Text("₹"+snapshot.data![index]['item_total'].toString()),),
                          onLongPress:(){var checkincount=0;
                                 if(snapshot.data![index]['item_status'].toString() == delivered) {
                                   print(snapshot.data![index]['Check_out_time'].toString()+"=============== "
                                       +snapshot.data![index]['renting_duration'].toString()  );
                                   if (snapshot.data![index]['renting_duration']
                                           .toString() != ""|| snapshot.data![index]['Check_out_time'].toString()=="") {
                                     print(snapshot.data![index]['Check_+out_time'].toString()+"========ijfrtyjn======="
                                         " "+snapshot.data![index]['renting_duration'].toString()  );

                                     var ordertotal = 0.0;
                                     var nameslist = [],
                                         unitlist = [],
                                         rentduration = [],
                                         ordercharge = [],
                                         extracharges = [],
                                         extratime = [],
                                         checkintime = [],
                                         productid = [];
                                     if (snapshot.data![index]['renting_duration']
                                         .toString() != "") {
                                       if (snapshot.data![index]['item_unit']
                                           .toString() == year) {
                                         var cdate = DateFormat("yyyy-MM-dd")
                                             .parse(snapshot.data![index]['check_in_time']
                                             .toString());
                                         var ndate = DateFormat("yyyy-MM-dd")
                                             .parse(
                                             DateFormat("yyyy-MM-dd").format(
                                                 DateTime.now()));
                                         var d = DateTimeRange(
                                             start: cdate, end: ndate).duration
                                             .inDays;
                                         var acalduration = d / 365;
                                         print(acalduration);
                                         checkincount = checkincount + 1;
                                         // if(acalduration>double.parse(snapshot.data![index].renting_duration.toString())){
                                         var extrduration = (acalduration -
                                             double.parse(snapshot.data![index]
                                                 ['renting_duration'].toString()));
                                         var charge = extrduration *
                                             double.parse(snapshot.data![index]
                                                 ['item_price'].toString());
                                         nameslist.add(
                                             snapshot.data![index]['item_name']
                                                 .toString());
                                         rentduration.add(snapshot.data![index]
                                             ['renting_duration'].toString());
                                         checkintime.add(
                                             snapshot.data![index]['check_in_time']
                                                 .toString());
                                         extratime.add(
                                             (30.0 * extrduration).toString());
                                         extracharges.add(
                                             charge.toStringAsFixed(0));
                                         ordercharge.add(
                                             snapshot.data![index]['item_total']
                                                 .toString());
                                         productid.add(
                                             snapshot.data![index]['item_id']
                                                 .toString());
                                         unitlist.add(year);
                                         // }
                                       }
                                       if (snapshot.data![index]['item_unit']
                                           .toString() == month) {
                                         var cdate = DateFormat("yyyy-MM-dd")
                                             .parse(snapshot.data![index].check_in_time
                                             .toString());
                                         var ndate = DateFormat("yyyy-MM-dd")
                                             .parse(
                                             DateFormat("yyyy-MM-dd").format(
                                                 DateTime.now()));
                                         var d = DateTimeRange(
                                             start: cdate, end: ndate).duration
                                             .inDays;
                                         var acalduration = d / 30;
                                         print(acalduration);
                                         checkincount = checkincount + 1;

                                         // if(acalduration>double.parse(snapshot.data![index].renting_duration.toString())){
                                         var extrduration = (acalduration -
                                             double.parse(snapshot.data![index]
                                             ['renting_duration'].toString()));
                                         var charge = extrduration *
                                             double.parse(snapshot.data![index]
                                                 ['item_price'].toString());
                                         nameslist.add(
                                             snapshot.data![index]['item_name']
                                                 .toString());
                                         rentduration.add(snapshot.data![index]
                                             ['renting_duration'].toString());
                                         checkintime.add(
                                             snapshot.data![index]['check_in_time']
                                                 .toString());
                                         extratime.add(
                                             (30.0 * extrduration).toString());
                                         extracharges.add(charge.toString());
                                         ordercharge.add(
                                             snapshot.data![index]['item_total']
                                                 .toString());
                                         productid.add(
                                             snapshot.data![index]['item_id']
                                                 .toString());
                                         unitlist.add(month);
                                         // }
                                       }
                                       if (snapshot.data![index]['item_unit']
                                           .toString() == day) {
                                         var cdate = DateFormat(
                                             "yyyy-MM-dd-HH:mm:ss").parse(
                                             snapshot.data![index].check_in_time
                                                 .toString());
                                         var ndate = DateFormat(
                                             "yyyy-MM-dd-HH:mm:ss").parse(
                                             DateFormat("yyyy-MM-dd-HH:mm:ss")
                                                 .format(DateTime.now()));
                                         var d = DateTimeRange(
                                             start: cdate,
                                             end: ndate)
                                             .duration
                                             .inHours;
                                         print("durations----- $d");
                                         var acalduration = d / 24;
                                         print(d / 24);
                                         print(cdate
                                             .difference(ndate)
                                             .inDays);
                                         checkincount = checkincount + 1;

                                         // if(acalduration>double.parse(snapshot.data![index].renting_duration.toString())){
                                         var extrduration = acalduration -
                                             double.parse(snapshot.data![index]
                                                 ['renting_duration'].toString());
                                         var charge = extrduration *
                                             double.parse(snapshot.data![index]
                                                 ['item_price'].toString());
                                         nameslist.add(
                                             snapshot.data![index]['item_name']
                                                 .toString());
                                         rentduration.add(snapshot.data![index]
                                             ['renting_duration'].toString());
                                         checkintime.add(
                                             snapshot.data![index]['check_in_time']
                                                 .toString());
                                         extratime.add(
                                             extrduration.toStringAsFixed(2));
                                         extracharges.add(
                                             charge.toStringAsFixed(0));
                                         ordercharge.add(
                                             snapshot.data![index]['item_total']
                                                 .toString());
                                         productid.add(
                                             snapshot.data![index]['item_id']
                                                 .toString());
                                         unitlist.add(day);
                                         // }
                                       }
                                       if (snapshot.data![index]['item_unit']
                                           .toString() == hour) {
                                         var cdate = DateFormat(
                                             "yyyy-MM-dd-HH:mm:ss").parse(
                                             snapshot.data![index]['check_in_time']
                                                 .toString());
                                         var ndate = DateFormat(
                                             "yyyy-MM-dd-HH:mm:ss").parse(
                                             DateFormat("yyyy-MM-dd-HH:mm:ss")
                                                 .format(DateTime.now()));
                                         var d = DateTimeRange(
                                             start: cdate,
                                             end: ndate)
                                             .duration
                                             .inMinutes;
                                         print("durations----- $d");
                                         var acalduration = d / 60;
                                         print(d / 60);
                                         print(cdate
                                             .difference(ndate)
                                             .inDays);
                                         // if(acalduration>double.parse(snapshot.data![index].renting_duration.toString())){
                                         print(
                                             "oiuytresdcvbnm,-----------------------------   ${snapshot
                                                 .data![index]['renting_duration']
                                                 .toString()}");
                                         checkincount = checkincount + 1;
                                         var extrduration = acalduration -
                                             double.parse(snapshot.data![index]
                                                 ['renting_duration'].toString());
                                         var charge = extrduration *
                                             double.parse(snapshot.data![index]
                                                 ['item_price'].toString());
                                         nameslist.add(
                                             snapshot.data![index]['item_name']
                                                 .toString());
                                         rentduration.add(snapshot.data![index]
                                             ['renting_duration'].toString());
                                         checkintime.add(
                                             snapshot.data![index]['check_in_time']
                                                 .toString());
                                         extratime.add(
                                             extrduration.toStringAsFixed(2));
                                         extracharges.add(
                                             charge.toStringAsFixed(0));
                                         ordercharge.add(
                                             snapshot.data![index]['item_total']
                                                 .toString());
                                         productid.add(
                                             snapshot.data![index]['item_id']
                                                 .toString());
                                         unitlist.add(hour);
                                         // }
                                       }
                                       if (checkincount != 0) {
                                         if (nameslist.isNotEmpty) {
                                           showModalBottomSheet(
                                             context: context,
                                             builder: (BuildContext context) {
                                               var values;
                                               return Container(height: 300,
                                                 //scrollDirection: Axis.vertical,
                                                 child: Column(
                                                   mainAxisAlignment: MainAxisAlignment
                                                       .center,
                                                   crossAxisAlignment: CrossAxisAlignment
                                                       .start,
                                                   children: <Widget>[
                                                     ListTile(
                                                       title: Table(
                                                         defaultColumnWidth: IntrinsicColumnWidth(),
                                                         children: [
                                                           TableRow(
                                                               children: [
                                                                 Column(
                                                                     children: [
                                                                       Container(
                                                                           margin: EdgeInsets
                                                                               .only(
                                                                             right: 5,
                                                                             top: 4,),
                                                                           padding: EdgeInsets
                                                                               .only(
                                                                               top: 4,
                                                                               bottom: 4),
                                                                           width: 110,
                                                                           child: Text(
                                                                               'Item name\ncheckin time',
                                                                               style: TextStyle(
                                                                                   fontSize: 14.0)))
                                                                     ]),
                                                                 Column(
                                                                     children: [
                                                                       Container(
                                                                           margin: EdgeInsets
                                                                               .only(
                                                                             right: 5,
                                                                             top: 4,),
                                                                           padding: EdgeInsets
                                                                               .only(
                                                                               top: 4,
                                                                               bottom: 4),
                                                                           width: 110,
                                                                           child: Text(
                                                                               'Rented duration\n(assigned+extra)',
                                                                               style: TextStyle(
                                                                                   fontSize: 14.0)))
                                                                     ]),
                                                                 Column(
                                                                     children: [
                                                                       Container(
                                                                           margin: EdgeInsets
                                                                               .only(
                                                                             right: 5,
                                                                             top: 4,),
                                                                           padding: EdgeInsets
                                                                               .only(
                                                                               top: 4,
                                                                               bottom: 4),
                                                                           width: 110,
                                                                           child: Text(
                                                                               'Amount \n(total+ extra)',
                                                                               style: TextStyle(
                                                                                   fontSize: 14.0)))
                                                                     ]),
                                                               ]),
                                                         ],
                                                       ),
                                                     ),
                                                     Expanded(
                                                       child: ListView.builder(
                                                         itemCount: nameslist
                                                             .length,
                                                         itemBuilder: (
                                                             BuildContext context,
                                                             int index) {
                                                           return ListTile(
                                                             title: Table(
                                                               defaultColumnWidth: IntrinsicColumnWidth(),
                                                               children: [
                                                                 TableRow(
                                                                     children: [
                                                                       Column(
                                                                           children: [
                                                                             Container(
                                                                                 margin: EdgeInsets
                                                                                     .only(
                                                                                   right: 5,
                                                                                   top: 4,),
                                                                                 padding: EdgeInsets
                                                                                     .only(
                                                                                     top: 4,
                                                                                     bottom: 4),
                                                                                 width: 110,
                                                                                 child: Text(
                                                                                     nameslist[index] +
                                                                                         "\n" +
                                                                                         checkintime[index] +
                                                                                         "",
                                                                                     style: TextStyle(
                                                                                         fontSize: 14.0)))
                                                                           ]),
                                                                       Column(
                                                                           children: [
                                                                             Container(
                                                                                 margin: EdgeInsets
                                                                                     .only(
                                                                                   right: 5,
                                                                                   top: 4,),
                                                                                 padding: EdgeInsets
                                                                                     .only(
                                                                                     top: 4,
                                                                                     bottom: 4),
                                                                                 width: 110,
                                                                                 child: Text(
                                                                                     "(" +
                                                                                         rentduration[index] +
                                                                                         "+(" +
                                                                                         extratime[index] +
                                                                                         "))" +
                                                                                         unitlist[index],
                                                                                     style: TextStyle(
                                                                                         fontSize: 14.0)))
                                                                           ]),
                                                                       Column(
                                                                           children: [
                                                                             Container(
                                                                                 margin: EdgeInsets
                                                                                     .only(
                                                                                   right: 5,
                                                                                   top: 4,),
                                                                                 padding: EdgeInsets
                                                                                     .only(
                                                                                     top: 4,
                                                                                     bottom: 4),
                                                                                 width: 110,
                                                                                 child: Text(
                                                                                     "₹" +
                                                                                         ordercharge[index] +
                                                                                         "+(₹" +
                                                                                         extracharges[index] +
                                                                                         ")",
                                                                                     style: TextStyle(
                                                                                         fontSize: 14.0)))
                                                                           ]),
                                                                     ]),
                                                               ],
                                                             ),
                                                           );
                                                         },
                                                       ),),
                                                     Center(
                                                         child: Row(children: [
                                                           TextButton(
                                                               child: Container(
                                                                   height: 40,
                                                                   width: 150,
                                                                   decoration: BoxDecoration(
                                                                       borderRadius: BorderRadius
                                                                           .circular(
                                                                           15),
                                                                       color: Colors
                                                                           .blue),
                                                                   child: Center(
                                                                       child: Text(
                                                                           "Ignore and checkout",
                                                                           style: TextStyle(
                                                                               color: Colors
                                                                                   .white)))),
                                                               onPressed: () async {
                                                                 var turl= Uri.https(chatitemsapi, 'ChatItem/chatitem',);
                                                                 var response = await http.post(turl,   headers: <String, String>{
                                                                   'Content-Type': 'application/json; charset=UTF-8',
                                                                 },
                                                                   body: jsonEncode(<String, String>{
                                                                     "id": snapshot    .data![index]  ['id'],
                                                                     "user_id": snapshot    .data![index]['user_id'],
                                                                     "client_id": snapshot    .data![index]['client_id'],
                                                                     "chat_id": snapshot    .data![index] ['chat_id'],
                                                                     "item_id": snapshot    .data![index]  ['item_id'].toString(),
                                                                     "item_name": snapshot    .data![index]  ['item_name'].toString(),
                                                                     "item_quantity":snapshot    .data![index]  ['item_quantity'].toString(),
                                                                     "item_price": snapshot    .data![index]  ['item_price_per_unit'].toString(),
                                                                     "item_total": snapshot    .data![index]  ['item_total'].toString(),
                                                                     "item_unit":snapshot    .data![index]  ['item_unit'],
                                                                     "renting_duration":  snapshot    .data![index]  ['rented_duration'].toString(),
                                                                     "check_in_time": snapshot    .data![index]  ['check_in_time'].toString(),
                                                                     "Check_out_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                                                     "item_status":"CheckedOut"}),);
                                                                 var clturl= Uri.https(chatitemsapi, 'ChatItem/chatitem',);
                                                                 var clresponse = await http.post(clturl,   headers: <String, String>{
                                                                   'Content-Type': 'application/json; charset=UTF-8',
                                                                 },
                                                                   body: jsonEncode(<String, String>{
                                                                     "id": clientid+userid+snapshot    .data![index]['chat_id'],
                                                                     "user_id":snapshot    .data![index]['client_id'] ,
                                                                     "client_id": snapshot    .data![index]['user_id'],
                                                                     "chat_id": snapshot    .data![index] ['chat_id'],
                                                                     "item_id": snapshot    .data![index]  ['item_id'].toString(),
                                                                     "item_name": snapshot    .data![index]  ['item_name'].toString(),
                                                                     "item_quantity":snapshot    .data![index]  ['item_quantity'].toString(),
                                                                     "item_price": snapshot    .data![index]  ['item_price_per_unit'].toString(),
                                                                     "item_total": snapshot    .data![index]  ['item_total'].toString(),
                                                                     "item_unit":snapshot    .data![index]  ['item_unit'],
                                                                     "renting_duration":  snapshot    .data![index]  ['rented_duration'].toString(),
                                                                     "check_in_time": snapshot    .data![index]  ['check_in_time'].toString(),
                                                                     "Check_out_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                                                     "item_status":"CheckedOut"}),);
                                                                      var renturl= Uri.https(rentedapi, 'RentedItem/renteditem',
                                                                      {'id':snapshot    .data![index]    .item_id}, );
                                                                      var rentresponse= await http.get(renturl );
                                                                      if(response.body.isNotEmpty){
                                                                      var tagObjsJson = jsonDecode(response.body)as Map<String, dynamic>;
                                                                      var resp = await http.post(renturl,
                                                                      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
                                                                      body: jsonEncode(<String, String>{
                                                                      "id":tagObjsJson['id'].toString(),
                                                                      "user_id":tagObjsJson['user_id'],
                                                                      "product_id": tagObjsJson['product_id'],
                                                                      "rented_item_name": tagObjsJson['rented_item_name'],
                                                                      "charger_per_duration": tagObjsJson['charger_per_duration'],
                                                                      "product_engagement": "",
                                                                      "rented_duration": tagObjsJson['rented_duration'],
                                                                      "rentout_to_client_id": tagObjsJson['rentout_to_client_id']}),);}

                                                               }),
                                                           TextButton(
                                                             child: Container(
                                                                 height: 40,
                                                                 width: 170,
                                                                 decoration: BoxDecoration(
                                                                     borderRadius: BorderRadius
                                                                         .circular(
                                                                         15),
                                                                     color: Colors
                                                                         .blue),
                                                                 child: Center(
                                                                     child: Text(
                                                                         "Add Extra & checkout",
                                                                         style: TextStyle(
                                                                             color: Colors
                                                                                 .white)))),
                                                             onPressed: () async {
                                                  for (int i = 0; i < nameslist.length; i++) {
                                                    var turl = Uri.https(
                                                      chatitemsapi,
                                                      'ChatItem/chatitem',);
                                                    var response = await http
                                                        .post(turl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(
                                                          <String, String>{
                                                            "id": snapshot
                                                                .data![index] ['id'],
                                                            "user_id": snapshot
                                                                .data![index]['user_id'],
                                                            "client_id": snapshot
                                                                .data![index]['client_id'],
                                                            "chat_id": snapshot
                                                                .data![index] ['chat_id'],
                                                            "item_id": snapshot
                                                                .data![index] ['item_id']
                                                                .toString(),
                                                            "item_name": snapshot
                                                                .data![index] ['item_name']
                                                                .toString(),
                                                            "item_quantity": snapshot
                                                                .data![index] ['item_quantity']
                                                                .toString(),
                                                            "item_price": snapshot
                                                                .data![index] ['item_price_per_unit']
                                                                .toString(),
                                                            "item_total": (double
                                                                .parse(snapshot
                                                                .data![index] ['item_total']
                                                                .toString()) +
                                                                double.parse(
                                                                    extracharges[i]))
                                                                .toString(),
                                                            "item_unit": snapshot
                                                                .data![index] ['item_unit'],
                                                            "renting_duration": snapshot
                                                                .data![index] ['rented_duration']
                                                                .toString(),
                                                            "check_in_time": snapshot
                                                                .data![index] ['check_in_time']
                                                                .toString(),
                                                            "Check_out_time": DateFormat(
                                                                "yyyy-MM-dd HH:mm:ss")
                                                                .format(
                                                                DateTime.now()),
                                                            "item_status": "CheckedOut"
                                                          }),);
                                                    if (response.statusCode ==
                                                        200) {
                                                      var msgurl = Uri.https(
                                                          chatmessageapi,
                                                          'ChatMessages/chatmessage',
                                                          {
                                                            'id': userid +
                                                                clientid +
                                                                snapshot
                                                                    .data![index] ['chat_id']
                                                          });
                                                      var rentresponse = await http
                                                          .get(msgurl);
                                                      if (rentresponse.body
                                                          .isNotEmpty) {
                                                        var tagObjsJson = jsonDecode(
                                                            rentresponse
                                                                .body) as Map<
                                                            String,
                                                            dynamic>;
                                                        var respe = await http
                                                            .post(msgurl,
                                                            headers: <
                                                                String,
                                                                String>{
                                                              'Content-Type': 'application/json; charset=UTF-8',
                                                            },
                                                            body: jsonEncode(<
                                                                String,
                                                                String>{
                                                              "id": tagObjsJson['id'],
                                                              'user_id': tagObjsJson['user_id'],
                                                              'client_id': tagObjsJson['client_id'],
                                                              'message_id': tagObjsJson['message_id'],
                                                              'Chat_status': tagObjsJson['Chat_status'],
                                                              'payment_mode': tagObjsJson['payment_mode'],
                                                              'payment_status': tagObjsJson['payment_status'],
                                                              'transaction_id': tagObjsJson['transaction_id'],
                                                              'delivery_mode': tagObjsJson['delivery_mode'],
                                                              'status': tagObjsJson['status'],
                                                              'total': (double
                                                                  .parse(
                                                                  tagObjsJson['total']
                                                                      .toString()) +
                                                                  double.parse(
                                                                      extracharges[i]))
                                                                  .toString(),
                                                              'date': tagObjsJson['date'],
                                                              'time': tagObjsJson['time'],
                                                              'Advance_amount': tagObjsJson['Advance_amount'],
                                                              'pending_amount': (double
                                                                  .parse(
                                                                  tagObjsJson['pending_amount']
                                                                      .toString()) +
                                                                  double.parse(
                                                                      extracharges[i]))
                                                                  .toString(),
                                                              'file_url': tagObjsJson['file_url'],
                                                              'file_type': tagObjsJson['file_type'],
                                                              'file_key': tagObjsJson['file_key']
                                                            }));
                                                      }
                                                    }
                                                    var clturl = Uri.https(
                                                      chatitemsapi,
                                                      'ChatItem/chatitem',);
                                                    var clresponse = await http
                                                        .post(clturl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(
                                                          <String, String>{
                                                            "id": clientid +
                                                                userid +
                                                                snapshot
                                                                    .data![index]['item_id'],
                                                            "user_id": snapshot
                                                                .data![index]['client_id'],
                                                            "client_id": snapshot
                                                                .data![index]['user_id'],
                                                            "chat_id": snapshot
                                                                .data![index] ['chat_id'],
                                                            "item_id": snapshot
                                                                .data![index] ['item_id']
                                                                .toString(),
                                                            "item_name": snapshot
                                                                .data![index] ['item_name']
                                                                .toString(),
                                                            "item_quantity": snapshot
                                                                .data![index] ['item_quantity']
                                                                .toString(),
                                                            "item_price": snapshot
                                                                .data![index] ['item_price_per_unit']
                                                                .toString(),
                                                            "item_total": (double
                                                                .parse(snapshot
                                                                .data![index] ['item_total']
                                                                .toString()) +
                                                                double.parse(
                                                                    extracharges[i]))
                                                                .toString(),
                                                            "item_unit": snapshot
                                                                .data![index] ['item_unit'],
                                                            "renting_duration": snapshot
                                                                .data![index] ['rented_duration']
                                                                .toString(),
                                                            "check_in_time": snapshot
                                                                .data![index] ['check_in_time']
                                                                .toString(),
                                                            "Check_out_time": DateFormat(
                                                                "yyyy-MM-dd HH:mm:ss")
                                                                .format(
                                                                DateTime.now()),
                                                            "item_status": "CheckedOut"
                                                          }),);
                                                    if (clresponse.statusCode ==
                                                        200) {
                                                      var msgurl = Uri.https(
                                                          chatmessageapi,
                                                          'ChatMessages/chatmessage',
                                                          {
                                                            'id': clientid +
                                                                userid +
                                                                snapshot
                                                                    .data![index] ['chat_id']
                                                          });
                                                      var rentresponse = await http
                                                          .get(msgurl);
                                                      if (rentresponse.body
                                                          .isNotEmpty) {
                                                        var tagObjsJson = jsonDecode(
                                                            rentresponse
                                                                .body) as Map<
                                                            String,
                                                            dynamic>;
                                                        var respe = await http
                                                            .post(msgurl,
                                                            headers: <
                                                                String,
                                                                String>{
                                                              'Content-Type': 'application/json; charset=UTF-8',
                                                            },
                                                            body: jsonEncode(<
                                                                String,
                                                                String>{
                                                              "id": tagObjsJson['id'],
                                                              'user_id': tagObjsJson['user_id'],
                                                              'client_id': tagObjsJson['client_id'],
                                                              'message_id': tagObjsJson['message_id'],
                                                              'Chat_status': tagObjsJson['Chat_status'],
                                                              'payment_mode': tagObjsJson['payment_mode'],
                                                              'payment_status': tagObjsJson['payment_status'],
                                                              'transaction_id': tagObjsJson['transaction_id'],
                                                              'delivery_mode': tagObjsJson['delivery_mode'],
                                                              'status': tagObjsJson['status'],
                                                              'total': (double
                                                                  .parse(
                                                                  tagObjsJson['total']
                                                                      .toString()) +
                                                                  double.parse(
                                                                      extracharges[i]))
                                                                  .toString(),
                                                              'date': tagObjsJson['date'],
                                                              'time': tagObjsJson['time'],
                                                              'Advance_amount': tagObjsJson['Advance_amount'],
                                                              'pending_amount': (double
                                                                  .parse(
                                                                  tagObjsJson['pending_amount']
                                                                      .toString()) +
                                                                  double.parse(
                                                                      extracharges[i]))
                                                                  .toString(),
                                                              'file_url': tagObjsJson['file_url'],
                                                              'file_type': tagObjsJson['file_type'],
                                                              'file_key': tagObjsJson['file_key']
                                                            }));
                                                      }
                                                    }
                                                    var renturl = Uri.https(
                                                      rentedapi,
                                                      'RentedItem/renteditem',
                                                      {
                                                        'id': snapshot
                                                            .data![index]
                                                            .item_id
                                                      },);
                                                    var rentresponse = await http
                                                        .get(renturl);
                                                    if (rentresponse.body
                                                        .isNotEmpty) {
                                                      var tagObjsJson = jsonDecode(
                                                          rentresponse
                                                              .body) as Map<
                                                          String,
                                                          dynamic>;
                                                      var resp = await http
                                                          .post(renturl,
                                                        headers: <String,
                                                            String>{
                                                          'Content-Type': 'application/json; charset=UTF-8',
                                                        },
                                                        body: jsonEncode(
                                                            <String, String>{
                                                              "id": tagObjsJson['id']
                                                                  .toString(),
                                                              "user_id": tagObjsJson['user_id'],
                                                              "product_id": tagObjsJson['product_id'],
                                                              "rented_item_name": tagObjsJson['rented_item_name'],
                                                              "charger_per_duration": tagObjsJson['charger_per_duration'],
                                                              "product_engagement": "",
                                                              "rented_duration": tagObjsJson['rented_duration'],
                                                              "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                                                            }),);
                                                    }
                                                  }

                                                             },)
                                                         ]))
                                                   ],
                                                 ),
                                                 // ),
                                               );
                                             },
                                           );
                                         }
                                       }
                                     }
                                   }
                                 }
                              })
                            );
                        });}
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueGrey,
                      ),
                    ),
                  );}
            ),
            Row(children: [  Container(
                margin: EdgeInsets.only(left: 10),
                child:Row(children: [dmode==dmodesdel?Icon(Icons.delivery_dining):Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 8,),
                  Text(dmode==dmodesdel?dmodesdel:dmodestk),SizedBox(width: 8,),
                  Row(children: [   Icon(Icons.payment), SizedBox(width: 8,),
                    Text(pstatus, ), ],),
                  SizedBox(width: 15,),
                  Row(mainAxisAlignment:MainAxisAlignment.end,
                      crossAxisAlignment:CrossAxisAlignment.end,children: [   Text("Total", style: TextStyle(fontSize: 15),),
                  SizedBox(width: 15,),Text("₹"+total,style: TextStyle(fontSize: 15))]) ,],) ) ,],),
            status==pending? Container(width:double.infinity,
                margin:EdgeInsets.only(left: 20, right: 20, top: 8),
                height: 40,
                child:Row(children: [    Container(width:90,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                  child: TextButton(onPressed: () async {await Cancelorder(clientid, userid, oid, pstatus,  "Received");
                    print(itemlist);
                  await FirebaseAnalytics.instance.logEvent(
                    name: "cancelledorder_of_chat_by_client",
                    parameters: {
                      "user_id": userid,
                    },
                  );
                  var noturl=Uri.https(notifyapi, "Notification/notification");
                  var notsponse = await http.post(noturl,   headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                    body: jsonEncode(<String, String>{
                      "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                      "user_id": clientid,
                      "title":  shopname+  " has cancelled your order.",
                      "subtitle": "",
                      "payload": "",
                      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      "time": DateFormat("HH-mm-ss").format(DateTime.now())
                    }),);
                  var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                  var tkresponse= await http.get(tkurl );
                  if(tkresponse.body.isNotEmpty){
                    var jsonResponse = convert.jsonDecode(tkresponse.body) as Map<String, dynamic>;
                    for(int i=0; i<jsonResponse.length; i++){
                    sendPushMessage(jsonResponse['token'],  shopname +
                        " has Cancelled your order.", "");}
                  }
                  var turl= Uri.https(chatitemsapi, 'ChatItem/chatitems', );
                  var chatitemrespo= await http.get(turl);
                  if(chatitemrespo.body.isNotEmpty){
                    var tagObjsJson = jsonDecode(chatitemrespo.body)['products'] as List;
                    for(int i=0; i<tagObjsJson.length; i++){
                      var jsonResponse = tagObjsJson[i] as Map<String, dynamic>;
                      if(jsonResponse['user_id']==userid && jsonResponse['client_id']==clientid && jsonResponse['Chat_id']==oid){
                      itemlist.add(jsonResponse['item_name'].toString());}
                    }
                  }
                  if(advance!="0.0"){
                    var csurl = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord', {'id':userid+oid});
                    var chatitemrespo= await http.get(csurl);
                    if(chatitemrespo.body.isNotEmpty){
                      var tagObjsJson = jsonDecode(chatitemrespo.body)['products'] as Map<String, dynamic>;
                      var csresponse = await http.post(csurl,   headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                        body: jsonEncode(<String, String>{
                          "id":tagObjsJson['id'],
                          'user_id': tagObjsJson['user_id'],
                          'client_id': tagObjsJson['client_id'],
                          'record_id':tagObjsJson['record_id'],
                          'payment_status': tagObjsJson['payment_status'],
                          'payment_mode': tagObjsJson['payment_mode'],
                          'transaction_id': tagObjsJson['transaction_id'],
                          'received_amount':tagObjsJson['received_amount'],
                          'sent_amount':tagObjsJson['sent_amount'],
                          'party_name':tagObjsJson['party_name'],
                          'date': tagObjsJson['date'],
                          'time': tagObjsJson['time'],
                          'party': tagObjsJson['party'],
                          'description':tagObjsJson['description']+" You have a pending refund payment of ₹ "
                              +tagObjsJson['received_amount'].toString()+
                              " for "+tagObjsJson['party_name'].toString()+"'s cancelled order of "
                              +itemlist.toString()+"."
                        }),);
                    }
                    var clsurl = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord', {'id':clientid+oid});
                    var clhatitemrespo= await http.get(clsurl);
                    if(chatitemrespo.body.isNotEmpty){
                      var tagObjsJson = jsonDecode(clhatitemrespo.body)['products'] as Map<String, dynamic>;
                      var csresponse = await http.post(clsurl,   headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                        body: jsonEncode(<String, String>{
                          "id":tagObjsJson['id'],
                          'user_id': tagObjsJson['user_id'],
                          'client_id': tagObjsJson['client_id'],
                          'record_id':tagObjsJson['record_id'],
                          'payment_status': tagObjsJson['payment_status'],
                          'payment_mode': tagObjsJson['payment_mode'],
                          'transaction_id': tagObjsJson['transaction_id'],
                          'received_amount':tagObjsJson['received_amount'],
                          'sent_amount':tagObjsJson['sent_amount'],
                          'party_name':tagObjsJson['party_name'],
                          'date': tagObjsJson['date'],
                          'time': tagObjsJson['time'],
                          'party': tagObjsJson['party'],
                          'description':tagObjsJson['description'].toString()+ " You have a pending refund payment of ₹ "
                              +tagObjsJson['received_amount'].toString()+
                              " for "+tagObjsJson['party_name'].toString()+"'s cancelled order of "
                              +itemlist.toString()+"."
                        }),);
                    }
                    var noturl=Uri.https(notifyapi, "Notification/notification");
                    var notsponse = await http.post(noturl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                        "user_id": clientid,
                        "title":  "$restroname will refund your advance for the order request of "+itemlist.toString()+" later.",
                        "subtitle": "",
                        "payload": "",
                        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        "time": DateFormat("HH-mm-ss").format(DateTime.now())
                      }),);

                    showDialog(context: context, builder: (BuildContext context) {
                    var later;
                    var refundstatus;
                    return StatefulBuilder(builder: (BuildContext context, setState) {
                      return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          content:Card(child:Container(width: 400,
                              height:250,
                              child:Column(children: [
                                Container(padding: EdgeInsets.all(8),
                                  width: double.maxFinite,
                                  child: Center(child: Text("Payment Refund for"),),),
                                Container(width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  child: Center(child: Text("₹ "+total),),),
                                Container(width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  child: Center(child: Text("Sent by "+cshpname),),),
                                Container(width: double.maxFinite,
                                  padding: EdgeInsets.all(8),
                                  child: Center(child:Row(children: [
                                   Container(width:100,child: TextButton(child: Text("Pay Now"),onPressed: (){
                                      Refundorder(userid, clientid, oid, pstatus, "Cash", total);
                                      setState((){nw=true;
                                      paylater=false;
                                      timdel= false;});Navigator.pop(context);setState((){
                                      later= false;});
                                    },)),
                                   Container(width:100,child: TextButton(child: Text("Pay later"),onPressed: ()async{
                                      setState((){
                                        later= true;});
                                      Navigator.pop(context);},)),],) ),),


                              ],))));});});}},
                      child: Text("Cancel", style: TextStyle(color: Colors.white),)), ),
                  Container(width:90,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                    child:TextButton(onPressed: () async {
                      await FirebaseAnalytics.instance.logEvent(
                        name: "delivered_order_of_chat",
                        parameters: {
                          "user_id": userid,
                        },
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context)
                          {
                            return StatefulBuilder(builder: (BuildContext context, setState) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                content:Lottie.asset("assets/animations/deliver.json",
                                  repeat: true,) ,
                              );});});
                     await deliverorder(userid, clientid, oid);
                     setState((){  doc= Amplify.DataStore.query(
                       ChatMessage.classType,
                       where: ChatMessage.USER_ID.eq(userid).and(ChatMessage.CLIENT_ID.eq(clientid)),
                     );});
                      Navigator.of(context, rootNavigator: true).pop(context);
                      /*showDialog(
                          context: context,
                          builder: (BuildContext context)
                          {
                            return StatefulBuilder(builder: (BuildContext context, setState) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                content:Lottie.asset("assets/animations/deliver.json",
                                  repeat: true,) ,
                              );});});*/
                      }, child: Text("Deliver", style: TextStyle(color: Colors.white))),),
                  Container(
                      margin: EdgeInsets.only( left: 20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                      child:TextButton(onPressed: () async {
                        List<String> childitemlist=[];
                        List<String> childitempricelist=[];
                        List<String> childitemtotallist=[];
                        List<String> childitemidlist=[];
                        List<String> childitemimglist=[];
                        List<String> childitemquantitylist=[];
                        var url= Uri.https(chatitemsapi, 'ChatItem/chatitems');
                        var response= await http.get(url );
                        var tagObjsJson = jsonDecode(response.body)['products'] as List;
                        for(int i=0; i<tagObjsJson.length; i++){
                          var jsonResponse = convert.jsonDecode(tagObjsJson[i]) as Map<String, dynamic>;
                          if(jsonResponse['user_id']==userid && jsonResponse['client_id']== clientid && jsonResponse['chat_id']==oid){
                            childitemlist.add(jsonResponse['item_name'].toString());
                            childitempricelist.add(jsonResponse['item_price'].toString());
                            childitemquantitylist.add(jsonResponse['item_quantity'].toString());
                            childitemtotallist .add(jsonResponse['item_total'].toString());
                            childitemidlist    .add(jsonResponse['item_id'].toString());
                          }
                        }
                        print(childitemquantitylist);
                        await FirebaseAnalytics.instance.logEvent(
                          name: "printorder_of_chat_by_client",
                          parameters: {
                            "user_id": userid,
                          },
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Printorder(oid,"" ,date, time,
                              childitemlist, childitempricelist,childitemquantitylist,childitemtotallist , double.parse(total), pmode, "", "")),
                        );
                      }, child: Text("Print", style: TextStyle(color: Colors.white),))),])):
            status==delivered?Container(width:double.infinity,
              margin:EdgeInsets.only(left: 20, right: 20, top: 8),
              child:Center(child:Text("Waiting for approval", style: TextStyle(color: Colors.white, fontSize: 15),)) ,)  :
            Container(width:double.infinity,
                margin:EdgeInsets.only(left: 20, right: 20, top: 8),
                child: Center(child:Row(children:[Text("Delivered and approved", style: TextStyle(color: Colors.white, fontSize: 15),),
                  Container(
                    margin: EdgeInsets.only( left: 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                    child:TextButton(
                      onPressed:() async {
                        var checkincount=0;
                        var ordertotal=0.0;
                        var nameslist=[],unitlist=[], rentduration=[], ordercharge=[], extracharges=[], extratime=[], checkintime=[], productid=[];
                        var dt= DateTime.now().add(Duration(days: 3));
                        if(double.parse(total)>0){
                          var turl= Uri.https(chatitemsapi, 'ChatItem/chatitems',);
                          var chatitemrespo= await http.get(turl);
                          if(chatitemrespo.body.isNotEmpty){
                            var tagObjsJson = jsonDecode(chatitemrespo.body)['products'] as List;
                            for(int i=0; i<tagObjsJson.length; i++){
                              var jsonResponse = tagObjsJson[i] as Map<String, dynamic>;
                              if(jsonResponse['user_id']==userid && jsonResponse['client_id']==clientid
                                  && jsonResponse['Chat_id']==oid&& jsonResponse['Chat_id']!=""){

                                if(jsonResponse['item_unit'].toString()==month){
                                  var cdate= DateFormat("yyyy-MM-dd").parse(DateFormat("yyyy-MM-dd").format(DateFormat("yyyy-MM-dd HH;mm:ss").parse(jsonResponse['check_in_time'].toString())));
                                  var ndate= DateFormat("yyyy-MM-dd").parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                                  var d=DateTimeRange(start: cdate, end: DateTime(dt.year, dt.month + 2)).duration.inDays;
                                  var acalduration= d/30;
                                  print(acalduration);
                                  if(acalduration>double.parse(jsonResponse['renting_duration'].toString())){
                                    var extrduration= (acalduration-double.parse(jsonResponse['renting_duration'].toString()));
                                    var charge= extrduration*double.parse(jsonResponse['item_price'].toString());
                                    nameslist.add(jsonResponse['item_name'].toString());
                                    rentduration.add(jsonResponse['renting_duration'].toString());
                                    checkintime.add(jsonResponse['check_in_time'].toString());
                                    extratime.add((30.0*extrduration).toStringAsFixed(2));
                                    extracharges.add(charge.toStringAsFixed(0));
                                    ordercharge.add(jsonResponse['item_total'].toString());
                                    productid.add(jsonResponse['item_id'].toString());
                                    unitlist.add(day);
                                  }
                                }
                                if(jsonResponse['item_unit'].toString()==day){
                                  var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(jsonResponse['check_in_time'].toString());
                                  var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(dt));
                                  var d=DateTimeRange(
                                      start: cdate,
                                      end: dt)
                                      .duration
                                      .inHours;
                                  print("durations----- $d");
                                  var acalduration= d/24;
                                  print(d/24);
                                  print(cdate.difference(ndate).inDays);
                                  if(acalduration>double.parse(jsonResponse['renting_duration'].toString())){
                                    var extrduration= acalduration-double.parse(jsonResponse['renting_duration'].toString());
                                    var charge= extrduration*double.parse(jsonResponse['item_price'].toString());
                                    nameslist.add(jsonResponse['item_name'].toString());
                                    rentduration.add(jsonResponse['renting_duration'].toString());
                                    checkintime.add(jsonResponse['check_in_time'].toString());
                                    extratime.add(extrduration.toStringAsFixed(2));
                                    extracharges.add(charge.toStringAsFixed(0));
                                    ordercharge.add(jsonResponse['item_total'].toString());
                                    productid.add(jsonResponse['item_id'].toString());
                                    unitlist.add(hour);
                                  }
                                }
                                if(jsonResponse['item_unit'].toString()==hour){
                                  var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(jsonResponse['check_in_time'].toString());
                                  var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd-HH:mm:ss").format(DateTime.now().add(Duration(hours: 3))));
                                  var d=DateTimeRange(
                                      start: cdate,
                                      end: dt)
                                      .duration
                                      .inMinutes;
                                  print("durations----- $d");
                                  var acalduration= d/60;
                                  print(d/60);
                                  print(cdate.difference(ndate).inDays);
                                  if(acalduration>double.parse(jsonResponse['renting_duration'].toString())){
                                    var extrduration= acalduration-double.parse(jsonResponse['renting_duration'].toString());
                                    var charge= extrduration*double.parse(jsonResponse['item_price'].toString());
                                    nameslist.add(jsonResponse['item_name'].toString());
                                    rentduration.add(jsonResponse['renting_duration'].toString());
                                    checkintime.add(jsonResponse['check_in_time'].toString());
                                    extratime.add(extrduration.toStringAsFixed(2));
                                    extracharges.add(charge.toStringAsFixed(0));
                                    ordercharge.add(jsonResponse['item_total'].toString());
                                    productid.add(jsonResponse['item_id'].toString());
                                    unitlist.add(minute);

                                  }
                                }
                                itemlist.add(jsonResponse['item_name'].toString());}
                            }
                          }

                          if(checkincount!=0){if(nameslist.isNotEmpty){
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                var values;
                                return DraggableScrollableSheet(
                                  builder: (_, controller) =>  Container(height: 200,//scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:  <Widget>[
                                        ListTile(
                                          title: Table(
                                            defaultColumnWidth: IntrinsicColumnWidth(),
                                            children: [
                                              TableRow(
                                                  children: [
                                                    Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 100,child:Text('Item name(checkin time)', style: TextStyle(fontSize: 14.0)))]),
                                                    Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 100,child:Text('Rented duration (duration+extra)', style: TextStyle(fontSize: 14.0)))]),
                                                    Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 100,child:Text('Amount (total+ extra)', style: TextStyle(fontSize:14.0)))]),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: ListView.builder(
                                          itemCount: nameslist.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              title: Table(
                                                defaultColumnWidth: IntrinsicColumnWidth(),
                                                children: [
                                                  TableRow(
                                                      children: [
                                                        Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 80,child:Text(nameslist[index]+"("+checkintime[index]+")", style: TextStyle(fontSize: 14.0)))]),
                                                        Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 80,child:Text(rentduration[index]+"+"+extratime[index]+unitlist[index], style: TextStyle(fontSize: 14.0)))]),
                                                        Column(children:[Container(margin:EdgeInsets.only(left: 5, right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 80,child:Text("₹"+ordercharge[index]+"+₹"+extracharges[index], style: TextStyle(fontSize:14.0)))]),
                                                      ]),
                                                ],
                                              ),
                                            );
                                          },
                                        ),),
                                        Center(child:Row(children:[
                                          TextButton(  child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                              child:Center(child:Text("Ignore", style:TextStyle(color:Colors.white)))),
                                              onPressed:(){}),
                                          TextButton(
                                            child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                child:Center(child:Text("Add Extra", style:TextStyle(color:Colors.white)))),
                                            onPressed: ()async{
                                              for(int i=0; i<nameslist.length;i++){
                                                var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':userid+clientid+productid[i]});
                                                var response= await http.get(url );
                                                if(response.body.isNotEmpty){
                                                var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                                                var resp = await http.post(url,   headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                },
                                                  body: jsonEncode(<String, String>{
                                                    "id": tagObjsJson['id'],
                                                    "user_id": tagObjsJson['user_id'],
                                                    "client_id": tagObjsJson['client_id'],
                                                    "chat_id": tagObjsJson['chat_id'],
                                                    "item_id": tagObjsJson['item_id'].toString(),
                                                    "item_name": tagObjsJson['item_name'].toString(),
                                                    "item_quantity": tagObjsJson['item_quantity'].toString(),
                                                    "item_price": tagObjsJson['item_price_per_unit'].toString(),
                                                    "item_total": (double.parse(  tagObjsJson['item_total'].toString())+double.parse(extracharges[i])).toString(),
                                                    "item_unit": tagObjsJson['item_unit'],
                                                    "renting_duration": tagObjsJson['rented_duration'].toString(),
                                                    "check_in_time":tagObjsJson['check_in_time'],
                                                    "Check_out_time": "",
                                                    "item_status":""}),);}
                                                var clurl= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':clientid+userid+productid[i]});
                                                var clresponse= await http.get(clurl );
                                                if(clresponse.body.isNotEmpty){
                                                var tagjsJson = jsonDecode(clresponse.body) as Map<String, dynamic>;
                                                var respp = await http.post(clurl,   headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                },
                                                  body: jsonEncode(<String, String>{
                                                    "id": tagjsJson['id'],
                                                    "user_id": tagjsJson['user_id'],
                                                    "client_id": tagjsJson['client_id'],
                                                    "chat_id": tagjsJson['chat_id'],
                                                    "item_id": tagjsJson['item_id'].toString(),
                                                    "item_name": tagjsJson['item_name'].toString(),
                                                    "item_quantity": tagjsJson['item_quantity'].toString(),
                                                    "item_price": tagjsJson['item_price_per_unit'].toString(),
                                                    "item_total": (double.parse(  tagjsJson['item_total'].toString())+double.parse(extracharges[i])).toString(),
                                                    "item_unit": tagjsJson['item_unit'],
                                                    "renting_duration": tagjsJson['rented_duration'].toString(),
                                                    "check_in_time":tagjsJson['check_in_time'],
                                                    "Check_out_time": "",
                                                    "item_status":""}),);}
                                                ordertotal=ordertotal+double.parse(extracharges[i]);
                                                }
                                              var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':userid+clientid+oid});
                                              var response= await http.get(url );
                                              if(response.body.isNotEmpty){
                                                  var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                                                  var respe = await http.post(url,   headers: <String, String>{
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                  },
                                                    body: jsonEncode(<String, String>{
                                                      "id":tagObjsJson['id'],
                                                      'user_id': tagObjsJson['user_id'],
                                                      'client_id': tagObjsJson['client_id'],
                                                      'message_id': tagObjsJson['message_id'],
                                                      'Chat_status': tagObjsJson['Chat_status'],
                                                      'payment_mode': tagObjsJson['payment_mode'],
                                                      'payment_status':tagObjsJson['payment_status'],
                                                      'transaction_id': tagObjsJson['transaction_id'],
                                                      'delivery_mode': tagObjsJson['delivery_mode'],
                                                      'status': tagObjsJson['status'],
                                                      'total': (double.parse(tagObjsJson['total'].toString())+ordertotal).toString(),
                                                      'date': tagObjsJson['date'],
                                                      'time': tagObjsJson['time'],
                                                      'Advance_amount':tagObjsJson['Advance_amount'],
                                                      'pending_amount': (double.parse( tagObjsJson['pending_amount'].toString())+ordertotal).toString(),
                                                      'file_url'   :tagObjsJson['file_url'] ,
                                                      'file_type'  :tagObjsJson['file_type'] ,
                                                      'file_key'   :tagObjsJson['file_key']
                                                    }),);

                                              }
                                              var msgurl= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':clientid+userid+oid});
                                              var msgresponse= await http.get(url );
                                              if(msgresponse.body.isNotEmpty){
                                                var tagObjsJson = jsonDecode(msgresponse.body) as Map<String, dynamic>;
                                                var respe = await http.post(url,   headers: <String, String>{
                                                  'Content-Type': 'application/json; charset=UTF-8',
                                                },
                                                  body: jsonEncode(<String, String>{
                                                    "id":tagObjsJson['id'],
                                                    'user_id': tagObjsJson['user_id'],
                                                    'client_id': tagObjsJson['client_id'],
                                                    'message_id': tagObjsJson['message_id'],
                                                    'Chat_status': tagObjsJson['Chat_status'],
                                                    'payment_mode': tagObjsJson['payment_mode'],
                                                    'payment_status':tagObjsJson['payment_status'],
                                                    'transaction_id': tagObjsJson['transaction_id'],
                                                    'delivery_mode': tagObjsJson['delivery_mode'],
                                                    'status': tagObjsJson['status'],
                                                    'total': (double.parse(tagObjsJson['total'].toString())+ordertotal).toString(),
                                                    'date': tagObjsJson['date'],
                                                    'time': tagObjsJson['time'],
                                                    'Advance_amount':tagObjsJson['Advance_amount'],
                                                    'pending_amount': (double.parse( tagObjsJson['pending_amount'].toString())+ordertotal).toString(),
                                                    'file_url'   :tagObjsJson['file_url'] ,
                                                    'file_type'  :tagObjsJson['file_type'] ,
                                                    'file_key'   :tagObjsJson['file_key']
                                                  }),);
                                              }
                                              Navigator.pop(context);
                                            },)]))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );}
                          else{
                            print("nodus");

                          }
                          }
                          else{
                          }
                        }
                        else{Fluttertoast.showToast(msg: "sorry there are no items in this orderid");}},
                      child: Column(
                        children: const [
                          Icon(Icons.save_outlined,color:Colors.white ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('Complete', style:TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),)
                ])))
          ])
      );
  }
 Future<List> getchatitem(oid)async{
    var itemlist=[];
   var url= Uri.https(chatitemsapi, 'ChatItem/chatitems');
   var response= await http.get(url );
   var tagObjsJson = jsonDecode(response.body)['products'] as List;
   for(int i=0; i<tagObjsJson.length; i++) {
     var jsonResponse = convert.jsonDecode(tagObjsJson[i]) as Map<String, dynamic>;
     if(jsonResponse['user_id']==userid && jsonResponse['client_id']==clientid && jsonResponse['Chat_id']==oid){
       itemlist.add(jsonResponse);
     }
   }
   return itemlist;
   }

  Future<void> downloadFile(String fileurl, String ky, String flnm) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "downloaded_file_from_chat",
    );
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + "/"+flnm;
    final file = File(filepath);

    try {
      final result = await Amplify.Storage.downloadFile(
        key: ky,
        local: file,
        onProgress: (progress) {
          print('Fraction completed: ${progress.getFractionCompleted()}');
        },
      );
      final contents = await result.file.readAsBytes();
      print('decoded ----Downloaded contents: $contents');
      OpenFile.open(result.file.path);
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }
  Widget buildreceivedfile(BuildContext context,String date,String time, String flurl, String flnm, String ky,) {
    print(clientid);
    return Container(margin: EdgeInsets.only(right:60),
        decoration: BoxDecoration(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
          color: Theme.of(context).primaryColorLight
        ), padding:EdgeInsets.only(left:15, right:15, top:8, bottom: 10),
        child: Column(mainAxisSize:MainAxisSize.min,
            crossAxisAlignment:CrossAxisAlignment.end,
            mainAxisAlignment:MainAxisAlignment.end,children:[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Theme.of(context).backgroundColor,
            ),padding:EdgeInsets.only(left:10, right:10, top:5, bottom: 5),
            child:TextButton(child:Text(flnm, style:TextStyle(fontSize: 15, color: Theme.of(context).primaryColor)),
                    onPressed:(){downloadFile(flurl, ky, flnm);}),),
              SizedBox(height:6),
              Text(date, style:TextStyle(fontSize: 8),textAlign: TextAlign.end,),
              Text(time, style:TextStyle(fontSize: 8),)
            ]) );
  }

  Widget buildreceivedmessage(BuildContext context,String date,String time, String msg,) {
    print("jhgfdsawertyui      $clientid");
    return
        Expanded(child:
        Column(
            /*crossAxisAlignment:CrossAxisAlignment.start,
          mainAxisAlignment:MainAxisAlignment.start,*/children:[
         Text(msg, style:TextStyle(fontSize: 18)),
         Text(date, style:TextStyle(fontSize: 8)),
         Text(time, style:TextStyle(fontSize: 8)),
        ])
    );
  }
  Widget buildsentfile(BuildContext context,String date,String time, String flurl, String flnm, String ky,) {
    print(clientid);
    return Container(margin: EdgeInsets.only(left:70),
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                      color: Theme.of(context).backgroundColor
                  ), padding:EdgeInsets.only(left:15, right:15, top:8, bottom: 8),
                    child: Column(mainAxisSize:MainAxisSize.min,
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.start,
            children:[Container( //width:200,
            decoration: BoxDecoration(borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
              color: Theme.of(context).primaryColorLight,
            ),padding:EdgeInsets.only(left:10, right:10, top:5, bottom: 5),

            child:
              TextButton(child:
                Text(flnm, style:TextStyle(fontSize: 15, color: Theme.of(context).primaryColor)),
                  onPressed:(){downloadFile(flurl, ky, flnm);}),),
              SizedBox(height:6),
              Text(date, style:TextStyle(fontSize: 8),textAlign: TextAlign.end,),
              Text(time, style:TextStyle(fontSize: 8),)
            ]) );
  }

  Widget buildsentmessage(BuildContext context,String date,String time, String msg,) {
    print(clientid);
    return Expanded(
        child: Column(mainAxisSize:MainAxisSize.min,
                crossAxisAlignment:CrossAxisAlignment.end,
                mainAxisAlignment:MainAxisAlignment.end,children:[  Text(msg, style:TextStyle(fontSize: 18)),
              Text(date, style:TextStyle(fontSize: 8),textAlign: TextAlign.end,),
              Text(time, style:TextStyle(fontSize: 8),)
        ]) );
  }

  Refundorder(String usid, String clienid, String chatid, String pstatus, String pmode, total) async {
    var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':usid+clienid+chatid});
    var tresponse = await http.get(url);
    if(tresponse.body.isNotEmpty){
      var tagObjsJson = jsonDecode(tresponse.body) as Map<String, dynamic>;
      var respe = await http.post(url,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":tagObjsJson['id'],
          'user_id': tagObjsJson['user_id'],
          'client_id': tagObjsJson['client_id'],
          'message_id': tagObjsJson['message_id'],
          'Chat_status': tagObjsJson['Chat_status'],
          'payment_mode': tagObjsJson['payment_mode'],
          'payment_status':refunded,
          'transaction_id': tagObjsJson['transaction_id'],
          'delivery_mode': tagObjsJson['transaction_id'],
          'status': cancelled,
          'total': tagObjsJson['total'],
          'date': tagObjsJson['date'],
          'time': tagObjsJson['time'],
          'Advance_amount': tagObjsJson['Advance_amount'],
          'pending_amount': tagObjsJson['pending_amount'],
          'file_url'   : tagObjsJson['file_url']  ,
          'file_type'  : tagObjsJson['file_type'] ,
          'file_key'   :tagObjsJson['file_key']
        }),);
    }
    var cliurl= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':clienid+usid+chatid});
    var cltresponse = await http.get(cliurl);
    if(cltresponse.body.isNotEmpty){
      var tagObjsJson = jsonDecode(cltresponse.body) as Map<String, dynamic>;
      var respe = await http.post(cliurl,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":tagObjsJson['id'],
          'user_id': tagObjsJson['user_id'],
          'client_id': tagObjsJson['client_id'],
          'message_id': tagObjsJson['message_id'],
          'Chat_status': tagObjsJson['Chat_status'],
          'payment_mode': tagObjsJson['payment_mode'],
          'payment_status':refunded,
          'transaction_id': tagObjsJson['transaction_id'],
          'delivery_mode': tagObjsJson['transaction_id'],
          'status': cancelled,
          'total': tagObjsJson['total'],
          'date': tagObjsJson['date'],
          'time': tagObjsJson['time'],
          'Advance_amount': tagObjsJson['Advance_amount'],
          'pending_amount': tagObjsJson['pending_amount'],
          'file_url'   : tagObjsJson['file_url']  ,
          'file_type'  : tagObjsJson['file_type'] ,
          'file_key'   :tagObjsJson['file_key']
        }),);
    }
    var id=DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    var csurl = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
    var csresponse = await http.post(csurl,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":userid+id,
        'user_id': userid,
        'client_id': clientid,
        'record_id': id,
        'payment_status': refunded,
        'payment_mode': pmode,
        'transaction_id': transactionid,
        'received_amount':"0",
        'sent_amount': total,
        'party_name':cshpname,
        'date': DateFormat("yyyy-MM-dd").format(
            DateTime.now()),
        'time': DateFormat("HH:mm:ss").format(
            DateTime.now()),
        'party': supplier,
        'description': "You have refunded ${cshpname}'s advance for order no $chatid"
      }),);
    if(csresponse.statusCode==200){
      var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": userid+id,
            "user_id": userid,
            "record_id": id,
            "token_no": supplier,
            "order_id": chatid,
            "client_id": clientid,
            "received_amount": "0",
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "time": DateFormat("HH:mm:ss").format(DateTime.now()),
            "payment_mod": "",
            "sent_amount": total,
            "description":"You have refunded ${cshpname}'s advance for order no $chatid"
          }));
    }
    var clsresponse = await http.post(csurl,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":clientid+id,
        'user_id': clientid,
        'client_id': userid,
        'record_id': id,
        'payment_status': refunded,
        'payment_mode': pmode,
        'transaction_id': transactionid,
        'received_amount':"0",
        'sent_amount': total,
        'party_name':restroname,
        'date': DateFormat("yyyy-MM-dd").format(
            DateTime.now()),
        'time': DateFormat("HH:mm:ss").format(
            DateTime.now()),
        'party': supplier,
        'description':restroname+" have refunded your advance for order no "+chatid
      }),);
    if(clsresponse.statusCode==200){
      var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": clientid+id,
            "user_id": clientid,
            "record_id": id,
            "token_no": supplier,
            "order_id": chatid,
            "client_id": userid,
            "received_amount": "0",
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "time": DateFormat("HH:mm:ss").format(DateTime.now()),
            "payment_mod": "",
            "sent_amount": total,
            "description": restroname+" have refunded your advance for order no "+chatid
          }));
    }
    var acurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':userid+clientid});
    var acresponse= await http.get(acurl );
    if(acresponse.body.isNotEmpty){
      var jnResponse = convert.jsonDecode(acresponse.body) as Map<String, dynamic>;
      if (double.parse(jnResponse['Advance_amount'])>=0) {
        var remain = double.parse(jnResponse['Advance_amount'].toString()) + double.parse(total);
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
        var remain = double.parse(jnResponse['Pending_amount'].toString()) - double.parse(total);
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
        var remain = double.parse(jnResponse['Pending_amount'].toString()) - double.parse(total);
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
            jnResponse['Advance_amount'].toString()) +double.parse(total);
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
        "title":   restroname+" have refunded your advance for order no "+chatid,
        "subtitle": "",
        "payload": "",
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "time": DateFormat("HH-mm-ss").format(DateTime.now())
      }),);
    var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
    var tkresponse= await http.get(tkurl );
    if(tkresponse.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(tkresponse.body) as Map<String, dynamic>;
      sendPushMessage(jsonResponse['token'], restroname+" have refunded your advance for order no "+chatid, "");
    }
  }
  Widget buildCancelledorder(BuildContext context,String date,String time, String total, String oid,
      String dmode, String pmode, String pstatus, String chatstatus){
    print(clientid);
    return Container(
      child:Container(margin: chatstatus!="Received"?EdgeInsets.only(left: 120):EdgeInsets.only(right: 120),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
              bottomLeft:  chatstatus!="Received"? Radius.circular(25):Radius.circular(0),
            bottomRight:chatstatus!="Sent"?  Radius.circular(25):Radius.circular(0),
            topRight: Radius.circular(25),
          ),color: Colors.redAccent.shade100
          ),
          child:
          Column(children:[
            Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(children: [
              Container(width:100,child:Text("order id")), SizedBox(width: 30,),Text(time)],),),
            Container(
                margin: EdgeInsets.only(left: 10),
                child:Row(children: [Container(width:100,child:Text(oid)),
                  SizedBox(width: 30,),
                  Text(date),],) ) ,
           FutureBuilder<List>(
                future:  getchatitem(oid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: chatlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 1,
                            child: ListTile(
                              title: Container(child:Text(chatlist[index].item_name.toString()),),
                              trailing:Container(child:Text(chatlist[index].item_total.toString()),) ,
                            ),
                          );
                        });}
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blueGrey,
                      ),
                    ),
                  );}
            ),
            Row(children: [  SizedBox(width:15),dmode==dmodesdel?Icon(Icons.delivery_dining):Icon(Icons.shopping_bag_outlined),
              SizedBox(width: 8,),
              Text(dmode==dmodesdel?dmodesdel:dmodestk),SizedBox(width: 8,),
              Row(children: [   Icon(Icons.payment), SizedBox(width: 8,),
                Text(pstatus, ), ],),],),
            SizedBox(height:4),
            Divider(height: 4,),
            Container(width:double.infinity,
                margin: EdgeInsets.only(left: 20),
                child:Row(children: [Text("Total", style: TextStyle(fontSize: 15),),SizedBox(width: 80,),Text(total,style: TextStyle(fontSize: 15))],)),
            Divider(height: 4,),
            Container(width:double.infinity,
                margin:EdgeInsets.only(left: 20, right: 20, top: 4, bottom: 4),child:Row(children: [
                  Container(width:90,
                    child:Text("Cancelled", style: TextStyle(color: Colors.white),)) ,
               ],)),
            pstatus!=refunded&&chatstatus!=sent ?Center(child:Container(
                margin: EdgeInsets.only( right: 10),
                width:140,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                child: TextButton(
                onPressed: (){  var cashrefund, upirefund, modeofrefund, refundstatus;
                  refundstatus= "Paid";
                  modeofrefund= "Cash";
                  Refundorder(userid, clientid, oid, refundstatus, modeofrefund, total);
                  },
                child: Container(
                    child:Text("Refund",style: TextStyle(color: Colors.white),))))):Container(),
          ])
      ),);
  }
  Widget buildSentorder(BuildContext context,String date,String time, String total, String oid,
      String dmode, String pmode, String pstatus, String status, String advanse, String pending){
    print(clientid + pmode+ pstatus+status);
    return Container(margin: EdgeInsets.only(left: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          // bottomRight: Radius.circular(25),
          topRight: Radius.circular(25),
        ),color: Theme.of(context).backgroundColor
        ),
          child:
          Column(children:[
          Row(children:[  Container(
                margin: EdgeInsets.only(left:2),
                child: Text("Order no: "+oid), ),  SizedBox(width: 60,),Column(children: [Text(time,style :TextStyle(fontSize:12)),
            Text(date,style :TextStyle(fontSize:12))],) ]),
             Card(
              elevation: 0,
              child: ListTile(
                title:Row(children: [Container(width:25,child:Text("sts", style:TextStyle(fontSize:14)),),
                  SizedBox(width: 2,),
                  Container(width:80,child:Text("Itemname",style:TextStyle(fontSize:14)),),
                  SizedBox(width: 2,),
                  Container(width:50,child:Center(child: Text("Qty/🕝",style:TextStyle(fontSize:14)),)),
                  SizedBox(width: 2,),
                  Container(width: 65,child:Center(child:  Text("₹/unit",style:TextStyle(fontSize:14))))],) ,
                trailing:Container(child:Text("Total",style:TextStyle(fontSize:14)),) ,
              ),
            ),
            FutureBuilder<List>(
                future:  getchatitem(oid),
                builder: (context, snapshot) {
            if (snapshot.hasError) {
            return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {

            return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chatlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 1,
                          child: ListTile(
                               title:Row(children: [Container(width:25,child:Center(child:chatlist[index].item_status.toString()==delivered?Icon(Icons.check_circle_outlined, color:Colors.green):
                               chatlist[index].item_status.toString()=="not delivered"?Icon(Icons.cancel_outlined, color:Colors.red):
                              chatlist[index].item_status.toString()=="CheckedOut"?Icon(Icons.check_box, color:Colors.blue)
                                   :Icon(Icons.help_outline, ),),),
                                 SizedBox(width: 2,),
                                 Container(width:80,child:Text(chatlist[index].item_name.toString(),style:TextStyle(fontSize:15)),),
                              SizedBox(width: 2,),
                              Container(width:50,child: Center(child: Text(chatlist[index].item_quantity.toString()!=""?
                              chatlist[index].item_quantity.toString():"🕝"+chatlist[index].renting_duration.toString()/*+
                                  chatlist[index].item_unit.toString()==day?"d":chatlist[index].item_unit.toString()==hour?"hr"
                                  :chatlist[index].item_unit.toString()==month?"m":""*/,style:TextStyle(fontSize:15)),)),
                              SizedBox(width:2),
                              Container(width:65,child: Center(child: Text("₹"+chatlist[index].item_price.toString()+"/\n"+chatlist[index].item_unit.toString(),style:TextStyle(fontSize:15)),))],) ,
                            trailing:Container(child:Text("₹"+chatlist[index].item_total.toString(),style:TextStyle(fontSize:15)),) ,
                          ),
                        );
                      });}
            return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blueGrey,
                ),
                ),
            );}
        ),
            Row(children: [  SizedBox(width:15),dmode==dmodesdel?Icon(Icons.delivery_dining):Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 8,),
                  Text(dmode==dmodesdel?dmodesdel:dmodestk),SizedBox(width: 8,),
              Row(children: [   Icon(Icons.payment), SizedBox(width: 8,),
                    Text(pstatus, ), ],),
                 Container(width:140,alignment:Alignment.topRight,
                     child: Row(mainAxisAlignment:MainAxisAlignment.end,
                      crossAxisAlignment:CrossAxisAlignment.end,children:[ Text("Total", style: TextStyle(fontSize: 17),),
                  SizedBox(width: 8,),Text("₹"+total,style: TextStyle(fontSize: 17)) ]),)],),
            status=="Pending"? Container(width:double.infinity,
                margin:EdgeInsets.only(left: 50, right: 50, top: 8),
                height: 40,child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
              Container(
              margin: EdgeInsets.only( right: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
              child: TextButton(onPressed: () async {await Cancelorder(userid, clientid, oid, pstatus, "Sent");
              await FirebaseAnalytics.instance.logEvent(
                name: "cancelledorder_of_chat_by_user",
                parameters: {
                  "user_id": userid,
                },
              );
              var noturl=Uri.https(notifyapi, "Notification/notification");
              var notsponse = await http.post(noturl,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                  "user_id": clientid,
                  "title": ussuppliername.toString() +" from "+ restroname.toString() +" has cancelled their order.",
                  "subtitle": "",
                  "payload": "",
                  "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                  "time": DateFormat("HH-mm-ss").format(DateTime.now())
                }),);
              if(notsponse.statusCode==200){
                var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                var response= await http.get(url );
                var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                sendPushMessage(jsonResponse['token'].toString(), ussuppliername +" from "+ restroname.toString() +" has cancelled their order.", "");
              }
                if(advanse!=0){
                  var url= Uri.https(chatitemsapi, 'ChatItem/chatitems');
                  var response= await http.get(url );
                  var tagObjsJson = jsonDecode(response.body)['products'] as List;
                  for(int i=0; i<tagObjsJson.length; i++){
                    var jsonResponse = convert.jsonDecode(tagObjsJson[i]) as Map<String, dynamic>;
                    if(jsonResponse['user_id']==userid && jsonResponse['client_id']== clientid && jsonResponse['chat_id']==oid){
                      itemlist.add(jsonResponse['item_name']);
                    }
                  }
                  var curl= Uri.https(customerrecordapi, "CustomerRecords/customerrecord", {
                    "id":userid+clientid+oid
                 });
                  var crresponse= await http.get(curl );
                  if(crresponse.body.isNotEmpty){
                    var jsonResponse = convert.jsonDecode(crresponse.body) as Map<String, dynamic>;
                    var notsponse = await http.post(curl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":jsonResponse['id'],
                        "user_id": jsonResponse['user_id'],
                        'client_id': jsonResponse['client_id'],
                        'record_id': jsonResponse['record_id'],
                        'payment_status': jsonResponse['payment_status'],
                        'payment_mode': jsonResponse['payment_mode'],
                        'transaction_id':jsonResponse['transaction_id'],
                        'received_amount':jsonResponse['received_amount'],
                        'sent_amount': jsonResponse['sent_amount'],
                        'party_name': jsonResponse['party_name'],
                        'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                        'party': supplier,
                        'description':jsonResponse['description'].toString()+"\n"+
                            jsonResponse['party_name'].toString()+" has settled their refund on order cancellation of "
                            +itemlist.toString()+".",
                      }),);
                  }
                  var clurl= Uri.https(customerrecordapi, "CustomerRecords/customerrecord", {
                    "id":clientid+userid+oid
                  });
                  var clrresponse= await http.get(clurl );
                  if(clrresponse.body.isNotEmpty){
                    var jsonResponse = convert.jsonDecode(clrresponse.body) as Map<String, dynamic>;
                    var notsponse = await http.post(clurl,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":jsonResponse['id'],
                        "user_id": jsonResponse['user_id'],
                        'client_id': jsonResponse['client_id'],
                        'record_id': jsonResponse['record_id'],
                        'payment_status': jsonResponse['payment_status'],
                        'payment_mode': jsonResponse['payment_mode'],
                        'transaction_id':jsonResponse['transaction_id'],
                        'received_amount':jsonResponse['received_amount'],
                        'sent_amount': jsonResponse['sent_amount'],
                        'party_name': jsonResponse['party_name'],
                        'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                        'party': supplier,
                        'description':jsonResponse['description'].toString()+"\n"+
                            jsonResponse['party_name'].toString()+" has settled their refund on order cancellation of "
                            +itemlist.toString()+".",
                      }),);
                    if(notsponse.statusCode==200){
                      var noturl=Uri.https(notifyapi, "Notification/notification");
                      var notsponse = await http.post(noturl,   headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                        body: jsonEncode(<String, String>{
                          "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                          "user_id": clientid,
                          "title": ussuppliername.toString() +" from "+ restroname.toString() +" has settled their fund with their dues.",
                          "subtitle": "",
                          "payload": "",
                          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                          "time": DateFormat("HH-mm-ss").format(DateTime.now())
                        }),);
                      if(notsponse.statusCode==200){
                        var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                        var response= await http.get(url );
                        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                        sendPushMessage(jsonResponse['token'].toString(), ussuppliername +" from "+ restroname.toString() +" has settled their advanse with their dues.", "");
                        print("Notificationsuccess");
                      }
                    }
                  }
                  showDialog(  barrierDismissible: false, context: context, builder: (BuildContext context) {
                    var later;
                    return StatefulBuilder(builder: (BuildContext context, setState) {
                  return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content:Container(width: 400,
                      height:220,
                      child:SingleChildScrollView(scrollDirection:Axis.vertical,
                      child: Column(children: [
                        SizedBox(height: 8,),
                        Container(width: double.maxFinite,
                        child: Center(child: Text("Payment Refund for"),),),
                        SizedBox(height: 8,),
                        Container(width: double.maxFinite,
                          child: Center(child: Text("₹ "+total),),),
                        SizedBox(height: 8,),
                        Container(width: double.maxFinite,
                          child: Center(child: Text("Sent by "+cshpname),),),
                        SizedBox(height: 8,),
                        Container(width: double.maxFinite,
                          padding: EdgeInsets.all(15),
                          child: Row(children: [
                           Container(width:110,child: TextButton(
                              child: Text("Ask for refund"),onPressed: () async {
                             var curl= Uri.https(customerrecordapi, "CustomerRecords/customerrecord", {"id":userid+clientid+oid});
                             var crresponse= await http.get(curl );
                             if(crresponse.body.isNotEmpty){
                               var jsonResponse = convert.jsonDecode(crresponse.body) as Map<String, dynamic>;
                               var notsponse = await http.post(curl,   headers: <String, String>{
                                 'Content-Type': 'application/json; charset=UTF-8',
                               },
                                 body: jsonEncode(<String, String>{
                                   "id":jsonResponse['id'],
                                   "user_id": jsonResponse['user_id'],
                                   'client_id': jsonResponse['client_id'],
                                   'record_id': jsonResponse['record_id'],
                                   'payment_status': jsonResponse['payment_status'],
                                   'payment_mode': jsonResponse['payment_mode'],
                                   'transaction_id':jsonResponse['transaction_id'],
                                   'received_amount':jsonResponse['received_amount'],
                                   'sent_amount': jsonResponse['sent_amount'],
                                   'party_name': jsonResponse['party_name'],
                                   'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                   'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                                   'party': jsonResponse['party'],
                                   'description':"For "+jsonResponse['record_id'].toString()+" \nYou have sent "+
                                 jsonResponse['party_name'].toString()+" advance of ₹ "
                                 +jsonResponse['sent_amount'].toString()+" for your order request of "+itemlist.toString()+".\n"+
                                 "You asked "+jsonResponse['party_name'].toString()+" for refund on order cancellation of "
                                 +itemlist.toString()+"."
                                 }),);
                             }
                             var clurl= Uri.https(customerrecordapi, "CustomerRecords/customerrecord", {"id":clientid+userid+oid});
                             var clrresponse= await http.get(clurl );
                             if(clrresponse.body.isNotEmpty){
                               var jsonResponse = convert.jsonDecode(clrresponse.body) as Map<String, dynamic>;
                               var notsponse = await http.post(curl,   headers: <String, String>{
                                 'Content-Type': 'application/json; charset=UTF-8',
                               },
                                 body: jsonEncode(<String, String>{
                                   "id":jsonResponse['id'],
                                   "user_id": jsonResponse['user_id'],
                                   'client_id': jsonResponse['client_id'],
                                   'record_id': jsonResponse['record_id'],
                                   'payment_status': jsonResponse['payment_status'],
                                   'payment_mode': jsonResponse['payment_mode'],
                                   'transaction_id':jsonResponse['transaction_id'],
                                   'received_amount':jsonResponse['received_amount'],
                                   'sent_amount': jsonResponse['sent_amount'],
                                   'party_name': jsonResponse['party_name'],
                                   'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                   'time': DateFormat("HH:mm:ss").format(DateTime.now()),
                                   'party': jsonResponse['party'],
                                   'description':"For "+jsonResponse['record_id'].toString()+
                                       " \n"+jsonResponse['party_name'].toString()+ " has sent you advance of ₹ "
                                       +jsonResponse['received_amount'].toString()+" for their order request of "+itemlist.toString()+".\n"+
                                       jsonResponse['party_name'].toString()+" has asked you for refund of "+
                                       jsonResponse['received_amount'].toString()
                                       +" on order cancellation of " +itemlist.toString()+"."
                                 }),);
                             }
                             var noturl=Uri.https(notifyapi, "Notification/notification");
                             var notsponse = await http.post(noturl,   headers: <String, String>{
                               'Content-Type': 'application/json; charset=UTF-8',
                             },
                               body: jsonEncode(<String, String>{
                                 "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                 "user_id": clientid,
                                 "title": ussuppliername.toString() +" from "+ restroname.toString() +" has asked for their refund.",
                                 "subtitle": "",
                                 "payload": "",
                                 "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                 "time": DateFormat("HH-mm-ss").format(DateTime.now())
                               }),);
                             if(notsponse.statusCode==200){
                               var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                               var response= await http.get(url );
                               var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                               sendPushMessage(jsonResponse['token'].toString(), ussuppliername +" from "+ restroname.toString() +" has asked for their refund.", "");
                               print("Notificationsuccess");
                             }
                             var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': userid+clientid});
                             var response= await http.get(url );
                             var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                             if(jsonResponse.isNotEmpty){
                             var sponse = await http.post(url,   headers: <String, String>{
                               'Content-Type': 'application/json; charset=UTF-8',
                             },
                               body: jsonEncode(<String, String>{
                                 "id":jsonResponse['id'],
                                 "user_id": jsonResponse['user_id'],
                                 "client_id": jsonResponse['client_id'],
                                 "record_id": jsonResponse['record_id'],
                                 "party": jsonResponse['party'],
                                 "party_name": jsonResponse['party_name'],
                                 "Pending_amount": (double.parse(jsonResponse['Pending_amount'].toString())+double.parse(total)).toString(),
                               }),);}else{
                               var sponse = await http.post(url,   headers: <String, String>{
                                 'Content-Type': 'application/json; charset=UTF-8',
                               },
                                 body: jsonEncode(<String, String>{
                                   "id":userid+clientid,
                                   "user_id":userid,
                                   "client_id": clientid,
                                   "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                   "party": supplier,
                                   "party_name":csupplier,
                                   "Pending_amount": (double.parse(total)).toString(),
                                 }),);
                             }
               Navigator.pop(context);
                              },)),
                            Container(width:110,child: TextButton(
                            child: Text("Settle with your dues", style:TextStyle()),onPressed: () async {
                              Navigator.pop(context);},)),],),),
                      ],))));});});}
              },
                child: Text("Cancel", style: TextStyle(color: Colors.white),)), ),
              Container(
                  margin: EdgeInsets.only(left:10, right: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                  child:TextButton(onPressed: () async {
              List<String> childitemlist=[];
              List<String> childitempricelist=[];
              List<String> childitemtotallist=[];
              List<String> childitemidlist=[];
              List<String> childitemimglist=[];
              List<String> childitemquantitylist=[];
              var url= Uri.https(chatitemsapi, 'ChatItem/chatitems',);
              var response= await http.get(url );
              var tagObjsJson = jsonDecode(response.body)['products'] as List;
              for(int i=0; i<tagObjsJson.length; i++){
                  var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                  if(jnResponse['user_id']==userid && jnResponse['client_id']==clientid&& jnResponse['chat_id']==oid){
                    childitemlist.add(jnResponse['item_name'].toString());
                    childitempricelist.add(jnResponse['item_price'].toString());
                    childitemquantitylist.add(jnResponse['item_quantity'].toString());
                    childitemtotallist .add(jnResponse['item_total'].toString());
                    childitemidlist    .add(jnResponse['item_id'].toString());
                  }
              }
              await FirebaseAnalytics.instance.logEvent(
                name: "printorder_of_chat_by_user",
                parameters: {
                  "user_id": userid,
                },
              );
              print(childitemquantitylist);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Printorder(oid, "",date, time,
                    childitemlist, childitempricelist,childitemquantitylist,childitemtotallist , double.parse(total), pmode, "", "")),
              );
            }, child: Text("Print", style: TextStyle(color: Colors.white),))),]
         )):
            status==delivered?Container(width:double.infinity,
              margin:EdgeInsets.only(left: 20, right: 20, top: 8),
           child:Center(child:Container(
           margin: EdgeInsets.only( right: 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blue),
                    child:TextButton(child: Text("Approve", style: TextStyle(color: Colors.white, fontSize: 15),),
             onPressed: () async {await FirebaseAnalytics.instance.logEvent(
               name: "Approved_chatorder_delivery",
               parameters: {
                 "user_id": userid,
               },
             );
                      showprocessingdialog(context);
              await Approveorder(userid, clientid, oid);
                      Navigator.of(context, rootNavigator: true).pop(context);
             showDialog(context: context,  builder: (BuildContext context)
             {
               // return StatefulBuilder(context: context, builder: (BuildContext context, setState) {
                 return AlertDialog(
                  title: Text("Do you want these items to be stored in your stock"),
                   actions: [
                     Row(crossAxisAlignment: CrossAxisAlignment.center,
                         children: [ Container(child: Center(child: TextButton(onPressed: (){
                           Navigator.pop(context);
                         }, child: Text("No")),),),
                           TextButton(onPressed: (){
                             Navigator.of(context, rootNavigator: true).pop(context);
                           Navigator.push(context, MaterialPageRoute(builder: (context) => addsellingpricetochatorder(ccid: clientid, oid: oid)));
                         }
                               , child: Text("Yes"))]),
                   ],
                 );
               // });
             });},)) ),):
            Container(width:double.infinity,
                    margin:EdgeInsets.only(left: 20, right: 20, top: 8),
                    child: Text("Received", style: TextStyle(color: Colors.white, fontSize: 15),)),
            status==cancelled&& pstatus==refunded?Center(child:TextButton(child:Text("Approv Refund"),
            onPressed: (){
              Approvrefund(userid, clientid, oid, "Refund Approved", status, );
            },)):Container()
        ])
    );
  }
  Approvrefund(String uid, String cid, String msgid, String pays, String msgstatus, )async{
    var reurl=Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{
      "id":uid+cid+msgid
    });
    var response= await http.get(reurl );
    print(response.body);
    if(response.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var notsponse = await http.post(reurl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id": jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "client_id": jsonResponse['client_id'],
          "message_id": jsonResponse['message_id'],
          "Chat_status": jsonResponse['Chat_status'],
          "payment_mode": jsonResponse['payment_mode'],
          "payment_status": pays,
          "transaction_id": jsonResponse['transaction_id'],
          "delivery_mode": jsonResponse['delivery_mode'],
          "status": jsonResponse['status'],
          "total":jsonResponse['total'],
          'date': jsonResponse['date'],
          'time': jsonResponse['time']
        }),);
    }
    var clreurl=Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{
      "id":cid+uid+msgid
    });
    var clresponse= await http.get(reurl );
    print(clresponse.body);
    if(clresponse.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(clresponse.body) as Map<String, dynamic>;
      var notsponse = await http.post(reurl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id": jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "client_id": jsonResponse['client_id'],
          "message_id": jsonResponse['message_id'],
          "Chat_status": jsonResponse['Chat_status'],
          "payment_mode": jsonResponse['payment_mode'],
          "payment_status": pays,
          "transaction_id": jsonResponse['transaction_id'],
          "delivery_mode": jsonResponse['delivery_mode'],
          "status": jsonResponse['status'],
          "total":jsonResponse['total'],
          'date': jsonResponse['date'],
          'time': jsonResponse['time']
        }),);
    }
  }
  Cancelorder(String usid, String clienid, String chatid, String pstatus, String chatstatus) async {
    var reurl=Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{
      "id":usid+clienid+chatid
    });
    var response= await http.get(reurl );
    print(response.body);
    if(response.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var notsponse = await http.post(reurl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id": jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "client_id": jsonResponse['client_id'],
          "message_id": jsonResponse['message_id'],
          "Chat_status": jsonResponse['Chat_status'],
          "payment_mode": jsonResponse['payment_mode'],
          "payment_status": jsonResponse['payment_status'],
          "transaction_id": jsonResponse['transaction_id'],
          "delivery_mode": jsonResponse['delivery_mode'],
          "status": cancelled,
          "total":jsonResponse['total'],
          'date': jsonResponse['date'],
          'time': jsonResponse['time']
        }),);
    }

    var clurl=Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{
      "id":clienid+usid+chatid
    });
    var clresponse= await http.get(reurl );
    print(clresponse.body);
    if(clresponse.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(clresponse.body) as Map<String, dynamic>;
      var notsponse = await http.post(clurl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id": jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "client_id": jsonResponse['client_id'],
          "message_id": jsonResponse['message_id'],
          "Chat_status": jsonResponse['Chat_status'],
          "payment_mode": jsonResponse['payment_mode'],
          "payment_status": jsonResponse['payment_status'],
          "transaction_id": jsonResponse['transaction_id'],
          "delivery_mode": jsonResponse['delivery_mode'],
          "status": cancelled,
          "total":jsonResponse['total'],
          'date': jsonResponse['date'],
          'time': jsonResponse['time']
        }),);
      if(clresponse.statusCode==200){
       print("cancelled");
      }
    }
  }
  deliverorder(String usid, String clienid, String chatid) async {
    var candeliverorder= 0, renteditemcount=0;
    var url= Uri.https(chatitemsapi, 'ChatItem/chatitems',);
    var response= await http.get(url );
    var clientchattagObjsJson;
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==clientid && jnResponse['client_id']==userid&& jnResponse['chat_id']==chatid){
        clientchattagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
      }
      if(jnResponse['user_id']==userid && jnResponse['client_id']==clientid&& jnResponse['chat_id']==chatid){
        var url= Uri.https(stockapi, 'StockItemList/stockitem', {"id":jnResponse["item_id"]});
        var response= await http.get(url );
        if(response.body.isNotEmpty){
        var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
        if (double.parse(tagObjsJson['stock_quantity'].toString()) >=
            double.parse(jnResponse['item_quantity'].toString())) {
          await substractstock(usid, clienid, chatid,
              jnResponse['item_quantity'].toString(), jnResponse['item_name'].toString(), tagObjsJson['stock_quantity'].toString(),
              jnResponse['item_id'].toString());
          var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':jnResponse['item_id'].toString()});
          var response= await http.get(url );
          var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
          var res = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":tagObJson['id'].toString(),
              "user_id": tagObJson['user_id'],
              'client_id': tagObJson['client_id'],
              "chat_id": tagObJson['chat_id'],
              'item_name': tagObJson['item_name'],
              "item_price": tagObJson['item_price'],
              'item_total': tagObJson['item_total'],
              'item_quantity': tagObJson['item_quantity'],
              'item_id': tagObJson['item_id'],
              'item_unit': tagObJson['item_unit'],
              'check_in_time': tagObJson['check_in_time'],
              'renting_duration': tagObJson['renting_duration'],
              'item_status': delivered}),);
          if(res.statusCode==200){
            if(clientchattagObjsJson!=null){
              var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':clientchattagObjsJson['item_id'].toString()});
              var response= await http.get(url );
              var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
              var res = await http.post(url,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":tagObJson['id'].toString(),
                  "user_id": tagObJson['user_id'],
                  'client_id': tagObJson['client_id'],
                  "chat_id": tagObJson['chat_id'],
                  'item_name': tagObJson['item_name'],
                  "item_price": tagObJson['item_price'],
                  'item_total': tagObJson['item_total'],
                  'item_quantity': tagObJson['item_quantity'],
                  'item_id': tagObJson['item_id'],
                  'item_unit': tagObJson['item_unit'],
                  'check_in_time': tagObJson['check_in_time'],
                  'renting_duration': tagObJson['renting_duration'],
                  'item_status': delivered}),);
              setState(() {
                candeliverorder = candeliverorder + 1;});
            }
          }
        }
        else{}
        }
        else{
          var url= Uri.https(rentedapi, 'RentedItem/renteditem', {"id":jnResponse["item_id"]});
          var response= await http.get(url );
          if(response.body.isNotEmpty){
            var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
            if (tagObjsJson['product_engagement'].toString() != engaged) {
              var response = await http.post(url,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":tagObjsJson['id'].toString(),
                  "user_id": tagObjsJson['user_id'],
                  "product_id": tagObjsJson['product_id'],
                  "rented_item_name": tagObjsJson['rented_item_name'],
                  "charger_per_duration": tagObjsJson['charger_per_duration'],
                  "product_engagement": engaged,
                  "rented_duration": tagObjsJson['rented_duration'],
                  "rentout_to_client_id": clientid}),);
              if(response.statusCode==200){
                var checkin = DateFormat("yyyy-MM-dd HH:mm:ss").format(
                    DateTime.now());
                var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':jnResponse['item_id'].toString()});
                var response= await http.get(url );
                var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
                var res = await http.post(url,   headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                  body: jsonEncode(<String, String>{
                    "id":tagObJson['id'].toString(),
                    "user_id": tagObJson['user_id'],
                    'client_id': tagObJson['client_id'],
                    "chat_id": tagObJson['chat_id'],
                    'item_name': tagObJson['item_name'],
                    "item_price": tagObJson['item_price'],
                    'item_total': tagObJson['item_total'],
                    'item_quantity': tagObJson['item_quantity'],
                    'item_id': tagObJson['item_id'],
                    'item_unit': tagObJson['item_unit'],
                    'check_in_time': checkin,
                    'renting_duration': tagObJson['renting_duration'],
                    'item_status': delivered}),);
                if(res.statusCode==200){
                  if(clientchattagObjsJson!=null){
                    var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':clientchattagObjsJson['item_id'].toString()});
                    var response= await http.get(url );
                    var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
                    var res = await http.post(url,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":tagObJson['id'].toString(),
                        "user_id": tagObJson['user_id'],
                        'client_id': tagObJson['client_id'],
                        "chat_id": tagObJson['chat_id'],
                        'item_name': tagObJson['item_name'],
                        "item_price": tagObJson['item_price'],
                        'item_total': tagObJson['item_total'],
                        'item_quantity': tagObJson['item_quantity'],
                        'item_id': tagObJson['item_id'],
                        'item_unit': tagObJson['item_unit'],
                        'check_in_time': checkin,
                        'renting_duration': tagObJson['renting_duration'],
                        'item_status': delivered}),);
                    setState(() {
                      candeliverorder = candeliverorder + 1;});
                    if(res.statusCode==200){
                      if (jnResponse['item_unit'].toString() == year) {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                              id: 6,
                              channelKey: 'alarm_channel',
                              title: 'Time alloted for ${jnResponse['item_name']
                                  .toString()[i]} has been expired ',
                              fullScreenIntent: true,
                              body: "Request your customer to checkout.",
                              displayOnBackground: true,
                              wakeUpScreen: true,
                              bigPicture: "asset://assets/clock.jpg",
                              displayOnForeground: true,
                              category: NotificationCategory.Alarm,
                            ),
                            schedule: NotificationCalendar.fromDate(date: DateTime
                                .now()
                                .add(Duration(days: 365 * int.parse(
                                jnResponse['renting_duration'].toString())))),
                            actionButtons: [
                              NotificationActionButton(key: "d", label: "Okay"),
                            ]
                        );
                      }
                      if (jnResponse['item_unit'].toString() == month) {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                              id: 6,
                              channelKey: 'alarm_channel',
                              title: 'Time alloted for ${jnResponse['item_name']
                                  .toString()[i]} has been expired ',
                              fullScreenIntent: true,
                              body: "Request your customer to checkout.",
                              bigPicture: "asset://assets/clock.jpg",
                              displayOnBackground: true,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              category: NotificationCategory.Alarm,
                            ),
                            schedule: NotificationCalendar.fromDate(date: DateTime
                                .now().add(Duration(days: 30 * int.parse(
                                jnResponse['renting_duration'].toString())))),
                            actionButtons: [
                              NotificationActionButton(key: "d", label: "Okay"),
                            ]
                        );
                      }
                      if (jnResponse['item_unit'].toString() == day) {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                              id: 6,
                              channelKey: 'alarm_channel',
                              title: 'Time alloted for ${jnResponse['item_name']
                                  .toString()[i]} has been expired ',
                              fullScreenIntent: true,
                              body: "Request your customer to checkout.",
                              // la NotificationLayout.Default,
                              displayOnBackground: true,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              category: NotificationCategory.Alarm,
                            ),
                            schedule: NotificationCalendar.fromDate(date: DateTime
                                .now().add(Duration(days: int.parse(
                                jnResponse['renting_duration'].toString())))),
                            actionButtons: [
                              NotificationActionButton(key: "d", label: "Okay"),
                            ]
                        );
                      }
                      if (jnResponse['item_unit'].toString() == hour) {
                        AwesomeNotifications().createNotification(
                            content: NotificationContent(
                              id: 6,
                              channelKey: 'alarm_channel',
                              title: 'Time alloted for ${jnResponse['item_name']
                                  .toString()[i]} has been expired ',
                              fullScreenIntent: true,
                              body: "Request your customer to checkout.",
                              // la NotificationLayout.Default,
                              displayOnBackground: true,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              category: NotificationCategory.Alarm,
                            ),
                            schedule: NotificationCalendar.fromDate(date: DateTime
                                .now()
                                .add(Duration(hours: int.parse(
                                jnResponse['renting_duration'].toString())))),
                            actionButtons: [
                              NotificationActionButton(key: "d", label: "Okay"),
                            ]
                        );
                      }
                    }
                  }
                }
              }
            }
            else{
              var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':jnResponse['item_id'].toString()});
              var response= await http.get(url );
              var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
              var res = await http.post(url,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":tagObJson['id'].toString(),
                  "user_id": tagObJson['user_id'],
                  'client_id': tagObJson['client_id'],
                  "chat_id": tagObJson['chat_id'],
                  'item_name': tagObJson['item_name'],
                  "item_price": tagObJson['item_price'],
                  'item_total': tagObJson['item_total'],
                  'item_quantity': tagObJson['item_quantity'],
                  'item_id': tagObJson['item_id'],
                  'item_unit': tagObJson['item_unit'],
                  'check_in_time': tagObJson['check_in_time'],
                  'renting_duration': tagObJson['renting_duration'],
                  'item_status': notdeliverd}),);
              if(res.statusCode==200){
                if(clientchattagObjsJson!=null){
                  var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':clientchattagObjsJson['item_id'].toString()});
                  var response= await http.get(url );
                  var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
                  var res = await http.post(url,   headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                    body: jsonEncode(<String, String>{
                      "id":tagObJson['id'].toString(),
                      "user_id": tagObJson['user_id'],
                      'client_id': tagObJson['client_id'],
                      "chat_id": tagObJson['chat_id'],
                      'item_name': tagObJson['item_name'],
                      "item_price": tagObJson['item_price'],
                      'item_total': tagObJson['item_total'],
                      'item_quantity': tagObJson['item_quantity'],
                      'item_id': tagObJson['item_id'],
                      'item_unit': tagObJson['item_unit'],
                      'check_in_time': tagObJson['check_in_time'],
                      'renting_duration': tagObJson['renting_duration'],
                      'item_status': notdeliverd}),);
                  setState(() {
                    candeliverorder = candeliverorder + 1;});
                  if(res.statusCode==200){
                   print("renteditem is not available");
                  }
                }
              }
            }
          }
          else{
            var url= Uri.https(menuapi, 'Item/items', {"id":jnResponse["item_id"]});
            var response= await http.get(url );
            if(response.body.isNotEmpty){
                var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':jnResponse['item_id'].toString()});
                var response= await http.get(url );
                var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
                var res = await http.post(url,   headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                  body: jsonEncode(<String, String>{
                    "id":tagObJson['id'].toString(),
                    "user_id": tagObJson['user_id'],
                    'client_id': tagObJson['client_id'],
                    "chat_id": tagObJson['chat_id'],
                    'item_name': tagObJson['item_name'],
                    "item_price": tagObJson['item_price'],
                    'item_total': tagObJson['item_total'],
                    'item_quantity': tagObJson['item_quantity'],
                    'item_id': tagObJson['item_id'],
                    'item_unit': tagObJson['item_unit'],
                    'check_in_time': tagObJson['check_in_time'],
                    'renting_duration': tagObJson['renting_duration'],
                    'item_status': delivered}),);
                if(res.statusCode==200){
                  if(clientchattagObjsJson!=null){
                    var url= Uri.https(chatitemsapi, 'ChatItem/chatitem', {'id':clientchattagObjsJson['item_id'].toString()});
                    var response= await http.get(url );
                    var tagObJson = jsonDecode(response.body) as Map<String, dynamic>;
                    var res = await http.post(url,   headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                      body: jsonEncode(<String, String>{
                        "id":tagObJson['id'].toString(),
                        "user_id": tagObJson['user_id'],
                        'client_id': tagObJson['client_id'],
                        "chat_id": tagObJson['chat_id'],
                        'item_name': tagObJson['item_name'],
                        "item_price": tagObJson['item_price'],
                        'item_total': tagObJson['item_total'],
                        'item_quantity': tagObJson['item_quantity'],
                        'item_id': tagObJson['item_id'],
                        'item_unit': tagObJson['item_unit'],
                        'check_in_time': tagObJson['check_in_time'],
                        'renting_duration': tagObJson['renting_duration'],
                        'item_status': delivered}),);
                    setState(() {
                      candeliverorder = candeliverorder + 1;});
                  }
                }
              }

          }
        }
           }

      if(candeliverorder>0){
        var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':userid+clientid+chatid});
        var response= await http.get(url );
        if(response.body.isNotEmpty){
          var userresp = jsonDecode(response.body) as Map<String, dynamic>;
          var respe = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":userresp['id'].toString(),
              'user_id': userresp['user_id'],
              'client_id': userresp['client_id'],
              'message_id': userresp['message_id'],
              'Chat_status': userresp['Chat_status'],
              'payment_mode': userresp['payment_mode'],
              'payment_status': userresp['payment_status'],
              'transaction_id': userresp['transaction_id'],
              'delivery_mode': userresp['delivery_mode'],
              'status': delivered,
              'total': userresp['total'],
              'date': userresp['date'],
              'time': userresp['time']}),);
          if(respe.statusCode==200){
            var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':clientid+userid+chatid});
            var response= await http.get(url );
            if(response.body.isNotEmpty){
              var userresp = jsonDecode(response.body) as Map<String, dynamic>;
              var respe = await http.post(url,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":userresp['id'].toString(),
                  'user_id': userresp['user_id'],
                  'client_id': userresp['client_id'],
                  'message_id': userresp['message_id'],
                  'Chat_status': userresp['Chat_status'],
                  'payment_mode': userresp['payment_mode'],
                  'payment_status': userresp['payment_status'],
                  'transaction_id': userresp['transaction_id'],
                  'delivery_mode': userresp['delivery_mode'],
                  'status': delivered,
                  'total': userresp['total'],
                  'date': userresp['date'],
                  'time': userresp['time']}),);

            }
          }
        }
        var turl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id':clientid});
        var tknresponse= await http.get(turl );
        var cltoken = jsonDecode(tknresponse.body) as Map<String, dynamic>;
        var noturl= Uri.https(notifyapi, 'Notification/notification',);
        var notresponse = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            'user_id': clientid,
            'title':  restroname+  " has delivered your order."
                " Kindly approve order delivery.",
            'subtitle': "",
            'payload': "",
            'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
            'time': DateFormat("HH:mm:ss").format(DateTime.now())}),);
        if(notresponse.statusCode==200){
          sendPushMessage(cltoken['token'].toString(),
              restroname +
                  " has delivered your order."
                      " Kindly approve order delivery.", "");
        }
      }
      else{
        Fluttertoast.showToast(msg: "Sorry for inconvenience you don't have enough stock for this order or item is not engaged.");}

    }
  }
  substractstock(String userid, String clienid, String chatid, String quantit,
      String stcnamw, String presentquntity, String stcid) async {

    var turl= Uri.https(stockapi, 'StockItemList/stockitem',{'id':stcid});
    var tknresponse= await http.get(turl );
    var cltoken = jsonDecode(tknresponse.body) as Map<String, dynamic>;
    var response = await http.post(turl,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":cltoken['id'].toString(),
        "user_id": cltoken['user_id'],
        "stock_id":cltoken['stock_id'],
        "stock_name": cltoken['stock_name'],
        "stock_quantity":  (double.parse(presentquntity)-double.parse(quantit)).toString(),
        "stock_investment": cltoken['stock_investment'],
        "selling_price_per_unit": cltoken['selling_price_per_unit'],
        "constant_quantity":cltoken['constant_quantity'],
        "stock_status": cltoken['stock_status'],
        "stock_unit": cltoken['stock_unit']}),);
  }
    Approveorder(String usid, String clienid, String chatid) async {
      var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':userid+clientid+chatid});
      var response= await http.get(url );
      if(response.body.isNotEmpty){
        var userresp = jsonDecode(response.body) as Map<String, dynamic>;
        var respe = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":userresp['id'].toString(),
            'user_id': userresp['user_id'],
            'client_id': userresp['client_id'],
            'message_id': userresp['message_id'],
            'Chat_status': userresp['Chat_status'],
            'payment_mode': userresp['payment_mode'],
            'payment_status': userresp['payment_status'],
            'transaction_id': userresp['transaction_id'],
            'delivery_mode': userresp['delivery_mode'],
            'status': approved,
            'total': userresp['total'],
            'date': userresp['date'],
            'time': userresp['time']}),);
        if(respe.statusCode==200){
          var url= Uri.https(chatmessageapi, 'ChatMessages/chatmessage',{'id':clientid+userid+chatid});
          var response= await http.get(url );
          if(response.body.isNotEmpty){
            var userresp = jsonDecode(response.body) as Map<String, dynamic>;
            var respe = await http.post(url,   headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
              body: jsonEncode(<String, String>{
                "id":userresp['id'].toString(),
                'user_id': userresp['user_id'],
                'client_id': userresp['client_id'],
                'message_id': userresp['message_id'],
                'Chat_status': userresp['Chat_status'],
                'payment_mode': userresp['payment_mode'],
                'payment_status': userresp['payment_status'],
                'transaction_id': userresp['transaction_id'],
                'delivery_mode': userresp['delivery_mode'],
                'status': approved,
                'total': userresp['total'],
                'date': userresp['date'],
                'time': userresp['time']}),);
            if(respe.statusCode==200){
              if (userresp['Chat_status'].toString() == sent) {
                await updateprofitexpanseuserend(usid, userresp['total'].toString(),
                  userresp['payment_status'].toString(),  userresp['pending_amount'].toString(), userresp['Advance_amount'].toString(),);
                await updateEarnedclientend(clienid, userresp['total'].toString(),
                  userresp['payment_status'].toString(),userresp['pending_amount'].toString(), userresp['Advance_amount'].toString(),);
                  await updateExpanse(usid, userresp['total'].toString(),
                    userresp['payment_status'].toString(), chatid,
                   cshpname.toString(),
                    csupplier.toString(),userresp['pending_amount'].toString(), userresp['Advance_amount'].toString(),);
                //maintain  Customer record
                var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier',{'id':usid+clienid});
                var response= await http.get(url );
                if(response.body.isNotEmpty){
                var acceptresp = jsonDecode(response.body) as Map<String, dynamic>;
                {
                  // update customer record at userend
                  if (userresp['payment_status'].toString() == pending) {
                    if (double.parse(acceptresp['Advance_amount'].toString()) > 0) {
                      // check if there's any advance given to supplier
                      var amount = double.parse(
                          acceptresp['Advance_amount'].toString())+double.parse(userresp['total'].toString());
                      if (amount > 0) {
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount': amount.toString(),
                            'Pending_amount': "0",
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                      else{
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':'0',
                            'Pending_amount': (-amount).toString(),
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                    }
                    else {
                      // check if there's any advance given to supplier
                      var amount = double.parse(
                          acceptresp['Pending_amount'].toString())-double.parse(userresp['total'].toString());
                      if (amount > 0) { //update pending set advance to 0

                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':'0',
                            'Pending_amount': (amount).toString(),
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                      else{
                        var ad = amount + double.parse(userresp['Advance_amount'].toString());
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':(-amount).toString(),
                            'Pending_amount': '0',
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);}
                    }
                  }
                  else{//status paid
                    if (double.parse(acceptresp['Advance_amount'].toString()) > 0) {
                      // check if there's any advance given to supplier
                      var amount = double.parse(
                          acceptresp['Advance_amount'].toString())
                          + double.parse(userresp['total'].toString());
                      if (amount> 0) { //update pending set advance to 0
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':(amount).toString(),
                            'Pending_amount': '0',
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                      else{
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':'0',
                            'Pending_amount': (-amount).toString(),
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                    }
                    else {
                      // check if there's any advance given to supplier
                      var amount = double.parse(
                          acceptresp['Pending_amount'].toString())
                          -double.parse(userresp['total'].toString());
                      if (amount > 0) { //update pending set advance to 0
                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':acceptresp['Advance_amount'],
                            'Pending_amount': (amount).toString(),
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                      else{ //update pending set advance to 0

                        var response = await http.post(url,   headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                          body: jsonEncode(<String, String>{
                            "id":acceptresp['id'].toString(),
                            'user_id': acceptresp['user_id'],
                            'supplier_id': acceptresp['supplier_id'],
                            'Advance_amount':(-amount).toString(),
                            'Pending_amount': '0',
                            'shop_name': acceptresp['shop_name'],
                            'supplier_name': acceptresp['supplier_name']}),);
                      }
                    }
                  }
                }
                }
                var clurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier',{'id':usid+clienid});
                var clresponse= await http.get(clurl );
                if(clresponse.body.isNotEmpty){
                  var acceptresp = jsonDecode(clresponse.body) as Map<String, dynamic>;
                  {
                    // update customer record at userend
                    if (userresp['payment_status'].toString() == pending) {
                      if (double.parse(acceptresp['Advance_amount'].toString()) > 0) {
                        // check if there's any advance given to supplier
                        var amount = double.parse(
                            acceptresp['Advance_amount'].toString())-double.parse(userresp['total'].toString());
                        if (amount > 0) {
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount': amount.toString(),
                              'Pending_amount': "0",
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                        else{
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':'0',
                              'Pending_amount': (-amount).toString(),
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                      }
                      else {
                        // check if there's any advance given to supplier
                        var amount = double.parse(
                            acceptresp['Pending_amount'].toString())+double.parse(userresp['total'].toString());
                        if (amount > 0) { //update pending set advance to 0

                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':'0',
                              'Pending_amount': (amount).toString(),
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                        else{
                          var ad = amount + double.parse(userresp['Advance_amount'].toString());
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':(-amount).toString(),
                              'Pending_amount': '0',
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);}
                      }
                    }
                    else{//status paid
                      if (double.parse(acceptresp['Advance_amount'].toString()) > 0) {
                        // check if there's any advance given to supplier
                        var amount = double.parse(
                            acceptresp['Advance_amount'].toString())
                            + double.parse(userresp['total'].toString());
                        if (amount> 0) { //update pending set advance to 0
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':(amount).toString(),
                              'Pending_amount': '0',
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                        else{
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':'0',
                              'Pending_amount': (-amount).toString(),
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                      }
                      else {
                        // check if there's any advance given to supplier
                        var amount = double.parse(
                            acceptresp['Pending_amount'].toString())
                            -double.parse(userresp['total'].toString());
                        if (amount > 0) { //update pending set advance to 0
                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':acceptresp['Advance_amount'],
                              'Pending_amount': (amount).toString(),
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                        else{ //update pending set advance to 0

                          var response = await http.post(url,   headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                            body: jsonEncode(<String, String>{
                              "id":acceptresp['id'].toString(),
                              'user_id': acceptresp['user_id'],
                              'supplier_id': acceptresp['supplier_id'],
                              'Advance_amount':(-amount).toString(),
                              'Pending_amount': '0',
                              'shop_name': acceptresp['shop_name'],
                              'supplier_name': acceptresp['supplier_name']}),);
                        }
                      }
                    }
                  }
                }
                if(paystatus==pending){
                  await addpendingpayment(
                    chatid,  ussuppliername,restroname,
                    userresp['pending_amount'].toString(),
                    userresp['payment_status'].toString(),);}
                var noturl=Uri.https(notifyapi, "Notification/notification");
                var notsponse = await http.post(noturl,   headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                  body: jsonEncode(<String, String>{
                    "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                    "user_id": clientid,
                    "title": ussuppliername +" from "+ restroname +" has received their order.",
                    "subtitle": "",
                    "payload": "",
                    "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                    "time": DateFormat("HH-mm-ss").format(DateTime.now())
                  }),);
                var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                var tkresponse= await http.get(tkurl );
                if(tkresponse.body.isNotEmpty){
                  var jsonResponse = convert.jsonDecode(tkresponse.body) as Map<String, dynamic>;
                  sendPushMessage(jsonResponse['token'], ussuppliername +" from "+ restroname +" has received their order.", "");
                }
              }
            }

          }
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
          'Authorization': 'key=AAAAJar-Hqk:APA91bFIJP21yCDov5m95sLLjgi298b7-2N2Qjdy-VMmCjZvXFZC1dMVMoIzVUlpPc4YYezuAu7JqYaWftXNMRT40Ttlhtw5n0RixcQjy4pqzIu0BNuhUiKGc4g9rfes5heRSiJBB8ki',
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
  addpendingpayment( String orderid, String supplier, String shpname, String total,String paystatus,) async {
    print("total================================== $total");
    if(paystatus==pending){
      print("shopname----- $shpname");

      var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': clientid+userid});
      var response= await http.get(url );
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
           if(jsonResponse.isNotEmpty){
             var sponse = await http.post(url,   headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
               body: jsonEncode(<String, String>{
                 "id":jsonResponse['id'],
                 "user_id": jsonResponse['user_id'],
                 "client_id": jsonResponse['client_id'],
                 "record_id": jsonResponse['record_id'],
                 "party": jsonResponse['party'],
                 "party_name": jsonResponse['party_name'],
                 "Pending_amount": (double.parse(jsonResponse['Pending_amount'].toString())+double.parse(total)).toString(),
               }),);
      }
      else{
             var sponse = await http.post(url,   headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
               body: jsonEncode(<String, String>{
                 "id": clientid+userid,
                 "user_id": clientid,
                 "client_id": userid,
                 "record_id": orderid,
                 "party": supplier,
                 "party_name": shpname,
                 "Pending_amount": (double.parse(total)).toString(),
               }),);
         }
    }
  }
  updateExpanse(String usid,  String total, String pstatus, String oid, String shp, String spown, String pendi, String advanse) async {
    String pid= DateFormat("yyyyMMdd").format(DateTime.now()) ;
    print(total); print("pstatus0------------  $total ===  $pstatus");

    String id= DateFormat("yyyyMMdd").format(DateTime.now());
    String tim=  DateFormat("HH:mm:ss").format(DateTime.now());
    var url = Uri.https(expanserecapi, 'StockItemList/stockitem');
    var response = await http.post(url,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        "user_id": userid,
        "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
        "expanse_record_id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        "expanse_name": shp,
        "description": spown,
        "investment": total,
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "time": DateFormat("HH:mm:ss").format(DateTime.now()),
        "status": pending}),);
    var exurl = Uri.https(expanseapi, 'Expanse/expanse', {'id': userid+DateFormat("yyyyMMdd").format(DateTime.now())});
    var exresponse= await http.get(exurl);
    if(exresponse.body.isNotEmpty){
      var userresp = jsonDecode(exresponse.body) as Map<String, dynamic>;
    final http.Response eresponse =  await http.post(
      exurl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id":userresp['id'],
        "user_id": userresp['user_id'],
        "expanse_id": userresp['expanse_id'],
        "expanse": (double.parse(userresp['expanse'])+double.parse(total) ).toString(),
        "status": userresp['status'],
        "date":userresp['date']
      }),);}
    else{
      final http.Response eresponse =  await http.post(
        exurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
          "user_id": userid,
          "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
          "expanse": (double.parse(total) ).toString(),
          "status": pstatus,
          "date":DateFormat("yyyy-MM-dd").format(DateTime.now())}),);
    }
  }
  updateprofitexpanseuserend(String usid,  String total, String pstatus, String pendi, String advanse, ) async {
    String pid= DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url= Uri.https(profitapi, 'Profit/profit',{'id': userid+DateFormat("yyyyMMdd").format(DateTime.now())});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonesponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":jsonesponse['id'],
            "user_i": jsonesponse['user_i'],
            "profit_id": jsonesponse['profit_id'],
            "profit": (double.parse(jsonesponse['profit'])-double.parse(total)).toString(),
            "earned": jsonesponse['earned'],
            "expanse": (double.parse(jsonesponse['expanse'])+double.parse(total)).toString(),
            "date": jsonesponse['date'] ,
            "month":jsonesponse['month'] ,
            "year": jsonesponse['year']
          }));
      if(esponse.statusCode==200){
        doesmonthlyprofitrecordexist(usid, total, DateFormat("yyyyMMdd").format(DateTime.now()), pstatus, pending, advanse);
      }
    }else{
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
            "user_i": userid,
            "profit_id": DateFormat("yyyyMMdd").format(DateTime.now()),
            "profit": (double.parse(total)).toString(),
            "earned": '0',
            "expanse": (double.parse(total)).toString(),
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()) ,
            "month":DateFormat("MMMM").format(DateTime.now()) ,
            "year":DateFormat("yyyy").format(DateTime.now())
          }));
      if(esponse.statusCode==200){
        doesmonthlyprofitrecordexist(usid, total, DateFormat("yyyyMMdd").format(DateTime.now()), pstatus, pending, advanse);
      }
    }
  }
  doesmonthlyprofitrecordexist(String usid, String expn, String exdate, String pstate, String pedning, String advanse ) async {
    String proid=DateFormat("yMMMM").format(DateTime.now()) ;
    var mourl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id':userid+proid});
    var mpresponse= await http.get(mourl );
    if(mpresponse.body.isNotEmpty){
      var mpjsonesponse = convert.jsonDecode(mpresponse.body) as Map<String, dynamic>;
      var esponse = await http.post(
          mourl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":mpjsonesponse['id'],
            "user_id": mpjsonesponse['user_id'],
            "monthly_profit_id":mpjsonesponse['monthly_profit_id'],
            "monthly_profit": (double.parse(mpjsonesponse['monthly_profit'])-double.parse(expn)).toString(),
            "Earned_amount": mpjsonesponse['Earned_amount'],
            "Expanse_amount": (double.parse(mpjsonesponse['Expanse_amount'])+double.parse(expn)).toString(),
            "month": mpjsonesponse['month'],
            "year": mpjsonesponse['year']
          }));       print("profitmnthly add response ${esponse.statusCode}");

    }
    else{var esponse = await http.post(
        mourl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+proid,
          "user_id": userid,
          "monthly_profit_id":proid,
          "monthly_profit": (0-double.parse(proid)).toString(),
          "Earned_amount": "0",
          "Expanse_amount": expn,
          "month": DateFormat("MMMM").format(DateTime.now()),
          "year": DateFormat("yyyy").format(DateTime.now())
        }));       print("profitmnthly add response ${esponse.statusCode}");
    }
  }
  updateEarnedclientend(String clid,  String total, String pstatus, String pendi, String advanse)  async {
    var url= Uri.https(profitapi, 'Profit/profit',{'id': clid+DateFormat("yyyyMMdd").format(DateTime.now())});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonesponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":jsonesponse['id'],
            "user_i": jsonesponse['user_i'],
            "profit_id": jsonesponse['profit_id'],
            "profit": (double.parse(jsonesponse['profit'])+double.parse(total)).toString(),
            "earned": (double.parse(jsonesponse['earned'])+double.parse(total)).toString(),
            "expanse": (double.parse(jsonesponse['expanse'])).toString(),
            "date": jsonesponse['date'] ,
            "month":jsonesponse['month'] ,
            "year": jsonesponse['year']
          }));
      if(esponse.statusCode==200){}
    }
    else{
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
            "user_i": clid,
            "profit_id": DateFormat("yyyyMMdd").format(DateTime.now()),
            "profit": (double.parse(total)).toString(),
            "earned": (double.parse(total)).toString(),
            "expanse": '0',
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()) ,
            "month":DateFormat("MMMM").format(DateTime.now()) ,
            "year":DateFormat("yyyy").format(DateTime.now())
          }));

    }
  }
  updateprofitMonthlyreportclientearned(String cid, String total, String pstate, String pendi, String advanse) async {
    print("DEFERG");
    String proid=DateFormat("yMMMM").format(DateTime.now()) ;
    var mourl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id':cid+proid});
    var mpresponse= await http.get(mourl );
    if(mpresponse.body.isNotEmpty){
      var mpjsonesponse = convert.jsonDecode(mpresponse.body) as Map<String, dynamic>;
      var esponse = await http.post(
          mourl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":mpjsonesponse['id'],
            "user_id": mpjsonesponse['user_id'],
            "monthly_profit_id":mpjsonesponse['monthly_profit_id'],
            "monthly_profit": (double.parse(mpjsonesponse['monthly_profit'])-double.parse(total)).toString(),
            "Earned_amount":(double.parse(mpjsonesponse['Earned_amount'])+double.parse(total)).toString() ,
            "Expanse_amount": mpjsonesponse['Expanse_amount'],
            "month": mpjsonesponse['month'],
            "year": mpjsonesponse['year']
          }));       print("profitmnthly add response ${esponse.statusCode}");

    }
    else{var esponse = await http.post(
        mourl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+proid,
          "user_id": userid,
          "monthly_profit_id":proid,
          "monthly_profit": (0-double.parse(total)).toString(),
          "Earned_amount": total,
          "Expanse_amount": "0",
          "month": DateFormat("MMMM").format(DateTime.now()),
          "year": DateFormat("yyyy").format(DateTime.now())
        }));       print("profitmnthly add response ${esponse.statusCode}");
    }
  }

  Future<UpiResponse> initiateTransaction(UpiApp app, String clntupid,String clntshopname, String due ) async {
    return _upiIndia.startTransaction(

      app: app,
      receiverUpiId: "photographynexa@ybl",
      receiverName: clntshopname,
      transactionRefId: "UPITXREF"+DateFormat("yyMMddHHmmss").format(DateTime.now()),
      transactionNote: 'Payment to '+clntshopname+".",
      amount: double.parse(due.toString()),
    );
  }
  Widget displayUpiApps(amount) {
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
                onTap: () async {
                  _transaction = initiateTransaction(app, cuid, cshpname,amount);
                  print(UpiResponse);
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
  sendfiletochat(String url, String key, String flnm)async{
    var extension=flnm.split(".");
    var id= DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    var msgurl = Uri.https(chatmessageapi, 'ChatMessages/chatMessage');
    var response = await http.post(
        msgurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+id,
          "user_id": userid,
          "client_id": clientid,
          "message_id": id,
          "Chat_status": "Sent",
          "payment_status": "",
          "payment_mode": "",
          "transaction_id": "",
          "delivery_mode": "",
          "total": "",
          "status": "",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "Message": "",
          "file_url": url,
          "file_key":key,
          "file_type":flnm,

        }));
    var clresponse = await http.post(
        msgurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":clientid+id,
          "user_id": clientid,
          "client_id":userid ,
          "message_id": id,
          "Chat_status": received,
          "payment_status": "",
          "payment_mode": "",
          "transaction_id": "",
          "delivery_mode": "",
          "total": "",
          "status": "",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "Message": "",
          "file_url": url,
          "file_key":key,
          "file_type":flnm,
        }));
    var noturl=Uri.https(notifyapi, "Notification/notification");
    var notsponse = await http.post(noturl,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
        "user_id": clientid,
        "title":  "$restroname has sent you a file.",
        "subtitle": "",
        "payload": "",
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "time": DateFormat("HH-mm-ss").format(DateTime.now())
      }),);
        var tkurl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
        var tkresponse= await http.get(tkurl );
        if(tkresponse.body.isNotEmpty){
          var jsonResponse = convert.jsonDecode(tkresponse.body) as Map<String, dynamic>;
          sendPushMessage(jsonResponse['token'],  "$restroname has sent you a file.", "");
        }
  }
  void showprocessingdialog(context) {
    showDialog(context: context,  builder: (BuildContext context)
    {
      return AlertDialog(
        content: Container(height: double.maxFinite,
          width: double.maxFinite,
          child: Center(
            child: Lottie.asset("assets/animations/approvdelivery.json",
                // controller:controller ,
                // onLoaded: (composition){
                //   // controller.duration= composition.duration;
                //   controller.forward();
                // },
                // repeat: true,
                // animate: true
            ),
          ),),
      );
    });
  }
}

