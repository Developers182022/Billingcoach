import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/Notifications.dart';
import '../models/ReceivedRequests.dart';
import '../models/SentRequest.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'SeeSupplierdetails.dart';
import 'SuppliersList.dart';
import 'login/Login.dart';
class ListExample extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}

class _SearchListExampleState extends State<ListExample> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var sid;
  final searchkey= GlobalKey();
  final listkey= GlobalKey();
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list=[], _listphone=[], _listtoken=[], _listusid=[];

  var hm;
  String sent= "RequestSent",received= "RequestReceived", cansendreq= "CansendReq";
  List searchresult = [], searchname=[], searchtoken=[], requeststautus=[], clid=[];
  String restroname="", suppliername="",  username="", cshpname="", csuppliername="", cusername="";
  bool _isSearching= false;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String _searchText = "";
  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }
  String userid="";
  getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': userid});
      var response= await http.get(url );
      if(response.body.isNotEmpty){
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print("stocklosy--  ${jsonDecode(response.body)}");
        setState(() {
          restroname = jsonResponse['shop_name'].toString();
          username = jsonResponse['username'].toString();
          suppliername = jsonResponse['supplier_name'].toString();
        });
      }
      /* List<Rzorkey> RzorKeys = await Amplify.DataStore.query(Rzorkey.classType);
     if(RzorKeys.isNotEmpty){
       setState((){link=RzorKeys[0].link.toString(); });
     }
     List<UserToken> UserTokens = await Amplify.DataStore.query(UserToken.classType,
         where: UserToken.USER_ID.eq(userid));
     if(UserTokens.isEmpty){
       await FirebaseMessaging.instance.getToken().then(
               (token) async {
             print(user.userId);
             final item = UserToken(
                 user_id: user.userId,
                 token: token);
             await Amplify.DataStore.save(item);});}*/
    }
    else{runApp(LoginScreen());}
  }
  @override
 void initState()  {
    super.initState();
    getuserdetails();
    print(clid);
    _isSearching = false;
    requestPermission();
    loadFCM();
    listenFCM();
    values();

  }
  Future getshowcasestatus()async{
    final SharedPreferences pref= await SharedPreferences.getInstance();
    hm= pref.getBool('showShowcase');
    var st= pref.getBool("showsearchsupplier");
    if(hm!=null){
      if(st==null){pref.setBool("showsearchsupplier", true);}
    }
    return st;
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
              icon: 'launch_background',
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
  Future<void> values() async {
    _list = [];
    _listphone=[];
    _listtoken=[];
    _listusid=[];
    var url= Uri.https(supplierapi, 'Suppliers/suppliers',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy--  ${jsonDecode(response.body)}");
      print("stocklosy--  ${jsonDecode(response.body)}");
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++){
      if(this.mounted){setState(() {
        _listusid.add( tagObjsJson[i]['supplier_id'].toString());
        _list.add(tagObjsJson[i]['shop_name'].toString());
        _listphone.add(tagObjsJson[i]['username'].toString());
      });}}
    }
   print(_list);
  }
  @override
  Widget build(BuildContext context)   {
    return new Scaffold(
        key: globalKey,
        appBar:AppBar(centerTitle: true,
          backgroundColor: Theme.of(context).primaryColorDark,
            leading: TextButton(child:Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey,width: 1)),
                padding:EdgeInsets.all(4),
                child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor, )),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SuppliersList()));}, ),
            title: TextField(
              controller: _controller,
              style: new TextStyle(
                color:Theme.of(context).primaryColor,
              ),
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search, color: Colors.grey),
                  hintText: "Search...",
                  hintStyle: new TextStyle(color: Colors.grey)),
              keyboardType: TextInputType.text,
              onChanged: searchOperation,
            ),
        ),
        body:RefreshIndicator(onRefresh: ()async{
          values();
        },
            child: new Container(
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
              child:new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                  child: searchresult.length != 0 || _controller.text.isNotEmpty
                      ? new ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchresult.length,
                    itemBuilder: (BuildContext context, int index) {
                      String listData = searchresult[index];
                      String listname= searchname[index];
                      String status= requeststautus[index];
                      print(searchname+requeststautus);
                      String cleid= clid[index];
                      print(cleid);
                      return new Container(padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Theme.of(context).primaryColorLight),
                          child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Container(margin: EdgeInsets.only( left: 25),child:  new Text(listname, style: TextStyle(fontSize: 20),),),
                      Container(margin: EdgeInsets.only( left: 25),child:   new Text(listData.toString(),style: TextStyle(fontSize: 15),),),
                     ButtonBar(
                          alignment: MainAxisAlignment.spaceAround,
                          buttonHeight: 32.0,
                          buttonMinWidth: 30.0,
                          children: [
                            cleid!=userid? Container(width:150,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                              child:status==cansendreq?
                              TextButton(onPressed: ()async{
                               /* await FirebaseAnalytics.instance.logEvent(
                                  name: "addedrequest_for_supplier",
                                  parameters: {
                                    "user_id":  userid,
                                    "client_id":cleid,
                                  },
                                );*/
                                  if(restroname.isNotEmpty){
                                      await getDetailsofuserandaddtorequest(cleid);
                                      values();}
                                    else{Fluttertoast.showToast(msg: "Kindly register your business as a supplier.");}
                               },
                                  child: Column(children: [Icon(Icons.add, color: Colors.white,),
                                    Text("Add request", style:TextStyle(color: Colors.white,) ,)],)):
                              status==received ? TextButton(onPressed: ()async{
                                await FirebaseAnalytics.instance.logEvent(
                                  name: "approvedrequest_for_supplier",
                                  parameters: {
                                    "user_id":  userid,
                                  },
                                );
                                      await getclientinfo(cleid);
                                      setState((){values();});},
                                  child: Column(children: [Icon(Icons.supervisor_account_sharp), Text("Approv")],))
                      : status==sent ?TextButton(onPressed: () async {
                               /* await FirebaseAnalytics.instance.logEvent(
                                  name: "cancelled_request_for_supplier",
                                  parameters: {
                                    "user_id":  userid,
                                  },
                                );*/
                      await cancelRequest(userid, clid[index]);
                      setState((){
                          values();});
                      Navigator.pop(context);},
                      child: Column(children: [Icon(Icons.person_add_disabled, color: Colors.white), Text("Cancel request", style:TextStyle(color: Colors.white))],)):Container(width: 1,),):Container(width: 1,),
                            cleid!=userid?  Container(width:150,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                      child: TextButton(onPressed: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierDetails(stid:clid[index])));
                              },
                                child: Column(children: [Icon(Icons.details, color: Colors.white,),
                                  Text("See details",  style:TextStyle(color: Colors.white,))],))): Container(width:double.maxFinite,
                                margin:EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                                child: TextButton(onPressed: ()async{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierDetails(stid:searchresult[index])));
                                },
                                    child: Column(children: [Icon(Icons.details, color: Colors.white,),
                                      Text("See details",  style:TextStyle(color: Colors.white,))],)))
                          ],
                        )//:Container()
                        ],
                      ));
                    },
                  )
                      :Center(
                      child:
                      Column(children:[
                        SizedBox(height: 25,),
                        Lottie.asset("assets/animations/connectwithclient.json", height: 250, width: 300),
                        Container(padding: EdgeInsets.only(left: 30, right: 30, top: 10,),
                            child:Center(child:Text("Search suppliers, and Stay connected with them.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            ) ),
                      ])))
            ],
          )),
        )));
  }
  cancelRequest(String uid, String clientid) async {
    print("iuytreszxcvbnjk $uid    $clientid");
    var rurl= Uri.https(receivedreqapi,'ReceivedRequest/receivedrequest',{'id': clientid+uid} );
    final http.Response response = await http.delete(rurl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'id': clientid+uid}),);
    if(response.statusCode==200){ print("received dekletw");
      var surl= Uri.https(sentreqapi,'SentRequest/sentrequest',{'id': uid+clientid} );
      final http.Response response = await http.delete(surl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }, body: jsonEncode(<String, String>{'id': uid+clientid}),);
    print("sent dekletw${response.statusCode}");
    }
  }
  Future<void> searchOperation(String searchText) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "searched_for_supplier",
      parameters: {
        "user_id":  userid,
      },
    );
    searchresult.clear();
    searchname.clear();
    requeststautus.clear();
    clid.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _listphone.length; i++) {
        print(_listphone[i]);
        var url= Uri.https(sentreqapi, 'SentRequest/sentrequest',{'id': userid+_listusid[i]} );
        var response= await http.get(url );
        if(response.body.isNotEmpty){
            var jnResponse =jsonDecode(response.body) as Map<String, dynamic>;
            if(jnResponse['user_id']==userid){print(jnResponse);
              print("exist");
              String data = _listphone[i];
              String name = _list[i];
              if (data.toLowerCase().contains(searchText.toLowerCase())) {
                searchresult.add(data);
                searchname.add(name);
                clid.add(_listusid[i]);
                requeststautus.add(sent);
              }
            }
            else{
              var url= Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequest',{'id': userid+_listusid[i]});
              var response= await http.get(url );
              if(response.body.isNotEmpty){
                  var jnResponse = jsonDecode(response.body) as Map<String, dynamic>;
                  if(jnResponse['user_id']==userid){print(jnResponse);
                  String data = _listphone[i];
                  String name = _list[i];
                  if (data.toLowerCase().contains(searchText.toLowerCase())) {
                    searchresult.add(data);
                    searchname.add(name);
                    clid.add(_listusid[i]);
                    requeststautus.add(received);
                  }
                  }
                  else{
                    String data = _listphone[i];
                    String name = _list[i];
                    if (data.toLowerCase().contains(searchText.toLowerCase())) {
                      searchresult.add(data);
                      searchname.add(name);
                      clid.add(_listusid[i]);
                      requeststautus.add(cansendreq);
                    }
                  }
                }
              else{
                String data = _listphone[i];
                String name = _list[i];
                if (data.toLowerCase().contains(searchText.toLowerCase())) {
                  searchresult.add(data);
                  searchname.add(name);
                  clid.add(_listusid[i]);
                  requeststautus.add(cansendreq);
                }}
            }
          }
        else{
          String data = _listphone[i];
          String name = _list[i];
          if (data.toLowerCase().contains(searchText.toLowerCase())) {
            searchresult.add(data);
            searchname.add(name);
            clid.add(_listusid[i]);
            requeststautus.add(cansendreq);
          }}

      /*   final SentRequests = await Amplify.DataStore.query(SentRequest.classType,
         where: SentRequest.USER_ID.eq(userid).and(SentRequest.CLIENT_PHONE_NO.eq(_listphone[i])));
        if (SentRequests.isEmpty) {
          print("not exist");
          final ReceivedRequestss = await Amplify.DataStore.query(ReceivedRequests.classType,
              where: ReceivedRequests.USER_ID.eq(userid).and(ReceivedRequests.CLIENT_PHONE_NO.eq(_listphone[i])));
          if(ReceivedRequestss.isEmpty){print("notexistin supplierreq");
          String data = _listphone[i];
          String name = _list[i];
          // String token= _listtoken[i];
          if (data.toLowerCase().contains(searchText.toLowerCase())) {
            searchresult.add(data);
            searchname.add(name);
            clid.add(_listusid[i]);
            requeststautus.add(cansendreq);
            // searchtoken.add(token);
          }}
          if(ReceivedRequestss.isNotEmpty){print("existin supplierreq");
            String data = _listphone[i];
            String name = _list[i];
            // String token= _listtoken[i];
            if (data.toLowerCase().contains(searchText.toLowerCase())) {
              searchresult.add(data);
              searchname.add(name);
              clid.add(_listusid[i]);
              requeststautus.add(received);
            }}
        }
       else {
          print("exist");
          String data = _listphone[i];
          String name = _list[i];
          if (data.toLowerCase().contains(searchText.toLowerCase())) {
            searchresult.add(data);
            searchname.add(name);
            clid.add(_listusid[i]);
            requeststautus.add(sent);
          }
        }*/
      }
    }
  }
  getDetailsofuserandaddtorequest(String listData) async {
    print("--------------  $listData");
    var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': listData} );
    var response= await http.get(url );
    print(response.body);
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("requesttstocklosy--  ${jsonDecode(response.body)}");
      var rurl=Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequest');
      var resonse = await http.post(rurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":listData+userid,
          "user_id": listData,
          "client_id": userid,
          "client_name": suppliername,
          "client_shop_name": restroname,
          "client_phone_no": username,
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now())}),);
      if(response.statusCode==200){print('Recievedesponse status: ${response.statusCode}');
      var surl=Uri.https(sentreqapi, 'SentRequest/sentrequest');
      var resonse = await http.post(surl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+listData,
          "user_id": userid,
          "client_id": jsonResponse["supplier_id"],
          "client_name":jsonResponse['supplier_name'],
          "client_phone_no":jsonResponse['username'],
          "client_shop_name":jsonResponse['shop_name'],
          "time":  DateFormat("HH:mm:ss").format(DateTime.now()),
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now())}),);
      if(resonse.statusCode==200){print("sent reqyest  ${resonse.statusCode}");
        var nurl=Uri.https(notifyapi, 'Notification/notification');
        var notresonse = await http.post(nurl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "user_id": listData,
            "title": "You have a supplier request from $restroname.",
            "subtitle": "",
            "payload": "",
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "time": DateFormat("HH:mm:ss").format(DateTime.now())}),);
        if(notresonse.statusCode==200){
          print("notif987654345678ication  ${notresonse.statusCode}");
          var url= Uri.https(tokenapi, 'UsertokenList/usertokens',{'id': listData} );
          var response= await http.get(url );
          if(response.body.isNotEmpty){
            var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
          sendPushMessage(jsonResponse['token'], "You have a supplier request from $restroname.", "");
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
   getclientinfo(String listData) async {

     var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': listData} );
     var response= await http.get(url );
     print(response.body);
     if(response.body.isNotEmpty){
       var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
       await approvRequest(userid, listData,
           jsonResponse['shop_name'].toString(),
           jsonResponse['supplier_name'].toString(),
           jsonResponse['supplier_phone_no'].toString(),
           jsonResponse['shop_address'].toString());
     }
   }
  approvRequest(String uid,String clientid, String clientshpname,
      String clientname,String clientphoneno,String clientshopaddress) async {
    var url= Uri.https(acceptedsupplierapi , 'AcceptedSuppliers/acceptedsupplier');
    var response= await http.post(
      url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      "__typename":"AcceptedSuppliers","_lastChangedAt":"1665783553527",
     "createdAt":DateTime.now().toString(),
        "supplier_address":"",
     "_version":"1",
        "supplier_phone_no":"",
        "id":userid+clientid,
        "user_id": userid,
        "supplier_id": clientid,
        "Advance_amount": "0",
        "Pending_amount": "0",
        "shop_name": clientshpname,
        "supplier_name": clientname
      }),
    );
      if(response.statusCode==200) {
        var url = Uri.https(
            acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier');
        var response = await http.post(
          url, headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "__typename": "AcceptedSuppliers",
            "_lastChangedAt": "1665783553527",
            "createdAt": DateTime.now().toString(),
            "supplier_address": "",
            "_version": "1",
            "supplier_phone_no": "",
            "id": clientid + uid,
            "user_id": clientid,
            "supplier_id": userid,
            "Advance_amount": "0",
            "Pending_amount": "0",
            "shop_name": restroname,
            "supplier_name": suppliername
          }),
        );
        if (response.statusCode == 200) {
          var nurl = Uri.https(notifyapi, 'Notification/notification');
          var notresonse = await http.post(nurl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "user_id": clientid,
              "title": suppliername + " from " + restroname +
                  " has approved your request!",
              "subtitle": "",
              "payload": "",
              "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
              "time": DateFormat("HH:mm:ss").format(DateTime.now())}),);
          if (notresonse.statusCode == 200) {
            var url = Uri.https(
                tokenapi, 'UsertokenList/usertokens', {'id': clientid});
            var response = await http.get(url);
            if (response.body.isNotEmpty) {
              var jsonResponse = convert.jsonDecode(response.body) as Map<
                  String,
                  dynamic>;
              sendPushMessage(jsonResponse['token'],
                  suppliername + " from " + restroname +
                      " has approved your request!", "");
            }
            var rurl = Uri.https(
                receivedreqapi, 'ReceivedRequest/receivedrequest',
                {'id': uid + clientid});
            final http.Response respnse = await http.delete(
              rurl, headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },);
            if (response.statusCode == 200) {
              var surl = Uri.https(sentreqapi, 'SentRequest/sentrequest',
                  {'id': clientid + uid});
              final http.Response response = await http.delete(
                surl, headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },);
            }
          }
        }
      }
  }
}