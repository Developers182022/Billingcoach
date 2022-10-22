import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/Notifications.dart';
import '../models/ReceivedRequests.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'ChatPage.dart';
import 'Notifications.dart';
import 'ChatPage.dart';
import 'SeeSupplierdetails.dart';
import 'SubscriptionModule.dart';
import 'listserach.dart';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'login/Login.dart';
class SuppliersList extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SuppliersList({Key? key}) : super(key: key);
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
            home:
               const SuppliersListPage() //: SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class SuppliersListPage extends StatefulWidget {
  const SuppliersListPage({Key? key,}) : super(key: key);
  @override
  State<SuppliersListPage> createState() => _SuppliersListPageState();
}
class _SuppliersListPageState extends State<SuppliersListPage> {
  bool ActiveConnection = false;
  String T = "";
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
  final key= GlobalKey();
  final listkey= GlobalKey();
  List<String> itemlist=["item1", "item2"];
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  String date="";
  var doc;
  String time="";
  String userid= "";
  String restroname="", phoneno="", username="", areacode="", suppliername="";
  String itemimage="";
  var hm;
  var clientlist=[];
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var sid;
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List<dynamic> _list=[], _listphone=[], _listtoken=[], _listusid=[];
  String sent= "RequestSent",received= "RequestReceived", cansendreq= "CansendReq";
  List searchresult = [], searchname=[], searchtoken=[], requeststautus=[], clid=[];
  String  cshpname="", csuppliername="", cusername="";
  bool _isSearching= false;
  String _searchText = "";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

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
  Future<void>getclientlist(us)async{
    var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsuppliers',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print(tagObjsJson[i]);
        setState((){
          clientlist.add(jnResponse);
        });
      }
    }}
  }

  Future<void> getUserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      getclientlist(counter);
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
          areacode = jsonResponse['pincode'].toString();
        });
      }
    }else{
  runApp(LoginScreen());}
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
    _listphone = [];
    _listtoken = [];
    _listusid = [];
    var url = Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsuppliers',);
    var response = await http.get(url);
    if(response.body.isNotEmpty){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for (int i = 0; i < tagObjsJson.length; i++) {
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if (jnResponse['user_id'] == userid) {
        // setState(() {
          _listusid.add(jnResponse['supplier_id'].toString());
          _list.add(jnResponse['shop_name'].toString());
          _listphone.add(jnResponse['username'].toString());
        // });
      }
    }
  }

  }
  @override
  void initState() {
    CheckUserConnection();
    getUserdetails();
    super.initState();
    _isSearching = false;
    requestPermission();
    loadFCM();
    listenFCM();
    values();
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
          key: globalKey,
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
          leading:TextButton(onPressed:(){Scaffold.of(context).openDrawer();},child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),
              child:Icon(Icons.menu,color:Theme.of(context).primaryColor,))),
          title:Text("Suppliers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,
          color:Theme.of(context).primaryColor ),),
          bottom: Tab(
            child: Container(
              margin:EdgeInsets.only(bottom: 4),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _controller,
                style: new TextStyle(
                  color:Theme.of(context).primaryColor,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10, right: 10),
                focusColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            hintText: "Search your suppliers".tr(),
            prefixIcon: Icon(
                Icons.search),),
            onChanged:searchOperation,),)),
        ),
        body:  searchresult.length != 0 || _controller.text.isNotEmpty
                ? new ListView.builder(
              shrinkWrap: true,
              itemCount: searchresult.length,
              itemBuilder: (BuildContext context, int index) {
                String listData = searchresult[index];
                String listname= searchname[index];
                String status= requeststautus[index];
                print(searchname+requeststautus);
                String cleid= clid[index];
                return new ListTile(
                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatItemsPage(clid:cleid)));},
                  title: Container(margin: EdgeInsets.only( left: 25),child:  new Text(listname, style: TextStyle(fontSize: 20),),),
                   subtitle:Container(margin: EdgeInsets.only( left: 25),child:   new Text(listData.toString(),style: TextStyle(fontSize: 15),),),
                );
              },
            ):
            RefreshIndicator(onRefresh: ()async{
              await getclientlist(userid);},
            child:SingleChildScrollView(child: clientlist.isNotEmpty?Container(//color: Theme.of(context).primaryColorDark,
          child:
          ListView.builder(
                    shrinkWrap: true,
                    itemCount: clientlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatItemsPage(clid:clientlist[index]['supplier_id'])));
                          },
                          title: Row(children: [Container(width:150,
                            child:Column(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(clientlist[index]['shop_name'].toString()),
                                  Container(child:Text(clientlist[index]['supplier_name'].toString()),),
                      ]),),
                            ],),
                        ),
                      );
                    })
            ):
        Center(child:
        Column(children:[
          SizedBox(height: 15,),
          Lottie.asset("assets/animations/noclienterror.json", height: 250, width: 300),
          SizedBox(height: 10,),
          Text("You haven't added any suppliers yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          TextButton(onPressed: ()async{ await FirebaseAnalytics.instance.logEvent(
            name: "went_to_search_supplier",
            parameters: {
              "user_id":  userid,
            },
          );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListExample()));
          }, child: Container(
            decoration: BoxDecoration(
              color:Colors.blue,
              borderRadius: BorderRadius.circular(15)
            ),
            padding: EdgeInsets.all(15),
              child:Text("ADD YOUR FIRST SUPPLIER", style:TextStyle(color:Colors.white))))
        ])))),
      floatingActionButton:TextButton(
          onPressed: ()async {
            await FirebaseAnalytics.instance.logEvent(
              name: "went_to_search_supplier",
              parameters: {
                "user_id":  userid,
              },
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListExample()));
          },
          child:Container(width:160, height: 40,
              padding: EdgeInsets.only(left:15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child:Row(children: [Icon(
                Icons.person_add,
                color: Colors.white,
              ),SizedBox(width:4),Text("ADD SUPPLIER", style: TextStyle(color:Colors.white),)],) /*],) ,*/
            // backgroundColor: Colors.blue,
          )),),
    );
  }
  Future<void> searchOperation(String searchText) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "searched_accepted_supplier",
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
        String data = _listphone[i];
        String name = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
          searchname.add(name);
          clid.add(_listusid[i]);
          requeststautus.add(received);
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

}

