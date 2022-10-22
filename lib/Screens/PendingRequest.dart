import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/Notifications.dart';
import '../models/ReceivedRequests.dart';
import '../models/SentRequest.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'package:http/http.dart' as http;

import 'login/Login.dart';
import 'sentRequest.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class PendingRequests extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const PendingRequests({Key? key}) : super(key: key);
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
            home: const PendingRequestsPage(),
          );
        });
  }
}
class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({Key? key,}) : super(key: key);
  @override
  State<PendingRequestsPage> createState() => _PendingRequestsState();
}
class _PendingRequestsState extends State<PendingRequestsPage> {
  bool ActiveConnection = false;
  String T = "";
  var doc;
  String supliername="";
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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
  final receivedreq= GlobalKey();
  final sentreq= GlobalKey();
  String userid= "";
  var hm;
  var pendingrequests=[];
  String restroname="", phoneno="", address="", areacode="", profileimg="";
  String itemimage="";
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
  /*getsuppliers() async {
    final userdocument = await FirebaseFirestore.instance.collection("Supplier_details").where("userid", isEqualTo: userid).get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      setState((){
        usershpname= result.get("shop_name");
        useraddress= result.get("address");
        userphoneno= result.get("supplier_phone_no");
        username= result.get("shop_owner_name");});
    });
  });}*/
  getpendingreq(String us) async {
    var url= Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequests',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        pendingrequests.add(jnResponse);
      });
      }
      // print(jnResponse['item_name']);
    }
      
  }
  getuserdetails() async {
    try{
    AuthUser user= await Amplify.Auth.getCurrentUser();
    setState((){userid= user.userId;
    doc=  Amplify.DataStore.query(ReceivedRequests.classType,
      where:ReceivedRequests.USER_ID.eq(userid),);});
    getpendingreq(user.userId);
    List<Suppliers> Userdetailss = await Amplify.DataStore.query(Suppliers.classType,
        where: Suppliers.SUPPLIER_ID.eq(user.userId));
    if(Userdetailss.isNotEmpty){
    setState(() {
      restroname = Userdetailss[0].shop_name.toString();
      phoneno = Userdetailss[0].username.toString();
      address = Userdetailss[0].supplier_name.toString();
      areacode = Userdetailss[0].pincode.toString();
    });}
    }catch(e){
      runApp(LoginScreen());
    }
  }


  @override
  void initState() {
    CheckUserConnection();
    getuserdetails();
    // getsuppliers();

    requestPermission();
    loadFCM();
    listenFCM();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,

                  // channel.description,
                 /* color: Colors.transparent,
                  playSound: true,
                  icon: '@mipmap/logofront',
                  largeIcon: DrawableResourceAndroidBitmap("@mipmap/logofront"),
                  styleInformation: MediaStyleInformation(
                      htmlFormatContent: true, htmlFormatTitle: true)*/
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print("dialog");
      }
    });
    super.initState();
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
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/logofront',
                largeIcon: DrawableResourceAndroidBitmap("@mipmap/logofront"),
                styleInformation: MediaStyleInformation(
                    htmlFormatContent: true, htmlFormatTitle: true)
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
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child:  DefaultTabController(
      length: 2,
      child:Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor,)),onPressed: (){ //sendPushMessage("f8HDlfRRQkq7DQRjXp5s3l:APA91bG06z4-F_QbfHuGPzf5b3UAq-DIf0kkx8UHp6mkwLEW6IcEgawRtifNylS8XpY3gM2kMN3XawxJxPpAq51inhaskeA_IyTyoLp2QNsm2K6vHqfi9fg3LQvDYhHe84npkWK3N1e3", "$supliername has accepted you as a supplier.", "");
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));}, ),
            bottom:TabBar(
              labelColor:Theme.of(context).primaryColor,
              // unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              isScrollable: false,
              //controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.supervisor_account_outlined), text: 'Supplier Requests'),
               Tab(icon: Icon(Icons.person_add_alt_1_rounded), text: 'Sent Requests'),
              ],
            )
        ),
        body:RefreshIndicator(onRefresh: ()async{setState((){
        doc=  Amplify.DataStore.query(ReceivedRequests.classType,
          where:ReceivedRequests.USER_ID.eq(userid),
          /*pagination: QueryPagination( page: 1),*/);});},
            child:TabBarView(
          children: [ RefreshIndicator(onRefresh: ()async{await getpendingreq(userid);},
              child:pendingrequests.isNotEmpty? Container(//color: Theme.of(context).primaryColorDark,
          margin: EdgeInsets.only(bottom: 10, ),
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
            child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: pendingrequests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Row(children: [  Container(
                            margin: EdgeInsets.only(left: 20),
                            child:Column(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pendingrequests[index]['client_shop_name'].toString()),
                                  Container(child:Text(pendingrequests[index]['client_name'].toString())),]),),
                           ],),
                          subtitle:Row(children: [
                           Container(width: 120,
                               margin: EdgeInsets.all(10),
                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                               child: TextButton(onPressed: () async {await approvRequest(userid,pendingrequests[index]['client_id'].toString(),
                                   pendingrequests[index]['client_shop_name'].toString(),
                                   pendingrequests[index]['client_name'].toString(), pendingrequests[index]['client_phone_no'].toString(),
                                );
                                 setState((){doc=  Amplify.DataStore.query(ReceivedRequests.classType,
                                   where:ReceivedRequests.USER_ID.eq(userid),
                                   /*pagination: QueryPagination( page: 1),*/);});},
                                   child: Column(children: [Icon(Icons.supervisor_account_sharp), Text("Approve")],))),
                            Container(width: 120,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                                child: TextButton(onPressed: (){declineRequest(userid, pendingrequests[index]['client_id'].toString());
                               },
                                    child: Column(children: [Icon(Icons.supervisor_account_sharp), Text("Decline")],))),
                          ],)
                        ),
                          // onLongPress: ,
                      );
                    })/*;
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blueGrey,
                  ),
                ),
              );
            },
          )*/,))
                  : Center(child:
              Column(children:[
                SizedBox(height: 15,),
                Lottie.asset("assets/animations/supplierreq.json", height: 250, width: 300),
                SizedBox(height: 10,),
                Text("You don't have any request yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
              ])),),
            SentRequests()]))
      ),));
  }
  approvRequest(String uid,String clientid, String clientshpname,
      String clientname,String clientphoneno) async {
    print(clientid  + clientshpname+ clientphoneno+clientname+userid);
    var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': userid} );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy-uhgyuj-  ${jsonDecode(response.body)}");

      var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', );
      var sponse = await http.post(url,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":userid+clientid,
          "user_id": userid,
          "supplier_id": clientid,
          "Advance_amount": "0",
          "Pending_amount": "0",
          "shop_name": clientshpname,
          "supplier_name": clientname
        }),);
      if(sponse.statusCode==200){
        var sponse = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":clientid+userid,
            "user_id": clientid,
            "supplier_id": userid,
            "Advance_amount": "0",
            "Pending_amount": "0",
            "shop_name": restroname,
            "supplier_name": supliername
          }),);
        if(sponse.statusCode==200){
          var noturl=Uri.https(notifyapi, "Notification/notification");
          var notsponse = await http.post(noturl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
              "user_id": clientid,
              "title": supliername.toString() +" from "+ restroname.toString() +" has accepted you as a supplier.",
              "subtitle": "",
              "payload": "",
              "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
              "time": DateFormat("HH-mm-ss").format(DateTime.now())
            }),);
          if(notsponse.statusCode==200){
            var notsponse = await http.post(noturl,   headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
              body: jsonEncode(<String, String>{
                "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                "user_id": userid,
                "title": "You accepted "+clientshpname+" as a supplier.",
                "subtitle": "",
                "payload": "",
                "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                "time": DateFormat("HH-mm-ss").format(DateTime.now())
              }),);
            if(notsponse.statusCode==200){
              var reurl=Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequest',{
                "id":userid+clientid
              });
              var notsponse = await http.delete(reurl,   headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
                body: jsonEncode(<String, String>{
                  "id":userid+clientid
                }),);
              if(notsponse.statusCode==200){
                var senturl=Uri.https(sentreqapi, 'SentRequest/sentrequest',{
                  "id":clientid+userid
                });
                var notsponse = await http.delete(senturl,   headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                  body: jsonEncode(<String, String>{
                    "id":clientid+userid
                  }),);
                if(notsponse.statusCode==200){
                  var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': clientid} );
                  var response= await http.get(url );
                  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                  sendPushMessage(jsonResponse['token'].toString(), supliername +" from "+ restroname.toString() +" has accepted you as a supplier.", "");
                  var usrl= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': userid} );
                  var usresponse= await http.get(url );
                  var usjsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                  sendPushMessage(usjsonResponse['token'].toString(), 'You accepted "+clientshpname+" as a supplier.', "");

                }

              }

            }
          }
        }
      }


    }

  }
    declineRequest(String uid, String clientid) async {

      var reurl=Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequest',{
        "id":userid+clientid
      });
      var notsponse = await http.delete(reurl,   headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id":userid+clientid
        }),);
      if(notsponse.statusCode==200){
        var senturl=Uri.https(sentreqapi, 'SentRequest/sentrequest',{
          "id":clientid+userid
        });
        var notsponse = await http.delete(senturl,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":clientid+userid
          }),);}
    }
}

