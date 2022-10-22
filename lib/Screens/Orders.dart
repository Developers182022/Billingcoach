import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webappbillingcoach/Screens/print_order.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import '../models/AcceptedSuppliers.dart';
import '../models/ChatMessage.dart';
import '../models/ChatItems.dart';
import 'dart:math';
import '../models/Notifications.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'login/Login.dart';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:upi_india/upi_app.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import '../models/CompletedOrderItems.dart';
import '../models/CompletedOrders.dart';
import '../models/CustomerLis.dart';
import '../models/CustomerRecord.dart';
import '../models/DeletedOrder.dart';
import '../models/DeletedOrdersItems.dart';
import '../models/MenuItems.dart';
import '../models/PaymentRecords.dart';
import '../models/PendingOrderItems.dart';
import '../models/PendingOrders.dart';
import '../models/PendingPayments.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/RentedItems.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../models/Suppliers.dart';
import '../models/TempIte.dart';
import 'Add_order_Items.dart';
import 'ChatPage.dart';
import 'Notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../models/Expanse.dart';

import 'package:amplify_api/model_queries.dart';
class IncompleteOrders extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const IncompleteOrders({Key? key}) : super(key: key);
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
            home :const IncompleteOrdersPage(user: "userid"),
          );
        });
  }
}

late bool finalorderst;
late bool finalhmst;
class IncompleteOrdersPage extends StatefulWidget {
  const IncompleteOrdersPage({Key? key, required this.user}) : super(key: key);

  final String user;

  @override
  State<IncompleteOrdersPage> createState() => _itemPageState();
}
enum SingingCharacter { online, offline }
class _itemPageState extends State<IncompleteOrdersPage> with TickerProviderStateMixin {
  bool ActiveConnection = false;
  String T = "";
  String month="Month", day="Day", hour= "Hour", minute= "Minute", year="Year", checkedout= 'CheckedOut';
  bool show= true;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  var engaged= "Occupied", vaccant= "Vaccant";
  List<UpiApp>? apps;
  final notkey= GlobalKey();
  final floatkey= GlobalKey();
  final filterkey= GlobalKey();
  final swipekey= GlobalKey();
  final listkey= GlobalKey();
  bool ordershowcasestatus= false;
  String supplier= "Customer",offline="Offline", online= "Online" ,customername="", customerid="",
      paid= "Paid", transactionid="", sent= "Sent", cancelled= "Cancelled";
  String restroname="", username="", suppliername="", areacode="", profileimg="",paystatus="", paymode= "", deliverymode="", shpname="", shpid="";
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
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool upi=false, cash= false, nw= false, timdel= false, paylater= false, delivery= false, takeaway= false;
  String? mtoken = "";
  int pageIndex = 0;
  late String userid="";
  bool addorder= false, addorderbtn=true, additemtoorder=false,
      additemtoorderbtn=true, completeorder= false,completeorderbtn= true,
      cancelorder=false, cancelorderbtn=true;
  List<String> orderidcount=<String>[];
  List<int> price= <int>[];
  var o_id;
  var paymentmode;
  var sum=0;
  var home;
  var dashboard;
  var pending= "Pending";
  var doc;
  String completed= "completed";
  List<String> totalprice= <String>[];
  late final List<String> itemcount = <String>[];
  final Map counts = {};
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? selectedValueSingleMenu;
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> editableItems = [];
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),);
  String inputString = "";
  TextFormField? input;
  String mode="";
  bool onvalue = false, offvalue= false;
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  List list=[];
  var orderlist=[];
  var token="";
  bool _isSearching=false;
  String _searchText = "";
  List searchresult = [];
  var hm;
    Future<void> getorderlist(us)async{
      print("eoifdhgvbc");
      var url = Uri.https(pendingorderapi, 'Pendingorder/pendingorders');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print("oiuhg--------  ${response.body}");
      if(response.body.isNotEmpty) {
       var tagObjsJson = jsonDecode(response.body)['products'] as List;
        for (int i = 0; i < tagObjsJson.length; i++) {
          var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
          if (jnResponse['user_id'] == us) {
            print("outgj-- ");
            setState(() {
              orderlist.add(jnResponse);
            });
          }
        }
        print(orderlist);
      }

  }
  Future<List> getorderitemlist(ordrid)async{
      var itemorderlist=[];
    var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitems');
    var response = await http.get(url);
    if(response.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      for (int i = 0; i < tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if (jnResponse['user_id'] == userid &&
            jnResponse['order_id'] == ordrid) {
          setState(() {
            itemorderlist.add(jnResponse);
          });
        }
      }
    }
    return itemorderlist;

  }
  Future getnotificationfromstock(us) async{

    var url = Uri.https(stockapi, 'StockItemList/stockitems', );
    var res= await http.get(url);
    if(res.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(res.body)['products'] as List ;
      for(int i=0; i<tagObjsJson.length; i++){
        var json= tagObjsJson[i] as  Map<String, dynamic>;
        if (json['user_id'] == us) {
          if(double.parse(json['constant_quantity'].toString())*.02>=double.parse(json['stock_quantity'].toString())){
            await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: json['stock_name'].toString(),
                    body:json['stock_name'].toString()+" is out of stock.",
                  ),
                  schedule: NotificationCalendar(second: 0, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), repeats: false));
              print("_Supplier_request_fron client approved");
          }
          else if(double.parse(json['constant_quantity'].toString())*.05>=double.parse(json['stock_quantity'].toString())){
              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: json['stock_name'].toString(),
                    body:json['stock_name'].toString()+" is 5% remaining.",
                  ),
                  schedule: NotificationCalendar(second: 0, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), repeats: false));
          }
          else if(double.parse(json['constant_quantity'].toString())*.1>=double.parse(json['stock_quantity'].toString())){

              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: json['stock_name'].toString(),
                    body:json['stock_name'].toString()+" is 10% remaining.",
                  ),
                  schedule: NotificationCalendar(second: 0, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), repeats: false));

              print("_Supplier_request_fron client approved");

          }
          else if(double.parse(json['constant_quantity'].toString())*.25>=double.parse(json['stock_quantity'].toString())){
              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: json['stock_name'].toString(),
                    body:json['stock_name'].toString()+" is 25% remaining.",
                  ),
                  schedule: NotificationCalendar(second: 0, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), repeats: false));
          }
          else if(double.parse(json['constant_quantity'].toString())*.5>=double.parse(json['stock_quantity'].toString())){

              await AwesomeNotifications().createNotification(
                  content: NotificationContent(
                    id: 5,
                    channelKey: 'basic_channel',
                    title: json['stock_name'].toString(),
                    body: json['stock_name'].toString()+" is 50% remaining.",
                  ),
                  schedule: NotificationCalendar(second: 0, timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(), repeats: false));

            }
          }
      }
    }
  }

 Future<void> getuserdetails() async{
   final SharedPreferences prefs = await preferences;
   var counter = prefs.getString('user_Id');
   if(counter!=null){
     setState((){userid=counter;});
     getnotificationfromstock(counter);
     getorderlist(counter);
     var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
     var response= await http.get(url );
     if(response.body.isNotEmpty){
       var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
       if (this.mounted) {
         setState(() {
           restroname = jsonResponse['shop_name'].toString();
           username = jsonResponse['username'].toString();
           areacode = jsonResponse['supplier_name'].toString();
         });}
     }
   }
   else{runApp(LoginScreen());}
     }

  void  onClickedNotifications(String?payload) => print("navigate");

  @override
  void initState() {CheckUserConnection();
  tz.initializeTimeZones();
getuserdetails();
//   getorderlist(userid);
  _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
    setState(() {
      apps = value;
    });
  }).catchError((e) {
    apps = [];
  });
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
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/logofront',
                largeIcon: DrawableResourceAndroidBitmap("@mipmap/logofront"),
                styleInformation: MediaStyleInformation(
                    htmlFormatContent: true, htmlFormatTitle: true)
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
  // getnotificationfromstock();
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
  Future<void> _showFullScreenNotification() async {
    await showDialog(
      context: context,
      builder: (_) =>
          AlertDialog(
            title: const Text('Turn off your screen'),
            content: const Text(
                'to see the full-screen intent in 5 seconds, press OK and TURN '
                    'OFF your screen'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await flutterLocalNotificationsPlugin.zonedSchedule(
                      0,
                      'scheduled title',
                      'scheduled body',
                      tz.TZDateTime.now(tz.local).add(
                          const Duration(seconds: 5)),
                      const NotificationDetails(
                          android: AndroidNotificationDetails(
                              'full screen channel id',
                              'full screen channel name',
                              channelDescription: 'full screen channel description',
                              priority: Priority.high,
                              importance: Importance.high,
                              fullScreenIntent: true)),
                      androidAllowWhileIdle: true,
                      uiLocalNotificationDateInterpretation:
                      UILocalNotificationDateInterpretation.absoluteTime);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          ),
    );
  }
setdocbytoken(String tkn){
  setState((){
    doc=Amplify.DataStore.query(PendingOrders.classType,
      where:PendingOrders.USER_ID.eq(userid).and(PendingOrders.TOKEN_NO.eq(tkn)) ,
    ); });
}

  Widget displayUpiApps() {
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
                  _transaction = initiateTransaction(app, shpid, shpname );
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
  Future<UpiResponse> initiateTransaction(UpiApp app, String clntupid,String clntshopname ) async {
    var uuid = Uuid();
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "photographynexa@axl",
      receiverName: clntshopname,
      transactionRefId: uuid.v4(options: {
        'rng': UuidUtil.cryptoRNG
      }),
// -,
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
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

  SingingCharacter? _character = SingingCharacter.online;
  @override
  Widget build(BuildContext context) {
    List<int> selectedItemsMultiMenu = [];
    String? selectedValueSingleDialog;
    Future.delayed(const Duration(milliseconds: 500), ()async {
      final SharedPreferences pref= await SharedPreferences.getInstance();
      hm= pref.getBool('showShowcase');
      var st= pref.getBool("showdashboard");
      if(hm!=null){
        if(st==null){pref.setBool("showdashboard", true);}
      }
      return st;

      setState(() {
        home= hm;
      });

    });
    return WillPopScope(
      onWillPop: () async {
        print("orderbackpredd");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
            leading: TextButton(
                onPressed:(){Scaffold.of(context).openDrawer();},child:Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey,width: 1)),
                padding:EdgeInsets.all(4),child:
            Icon(Icons.menu,color:Theme.of(context).primaryColor,))),
           title: Text("Home".tr(),
             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,
             color:Theme.of(context).primaryColor,),
             textAlign: TextAlign.start,),
     actions: [

       IconButton(onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>ChatPage(cleid:userid)));
                   },
                     icon: Icon(Icons.notifications_active, color:Theme.of(context).primaryColor,)),
          /*  PopupMenuButton(
               icon:Icon(Icons.more_vert, color:Theme.of(context).primaryColor,),
             itemBuilder: (_) {
               return [
                  PopupMenuItem(
                    child:     TextButton(onPressed: () async {CheckUserConnection();
                   List<String> topsellingitem= [];
                    List mostPopularValues = [];

                    final posts = await Amplify.DataStore.query(
                      CompletedOrderItems.classType,
                      where: CompletedOrderItems.USER_ID.eq(userid),
                      pagination: QueryPagination(page: 0, limit: 5),
                    );
                    print(posts);
                    for(int i=0; i<posts.length; i++){setState((){
                      topsellingitem.add(posts[i].item_name.toString());
                      });}
                      topsellingitem.sort();
                      var popular = Map();
                      topsellingitem.forEach((l) {
                        if(!popular.containsKey(l)) {
                          popular[l] = 1;
                        } else {
                          popular[l] +=1;
                        }  });
                      print("cddsfds $popular");
                      List sortedValues = popular.values.toList()..sort();
                        var popularValue = sortedValues.reversed;
                        print("sortedValues  $popularValue       $sortedValues");
                        for(int i=(sortedValues.length-1); i>=0;i--){
                          print("$i  ");
                          print(popular.values.elementAt(i));
                          print(sortedValues[i]);
                         var k= popular.keys.firstWhere((k) => popular[k] == sortedValues[i], orElse: () => null);
                         if(popular.values.elementAt(i)==sortedValues[i]){
                            mostPopularValues.add(popular.keys.elementAt(i));
                         }
                        }

                      if(popular.isNotEmpty) {
                        // mostPopularValues=[];
                        showDialog(
                            barrierDismissible : show,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Top Selling item'),
                                content: Container(
                                    height: 300.0, // Change as per your requirement
                                    width: 300.0, // Change as per your requirement
                                    child:ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: popular.length>5?5:popular.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Container(
                                                      child:Text(popular.keys.elementAt(index))),
                                                );
                                              },
                                        )
                                ),
                              );
                            });}else{
                        Fluttertoast.showToast(msg:"You haven't sell any item yet.");
                      }

                    }, child: Row(children: [
                      Icon(Icons.account_balance_wallet_outlined, ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Top selling items".tr(),style: TextStyle()),
                    ],)
                    ),
                  ),
                 PopupMenuItem(child: ExpansionTile(title: Text("Filter", style:TextStyle(color:Theme.of(context).primaryColor)),
                   children: [
                     ListTile(title:    TextButton(onPressed: (){CheckUserConnection();
                     setState((){
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                         where:PendingOrders.USER_ID.eq(userid) ,
                         *//* sortBy: PendingOrders.descending()*//*); });
                     }, child: Row(children: [
                       Icon(Icons.account_balance_wallet_outlined, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("All".tr(), style: TextStyle(fontSize: 15), ),
                     ],)),
                     ),
                     ListTile(title:    TextButton(onPressed: (){CheckUserConnection();
                       var tokennum;
                        showDialog(context: context, builder: (BuildContext context){
                            return  StatefulBuilder(builder:  (BuildContext context, setState){
                              return AlertDialog(
                              content: Container(height:150,child: Column(
                              children: [
                                TextField(decoration: InputDecoration(hintText: "Token no.".tr(),
                                  prefixIcon: Icon(Icons.search),
                                ),keyboardType: TextInputType.number,
                                  onChanged: (value){
                                    setState((){tokennum= value.trim();});
                                  },),
                                Container(child:Center(child:TextButton(onPressed:(){
                                  setdocbytoken(tokennum);
                                },child:
                                Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),color:Colors.blue),
                                    padding:EdgeInsets.all(10),
                                    child:Text("Search", style: TextStyle(color:Colors.white),)))))
                              ])));});});

                     }, child: Row(children: [
                       Icon(Icons.search, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("Search by token no".tr(), style: TextStyle(fontSize: 15), ),
                     ],)),
                     ),
                     ListTile(title:   TextButton(onPressed: () {
                       setState(() {CheckUserConnection();
                       _dateTime = DateTime.now();
                       String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
                       print(formattedDate);
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                         where:PendingOrders.USER_ID.eq(userid).and(PendingOrders.DATE.eq(formattedDate)) ,
                         *//* sortBy: PendingOrders.descending()*//*);  });

                     },
                         child: Row(children: [
                           Icon(Icons.calendar_today, ),
                           SizedBox(
                             width: 10,
                           ),
                           Text("Filter by Today".tr()),
                         ],))),
                     ListTile(title:   TextButton(onPressed: () {
                       setState(() {CheckUserConnection();
                       _dateTime = DateTime.now().subtract(Duration(days:1));
                       String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
                       print(formattedDate);
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                         where:PendingOrders.USER_ID.eq(userid).and(PendingOrders.DATE.eq(formattedDate)) ,
                         *//* sortBy: PendingOrders.descending()*//*); });

                     },
                         child: Row(children: [
                           Icon(Icons.calendar_today, ),
                           SizedBox(
                             width: 10,
                           ),
                           Text("Filter by Yesterday".tr()),
                         ],))),
                     ListTile(title:   TextButton(onPressed: () {
                       showDatePicker(
                           context: context,
                           initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                           firstDate: DateTime(2001),
                           lastDate: DateTime(4021)
                       ).then((date) {
                         setState(() {CheckUserConnection();
                         _dateTime = date!;
                         String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
                         print(formattedDate);
                         doc=Amplify.DataStore.query(PendingOrders.classType,
                           where:PendingOrders.USER_ID.eq(userid).and(PendingOrders.DATE.eq(formattedDate)) ,
                           *//* sortBy: PendingOrders.descending()*//*); });
                       });
                     },
                         child: Row(children: [
                           Icon(Icons.calendar_today, ),
                           SizedBox(
                             width: 10,
                           ),
                           Text("Filter by date".tr()),
                         ],))),
                     ListTile(title:TextButton(onPressed: () async { DateTimeRange? newDateRange = await showDateRangePicker(context: context,
                         firstDate: DateTime(2001),
                         initialDateRange: dateRange,
                         lastDate: DateTime(4021)
                     );
                     setState(() {CheckUserConnection();
                     if (newDateRange == null) return;
                     dateRange = newDateRange;  //dateRange;
                     print(DateFormat("yyyy-MM-dd").format(newDateRange.start));
                     print(DateFormat("yyyy-MM-dd").format(newDateRange.end));
                     doc=Amplify.DataStore.query(PendingOrders.classType,
                       where:PendingOrders.USER_ID.eq(userid).and(PendingOrders.DATE.between(DateFormat("yyyy-MM-dd").format(newDateRange.start),
                           DateFormat("yyyy-MM-dd").format(newDateRange.end))),
                       *//* sortBy: PendingOrders.descending()*//*); });

                     }, child: Row(children: [
                       Icon(Icons.date_range, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("Filter by date range".tr()),
                     ],))),
                   ],
                 )),
                 PopupMenuItem(child: ExpansionTile(title: Text("Sort",style:TextStyle(color:Theme.of(context).primaryColor)),
                   children: [
                     ListTile(title:TextButton(onPressed: (){CheckUserConnection();
                     setState((){
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                           where:PendingOrders.USER_ID.eq(userid),
                           sortBy: [PendingOrders.DATE.descending()]); });
                     }, child: Row(children: [
                       Icon(Icons.calendar_today, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("Sort By date".tr(),),
                     ],))),
                     ListTile(title:   TextButton(onPressed: (){CheckUserConnection();
                     setState((){
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                           where:PendingOrders.USER_ID.eq(userid),
                           sortBy: [PendingOrders.TOTAL.descending()]);
                     });
                     }, child: Row(children: [
                       Icon(Icons.money, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("Sort by price".tr()),
                     ],)),),
                     ListTile(title: TextButton(onPressed: (){CheckUserConnection();
                     setState((){
                       doc=Amplify.DataStore.query(PendingOrders.classType,
                           where:PendingOrders.USER_ID.eq(userid),
                           sortBy: [PendingOrders.TIME.descending()]);
                     });
                     }, child: Row(children: [
                       Icon(Icons.alarm, ),
                       SizedBox(
                         width: 10,
                       ),
                       Text("Sort by time".tr()),
                     ],)))

                   ],
                 )),
               ];
             },
           ),*/
          ],
       ),
        body:  RefreshIndicator(onRefresh: ()async{},
            child:/*orderlist.length!=0?*/Container( child:
                  ToggleList(
                      divider: const SizedBox(height: 10),
                      toggleAnimationDuration: const Duration(milliseconds: 400),
                      scrollPosition: AutoScrollPosition.begin,
                      trailing: const Padding(
                        padding: EdgeInsets.all(10),
                        child:Icon(Icons.expand_more),
                      ),
                      children: List.generate(orderlist.length, (index) => ToggleListItem(//parent list
                        title:Dismissible(
                          onDismissed: (DismissDirection direction) async {
                       /*     if(direction==DismissDirection.startToEnd) {
                              var checkincount=0;
                              var ordertotal=0.0;
                              var nameslist=[],unitlist=[], rentduration=[], ordercharge=[], extracharges=[], extratime=[], checkintime=[], productid=[];
                              var dt= DateTime.now().add(Duration(days: 3));
                              if(double.parse(orderlist[index].total.toString())>0){
                                List<PendingOrderItems> PendingOrderItemss = await Amplify.DataStore.query(PendingOrderItems.classType,
                                    where:PendingOrderItems.USER_ID.eq(userid).and(PendingOrderItems.ORDER_ID.eq(orderlist[index].order_id.toString())) );
                                for(int i=0; i<PendingOrderItemss.length; i++){
                                  if(PendingOrderItemss[i].renting_duration.toString().isNotEmpty|| PendingOrderItemss[i].item_status.toString()!=cancelled){
                                    checkincount= checkincount+1;
                                    if(PendingOrderItemss[i].item_unit.toString()==month){
                                      var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(PendingOrderItemss[i].check_in_time.toString());
                                      var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
                                      var d=DateTimeRange(start: cdate, end: ndate).duration.inDays;
                                      var acalduration= d/30;
                                      print(acalduration);
                                      if(acalduration>double.parse(PendingOrderItemss[i].renting_duration.toString())){
                                        var extrduration= (acalduration-double.parse(PendingOrderItemss[i].renting_duration.toString()));
                                        var charge= extrduration*double.parse(PendingOrderItemss[i].item_price.toString());
                                        nameslist.add(PendingOrderItemss[i].item_name.toString());
                                        rentduration.add(PendingOrderItemss[i].renting_duration.toString());
                                        checkintime.add(PendingOrderItemss[i].check_in_time.toString());
                                        extratime.add((30.0*extrduration).toString());
                                        extracharges.add(charge.toStringAsFixed(0));
                                        ordercharge.add(PendingOrderItemss[i].item_total.toString());
                                        productid.add(PendingOrderItemss[i].item_id.toString());
                                        unitlist.add(day);
                                      }
                                    }
                                    if(PendingOrderItemss[i].item_unit.toString()==day){
                                      var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(PendingOrderItemss[i].check_in_time.toString());
                                      var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
                                      var d=DateTimeRange(
                                          start: cdate,
                                          end: ndate)
                                          .duration
                                          .inHours;
                                      print("durations----- $d");
                                      var acalduration= d/24;
                                      print(d/24);
                                      print(cdate.difference(ndate).inDays);
                                      if(acalduration>double.parse(PendingOrderItemss[i].renting_duration.toString())){
                                        var extrduration= acalduration-double.parse(PendingOrderItemss[i].renting_duration.toString());
                                        var charge= extrduration*double.parse(PendingOrderItemss[i].item_price.toString());
                                        nameslist.add(PendingOrderItemss[i].item_name.toString());
                                        rentduration.add(PendingOrderItemss[i].renting_duration.toString());
                                        checkintime.add(PendingOrderItemss[i].check_in_time.toString());
                                        extratime.add(extrduration.toString());
                                        extracharges.add(charge.toStringAsFixed(0));
                                        ordercharge.add(PendingOrderItemss[i].item_total.toString());
                                        productid.add(PendingOrderItemss[i].item_id.toString());
                                        unitlist.add(hour);
                                      }
                                    }
                                    if(PendingOrderItemss[i].item_unit.toString()==hour){
                                      var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(PendingOrderItemss[i].check_in_time.toString());
                                      var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
                                      var d=DateTimeRange(
                                          start: cdate,
                                          end: ndate)
                                          .duration
                                          .inMinutes;
                                      print("durations----- $d");
                                      var acalduration= d/60;
                                      print(d/60);
                                      print(cdate.difference(ndate).inDays);
                                      if(acalduration>double.parse(PendingOrderItemss[i].renting_duration.toString())){
                                        var extrduration= acalduration-double.parse(PendingOrderItemss[i].renting_duration.toString());
                                        var charge= extrduration*double.parse(PendingOrderItemss[i].item_price.toString());
                                        nameslist.add(PendingOrderItemss[i].item_name.toString());
                                        rentduration.add(PendingOrderItemss[i].renting_duration.toString());
                                        checkintime.add(PendingOrderItemss[i].check_in_time.toString());
                                        extratime.add(extrduration.toString());
                                        extracharges.add(charge.toStringAsFixed(0));
                                        ordercharge.add(PendingOrderItemss[i].item_total.toString());
                                        productid.add(PendingOrderItemss[i].item_id.toString());
                                        unitlist.add(hour);

                                      }
                                    }
                                  }
                                }
                                if(checkincount!=0){if(nameslist.isNotEmpty){
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      var values;
                                      return Container(height: 300,//scrollDirection: Axis.vertical,
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
                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Item name\ncheckin time', style: TextStyle(fontSize: 14.0)))]),
                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Rented duration\n(assigned+extra)', style: TextStyle(fontSize: 14.0)))]),
                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Amount \n(total+ extra)', style: TextStyle(fontSize:14.0)))]),
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
                                                              Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text(nameslist[index]+"\n"+checkintime[index]+"", style: TextStyle(fontSize: 14.0)))]),
                                                              Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text("("+rentduration[index]+"+"+extratime[index]+")"+unitlist[index], style: TextStyle(fontSize: 14.0)))]),
                                                              Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text("₹"+ordercharge[index]+"+₹"+extracharges[index], style: TextStyle(fontSize:14.0)))]),
                                                            ]),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),),
                                              Center(child:Row(children:[
                                                TextButton(  child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                    child:Center(child:Text("Ignore", style:TextStyle(color:Theme.of(context).primaryColor)))),
                                                    onPressed:(){
                                                      openpaymentmodeDialog( context,orderlist[index].order_id.toString(), orderlist[index].total.toString(),
                                                          orderlist[index].Advance_amount.toString(), orderlist[index].pending_amount.toString(),
                                                          orderlist[index].date.toString(), orderlist[index].time.toString(),
                                                          orderlist[index].token_no.toString(), orderlist[index].additional_amount.toString(),
                                                          orderlist[index].discount_amount.toString(),orderlist[index].discount_percent.toString());
                                                    }),
                                                TextButton(
                                                  child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                      child:Center(child:Text("ADD EXTRA", style:TextStyle(color:Colors.white)))),
                                                  onPressed: ()async{
                                                    for(int i=0; i<nameslist.length;i++){
                                                      List<PendingOrderItems> PendingOrderItemss = await Amplify.DataStore.query(PendingOrderItems.classType,
                                                          where:PendingOrderItems.USER_ID.eq(userid).and(PendingOrderItems.ORDER_ID.eq(orderlist[index].order_id.toString())
                                                              .and(PendingOrderItems.ITEM_ID.eq(productid[i])) ));
                                                      if(PendingOrderItemss.isNotEmpty){
                                                        final updatedItem = PendingOrderItemss[0].copyWith(
                                                            user_id: PendingOrderItemss[0].user_id,
                                                            order_id:PendingOrderItemss[0].order_id,
                                                            token_no: PendingOrderItemss[0].token_no,
                                                            item_id: PendingOrderItemss[0].item_id,
                                                            item_name:PendingOrderItemss[0].item_name,
                                                            item_price: PendingOrderItemss[0].item_price,
                                                            item_quantity:PendingOrderItemss[0].item_quantity,
                                                            item_total: (double.parse(PendingOrderItemss[0].item_total.toString())+double.parse(extracharges[i])).toString(),
                                                            item_unit: PendingOrderItemss[0].item_unit,
                                                            check_in_time: PendingOrderItemss[0].check_in_time,
                                                            renting_duration: PendingOrderItemss[0].renting_duration,
                                                            );
                                                        await Amplify.DataStore.save(updatedItem).whenComplete(() => ordertotal=ordertotal+double.parse(extracharges[i]));}
                                                    }
                                                    final updatedItem = orderlist[index].copyWith(
                                                        user_id: orderlist[index].user_id,
                                                        order_id: orderlist[index].order_id,
                                                        total: (double.parse(orderlist[index].total.toString())+ordertotal).toString(),
                                                        token_no: orderlist[index].token_no,
                                                        date: orderlist[index].date,
                                                        time: orderlist[index].time,
                                                        Advance_amount: orderlist[index].Advance_amount,
                                                        pending_amount: (double.parse(orderlist[index].pending_amount.toString())+ordertotal).toString());
                                                    await Amplify.DataStore.save(updatedItem).whenComplete(()async{
                                                      List<PendingOrders> PendingOrderss = await Amplify.DataStore.query(PendingOrders.classType,
                                                          where: PendingOrders.USER_ID.eq(userid).and(PendingOrders.ORDER_ID.eq(orderlist[index].order_id))
                                                              .and(PendingOrders.TOKEN_NO.eq(orderlist[index].token_no)));
                                                      if(PendingOrderss.isNotEmpty){
                                                        await openpaymentmodeDialog( context,PendingOrderss[0].order_id.toString(), PendingOrderss[0].total.toString(),
                                                            PendingOrderss[0].Advance_amount.toString(), PendingOrderss[0].pending_amount.toString(),
                                                            PendingOrderss[0].date.toString(), PendingOrderss[0].time.toString(),
                                                            PendingOrderss[0].token_no.toString(), orderlist[index].additional_amount.toString(),
                                                            orderlist[index].discount_amount.toString(),orderlist[index].discount_percent.toString() );
                                                        Navigator.pop(context);}
                                                    });
                                                  },)]))
                                            ],
                                          ),
                                        // ),
                                      );
                                    },
                                  );}
                                else{
                                  print("nodus");
                                  openpaymentmodeDialog( context,orderlist[index].order_id.toString(), orderlist[index].total.toString(),
                                      orderlist[index].Advance_amount.toString(), orderlist[index].pending_amount.toString(),
                                      orderlist[index].date.toString(), orderlist[index].time.toString(),
                                      orderlist[index].token_no.toString(), orderlist[index].additional_amount.toString(),
                                      orderlist[index].discount_amount.toString(),orderlist[index].discount_percent.toString());
                                }
                                }
                                else{
                                  openpaymentmodeDialog( context,orderlist[index].order_id.toString(), orderlist[index].total.toString(),
                                      orderlist[index].Advance_amount.toString(), orderlist[index].pending_amount.toString(),
                                      orderlist[index].date.toString(), orderlist[index].time.toString(),
                                      orderlist[index].token_no.toString(), orderlist[index].additional_amount.toString(),
                                      orderlist[index].discount_amount.toString(),orderlist[index].discount_percent.toString());
                                }
                              }
                              else{Fluttertoast.showToast(msg: "sorry there are no items in this orderid");}}*/
                            if(direction==DismissDirection.endToStart){
                              opendeletedorderDialog(context, orderlist[index]['order_id'].toString()
                                  , orderlist[index]['total'].toString());
                             }
                          },
                          background: Container(
                            color: Colors.green,
                            child: Align(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Complete",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                          secondaryBackground: Container(
                            child: Center(
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Colors.red,
                          ),
                          child:    Padding(
                            padding: const EdgeInsets.all(10),
                            child:ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title:Row(children: [Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [Text('Token no.',
                                    style:Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: 14),
                                  ),
                                    Text(orderlist[index]['token_no'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(fontSize: 11),
                                    ),],),
                                ],
                              ),]),
                              trailing: Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children:[Text(orderlist[index]['date'].toString(),  style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: 11),),
                                      Text(orderlist[index]['time'].toString(),  style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(fontSize: 11),)]),),

                            ),),
                          key: UniqueKey(),
                          // direction: DismissDirection.endToStart,
                        ),
                        content: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FutureBuilder<List>(
                                future: getorderitemlist(orderlist[index]['order_id']),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(child:Text('Something went wrong'));
                                  }
                                  else if (snapshot.hasData || snapshot.data != null) {
                                    return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (BuildContext context, int indx) {
                                          return Card(
                                            elevation: 4,
                                            child: ListTile(
                                              onLongPress: (){
                                                var checkincount=0;
                                                  print("=============== "+snapshot.data![indx]['renting_duration'].toString()  );
                                                  if (snapshot.data![indx].renting_duration.toString() != "") {
                                                    print("========ijfrtyjn======= "+snapshot.data![indx]['renting_duration'].toString()  );
                                                    var ordertotal = 0.0;
                                                    var nameslist = [],
                                                        unitlist = [],
                                                        rentduration = [],
                                                        ordercharge = [],
                                                        extracharges = [],
                                                        extratime = [],
                                                        checkintime = [],
                                                        productid = [];
                                                      if (snapshot.data![indx]['item_unit']
                                                          .toString() == year) {
                                                        var cdate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                            .parse(snapshot.data![indx]['check_in_time']
                                                            .toString());
                                                        var ndate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                            .parse(
                                                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                                                DateTime.now()));
                                                        var d = DateTimeRange(
                                                            start: cdate, end: ndate).duration
                                                            .inDays;
                                                        var acalduration = d / 365;
                                                        print(acalduration);
                                                        checkincount = checkincount + 1;
                                                        var extrduration = (acalduration -
                                                            double.parse(snapshot.data![indx]
                                                                .renting_duration.toString()));
                                                        var charge = extrduration *
                                                            double.parse(snapshot.data![indx]
                                                                ['item_price'].toString());
                                                        nameslist.add(
                                                            snapshot.data![indx]['item_name']
                                                                .toString());
                                                        rentduration.add(snapshot.data![indx]
                                                            ['renting_duration'].toString());
                                                        checkintime.add(
                                                            snapshot.data![indx]['check_in_time']
                                                                .toString());
                                                        extratime.add(
                                                            (30.0 * extrduration).toString());
                                                        extracharges.add(
                                                            charge.toStringAsFixed(0));
                                                        ordercharge.add(
                                                            snapshot.data![indx]['item_total']
                                                                .toString());
                                                        productid.add(
                                                            snapshot.data![indx]['item_id']
                                                                .toString());
                                                        unitlist.add(year);
                                                        // }
                                                      }
                                                      if (snapshot.data![indx]['item_unit']
                                                          .toString() == month) {
                                                        var cdate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                            .parse(snapshot.data![indx]['check_in_time']
                                                            .toString());
                                                        var ndate = DateFormat("yyyy-MM-dd HH:mm:ss")
                                                            .parse(
                                                            DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                                                DateTime.now()));
                                                        var d = DateTimeRange(
                                                            start: cdate, end: ndate).duration
                                                            .inDays;
                                                        var acalduration = d / 30;
                                                        print(acalduration);
                                                        checkincount = checkincount + 1;

                                                        // if(acalduration>double.parse(orderlist[index].renting_duration.toString())){
                                                        var extrduration = (acalduration -
                                                            double.parse(snapshot.data![indx]
                                                                .renting_duration.toString()));
                                                        var charge = extrduration *
                                                            double.parse(snapshot.data![indx]
                                                                .item_price.toString());
                                                        nameslist.add(
                                                            snapshot.data![indx].item_name
                                                                .toString());
                                                        rentduration.add(snapshot.data![indx]
                                                            .renting_duration.toString());
                                                        checkintime.add(
                                                            snapshot.data![indx].check_in_time
                                                                .toString());
                                                        extratime.add(
                                                            (30.0 * extrduration).toString());
                                                        extracharges.add(charge.toString());
                                                        ordercharge.add(
                                                            snapshot.data![indx].item_total
                                                                .toString());
                                                        productid.add(
                                                            snapshot.data![indx].item_id
                                                                .toString());
                                                        unitlist.add(month);
                                                        // }
                                                      }
                                                      if (snapshot.data![indx].item_unit
                                                          .toString() == day) {
                                                        var cdate = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss").parse(
                                                            snapshot.data![indx].check_in_time
                                                                .toString());
                                                        var ndate = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss").parse(
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
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

                                                        // if(acalduration>double.parse(orderlist[index].renting_duration.toString())){
                                                        var extrduration = acalduration -
                                                            double.parse(snapshot.data![indx]
                                                                .renting_duration.toString());
                                                        var charge = extrduration *
                                                            double.parse(snapshot.data![indx]
                                                                .item_price.toString());
                                                        nameslist.add(
                                                            snapshot.data![indx].item_name
                                                                .toString());
                                                        rentduration.add(snapshot.data![indx]
                                                            .renting_duration.toString());
                                                        checkintime.add(
                                                            snapshot.data![indx].check_in_time
                                                                .toString());
                                                        extratime.add(
                                                            extrduration.toStringAsFixed(2));
                                                        extracharges.add(
                                                            charge.toStringAsFixed(0));
                                                        ordercharge.add(
                                                            snapshot.data![indx].item_total
                                                                .toString());
                                                        productid.add(
                                                            snapshot.data![indx].item_id
                                                                .toString());
                                                        unitlist.add(day);
                                                        // }
                                                      }
                                                      if (snapshot.data![indx].item_unit
                                                          .toString() == hour) {
                                                        var cdate = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss").parse(
                                                            snapshot.data![indx].check_in_time
                                                                .toString() );
                                                        var ndate = DateFormat(
                                                            "yyyy-MM-dd HH:mm:ss").parse(
                                                            DateFormat("yyyy-MM-dd HH:mm:ss")
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
                                                        print(
                                                            "oiuytresdcvbnm,-----------------------------   ${snapshot
                                                                .data![indx].renting_duration
                                                                .toString()}");
                                                        checkincount = checkincount + 1;
                                                        var extrduration = acalduration -
                                                            double.parse(snapshot.data![indx]
                                                                .renting_duration.toString());
                                                        var charge = extrduration *
                                                            double.parse(snapshot.data![indx]
                                                                .item_price.toString());
                                                        nameslist.add(
                                                            snapshot.data![indx].item_name
                                                                .toString());
                                                        rentduration.add(snapshot.data![indx]
                                                            .renting_duration.toString());
                                                        checkintime.add(
                                                            snapshot.data![indx].check_in_time
                                                                .toString());
                                                        extratime.add(
                                                            extrduration.toStringAsFixed(2));
                                                        extracharges.add(
                                                            charge.toStringAsFixed(0));
                                                        ordercharge.add(
                                                            snapshot.data![indx].item_total
                                                                .toString());
                                                        productid.add(
                                                            snapshot.data![indx].item_id
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
                                                                                var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitem', {'id':snapshot.data![indx]['id']});
                                                                                var response = await http.get(url);
                                                                                if(response.body.isNotEmpty){
                                                                                var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                                                                                var respnse = await http.post(url,
                                                                                  headers: <String, String>{
                                                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                                                  },
                                                                                  body: jsonEncode(<String, String>{
                                                                                    "id":jsonResponse['id'],
                                                                                    "user_id": jsonResponse['user_id'],
                                                                                    "order_id": jsonResponse['order_id'],
                                                                                    "token_no": jsonResponse['token_no'],
                                                                                    "item_id": jsonResponse['item_id'].toString(),
                                                                                    "item_name": jsonResponse['item_name'].toString(),
                                                                                    "item_quantity": jsonResponse['item_quantity']
                                                                                        .toString(),
                                                                                    "item_price": jsonResponse['item_price_per_unit']
                                                                                        .toString(),
                                                                                    "item_total": jsonResponse['item_total'].toString(),
                                                                                    "item_unit": jsonResponse['item_unit'].toString(),
                                                                                    "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                                                                        DateTime.now()),
                                                                                    "renting_duration": jsonResponse['rented_duration']
                                                                                        .toString(),
                                                                                    "Check_out_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                                                                    "item_status": checkedout}),);
                                                                                if(respnse.statusCode==200){
                                                                                  var url = Uri.https(rentedapi, 'RentedItem/renteditem',
                                                                                      {"id": snapshot.data![indx]['item_id']});
                                                                                  var response = await http.get(url);
                                                                                  if (response.body.isNotEmpty) {
                                                                                    var tagObjsJson = jsonDecode(response.body) as Map<
                                                                                        String,
                                                                                        dynamic>;
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
                                                                                          "product_engagement": "",
                                                                                          "rented_duration": tagObjsJson['rented_duration'],
                                                                                          "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                                                                                        }),);
                                                                                      if (reonse.statusCode == 200) {
                                                                                      await FirebaseAnalytics.instance.logEvent(
                                                                                        name: "item_checkout",
                                                                                      );
                                                                                    }
                                                                                  }
                                                                                }
                                                                                }
                                                                                setdocument();
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
                                                                                        "ADD EXTRA & CHECKOUT",
                                                                                        style: TextStyle(
                                                                                            color: Colors
                                                                                                .white)))),
                                                                            onPressed: () async {
                                                                              for (int i = 0; i < nameslist.length; i++) {
                                                                                var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitem', {'id':snapshot.data![indx]['id']});
                                                                                var response = await http.get(url);
                                                                                if(response.body.isNotEmpty){
                                                                                  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                                                                                  var respnse = await http.post(url,
                                                                                    headers: <String, String>{
                                                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                                                    },
                                                                                    body: jsonEncode(<String, String>{
                                                                                      "id":jsonResponse['id'],
                                                                                      "user_id": jsonResponse['user_id'],
                                                                                      "order_id": jsonResponse['order_id'],
                                                                                      "token_no": jsonResponse['token_no'],
                                                                                      "item_id": jsonResponse['item_id'].toString(),
                                                                                      "item_name": jsonResponse['item_name'].toString(),
                                                                                      "item_quantity": jsonResponse['item_quantity']
                                                                                          .toString(),
                                                                                      "item_price": jsonResponse['item_price_per_unit']
                                                                                          .toString(),
                                                                                      "item_total":(double.parse(jsonResponse['item_total'].toString())
                                                                                          + double.parse(extracharges[i])).toString(),
                                                                                      "item_unit": jsonResponse['item_unit'].toString(),
                                                                                      "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                                                                      "renting_duration":(double.parse( jsonResponse['rented_duration'].toString())+ double.parse(extratime[0] )).toString(),
                                                                                      "Check_out_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                                                                                      "item_status": checkedout}),);
                                                                                  if(respnse.statusCode==200){
                                                                                    var ppurl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder', {'id':userid+ jsonResponse['order_id']});
                                                                                    var response = await http.get(ppurl);
                                                                                    if (response.body.isNotEmpty) {
                                                                                      var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                                                                                      var respo = await http.post(ppurl,
                                                                                      headers: <String, String>{
                                                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                                                      },
                                                                                      body: jsonEncode(<String, String>{
                                                                                        "id":tagObjsJson['id'],
                                                                                        "user_id": tagObjsJson['user_id'],
                                                                                        'order_id': tagObjsJson['order_id'],
                                                                                        'token_no': tagObjsJson['token_no'],
                                                                                        'total': (double.parse(tagObjsJson['total'].toString()) + double.parse(extracharges[i])).toString(),
                                                                                      'discount_amount': tagObjsJson['discount_amount'],
                                                                                        'discount_percent': tagObjsJson['discount_percent'],
                                                                                        'additional_amount': tagObjsJson['additional_amount'],
                                                                                        'date': tagObjsJson['date'],
                                                                                        'time':tagObjsJson['time'],
                                                                                        'Advance_amount': tagObjsJson['Advance_amount'],
                                                                                        'pending_amount': (double.parse(tagObjsJson['pending_amount'].toString()) + double.parse(extracharges[i])).toString()}),);}
                                                                                    var url = Uri.https(rentedapi, 'RentedItem/renteditem', {"id": snapshot.data![indx]['item_id']});
                                                                                    var respon = await http.get(url);
                                                                                    if (respon.body.isNotEmpty) {
                                                                                      var tagObjsJson = jsonDecode(respon.body) as Map<String, dynamic>;
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
                                                                                          "product_engagement": "",
                                                                                          "rented_duration": tagObjsJson['rented_duration'],
                                                                                          "rentout_to_client_id": tagObjsJson['rentout_to_client_id']
                                                                                        }),);
                                                                                      if (reonse.statusCode == 200) {
                                                                                        await FirebaseAnalytics.instance.logEvent(
                                                                                          name: "item_checkout",
                                                                                        );
                                                                                      }
                                                                                    }
                                                                                  }
                                                                                }
                                                                                setdocument();
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
                                              },
                                              title: Row(children: [Container(width: 120,child:
                                              Text( "🛒"+snapshot.data![indx]['item_name'].toString()),),
                                                Text("₹"+snapshot.data![indx]['item_total'].toString()),
                                              ],),
                                              subtitle:Row(children: [Container(width: 120,child:
                                              Text("₹"+snapshot.data![indx]['item_price'].toString()+"/"+
                                                  snapshot.data![indx]['item_unit'].toString())),
                                                Text(snapshot.data![indx]['item_quantity'].toString()!=""?"Qty: "+
                                                    snapshot.data![indx]['item_quantity'].toString():"🕝 "+
                                                    snapshot.data![indx]['renting_duration'].toString()),]),
                                              trailing:snapshot.data![indx]['item_quantity'].toString()!=cancelled?
                                              IconButton(icon:Icon(Icons.delete), onPressed:() async {
                                                var url= Uri.https(rentedapi, 'RentedItem/renteditem',
                                                  {'id':snapshot.data![indx]['item_id']}, );
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
                                                    var murl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder',
                                                        {"id":snapshot.data![indx]['order_id']});
                                                    var response = await http.post(murl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(<String, String>{
                                                        "id":orderlist[index]['id'],
                                                        "user_id":orderlist[index]['user_id'],
                                                        "order_id": orderlist[index]['order_id'],
                                                        "token_no": orderlist[index]['token_no'],
                                                        "total": (double.parse(orderlist[index]['total'].toString())-double.parse(snapshot.data![indx]['item_total'])).toString(),
                                                        "additional_amount": orderlist[index]['additional_amount'],
                                                        "discount_percent" : (double.parse(orderlist[index]['discount_percent'].toString())).toString(),
                                                        "discount_amount"  : (double.parse(orderlist[index]['discount_amount'].toString())).toString(),
                                                        "Advance_amount": orderlist[index]['Advance_amount'].toString(),
                                                        "pending_amount":(double.parse( orderlist[index]['pending_amount'].toString())-double.parse(snapshot.data![indx]['item_total'])).toString()  ,
                                                        "date": orderlist[index]['date'],
                                                        "time": orderlist[index]['time']}),);
                                                    var turl= Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem',{
                                                      "id": snapshot.data![indx]['id'],});
                                                    var resse = await http.delete(turl,   headers: <String, String>{
                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                    },
                                                        body: jsonEncode(<String, String>{
                                                          "id": snapshot.data![indx]['id']
                                                        }));
                                                    if(resse.statusCode==200){
                                                      setdocument();
                                                      print("temp deleted  ${resse.statusCode}");
                                                    }
                                                  }
                                                }
                                                else{
                                                    addstock(snapshot.data![indx]['item_id'], snapshot.data![indx]['item_quantity']);
                                                    var murl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder',
                                                        {"id":snapshot.data![indx]['order_id']});
                                                    var response = await http.post(murl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(<String, String>{
                                                        "id":orderlist[index]['id'],
                                                        "user_id":orderlist[index]['user_id'],
                                                        "order_id": orderlist[index]['order_id'],
                                                        "token_no": orderlist[index]['token_no'],
                                                        "total": (double.parse(orderlist[index]['total'].toString())-double.parse(snapshot.data![indx]['item_total'])).toString(),
                                                        "additional_amount": orderlist[index]['additional_amount'],
                                                        "discount_percent" : (double.parse(orderlist[index]['discount_percent'].toString())).toString(),
                                                        "discount_amount"  : (double.parse(orderlist[index]['discount_amount'].toString())).toString(),
                                                        "Advance_amount": orderlist[index]['Advance_amount'].toString(),
                                                        "pending_amount":(double.parse( orderlist[index]['pending_amount'].toString())-double.parse(snapshot.data![indx]['item_total'])).toString()  ,
                                                        "date": orderlist[index]['date'],
                                                        "time": orderlist[index]['time']}),);
                                                    var turl= Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem',{
                                                      "id": snapshot.data![indx]['id'],});
                                                    var resse = await http.delete(turl,   headers: <String, String>{
                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                    },
                                                        body: jsonEncode(<String, String>{
                                                          "id": snapshot.data![indx]['id']
                                                        }));
                                                    if(resse.statusCode==200){
                                                      setdocument();
                                                    }
                                                }
                                              }):Container()
                                            ),
                                          );
                                        });
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue,
                                      ),
                                    ),
                                  );
                                },
                              ),  const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                              ),
                              ExpansionTile(leading:Icon(Icons.add),title:Text("Add"), trailing: Icon(Icons.arrow_drop_down),
                              children:[  const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                              ),ButtonBar(

                                buttonMinWidth: 30.0,
                                children: [
                                  TextButton(
                                      child:Container( width:160,
                                          padding:EdgeInsets.all(2),
                                          child:Row(children:[Icon(Icons.add),Text("UPDATE ADVANCE")])), onPressed:()async{
                                    await FirebaseAnalytics.instance.logEvent(
                                      name: "update_order_advance",
                                    );
                                    var values;
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  <Widget>[
                                                SizedBox(height:15),
                                                TextField(
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value){
                                                    values= value.trim();},
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.currency_rupee),
                                                    labelText: 'Enter your amount',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height:15),
                                                TextButton(child:Container(height:40,width:150
                                                    ,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                    child:Center(child:Text("ADD", style:TextStyle(color:Colors.white)))), onPressed: ()async{
                                                  if(values.isEmpty || values.startsWith("0",0)){
                                                    Fluttertoast.showToast(msg:"Amount cannot be empty or starts with 0.");
                                                  }
                                                  else{
                                                    var murl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder',
                                                        {"id": orderlist[index]['id']});
                                                    var response = await http.post(murl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(<String, String>{
                                                        "id":orderlist[index]['id'],
                                                      "user_id":orderlist[index]['user_id'],
                                                      "order_id": orderlist[index]['order_id'],
                                                      "token_no": orderlist[index]['token_no'],
                                                      "total": orderlist[index]['total'],
                                                      "additional_amount": orderlist[index]['additional_amount'],
                                                      "discount_percent" : orderlist[index]['discount_percent'],
                                                      "discount_amount"  : orderlist[index]['discount_amount'],
                                                      "Advance_amount": (double.parse(orderlist[index]['Advance_amount'].toString())+double.parse(values)).toString(),
                                                      "pending_amount":(double.parse( orderlist[index]['pending_amount'].toString())-double.parse(values)).toString()  ,
                                                      "date": orderlist[index]['date'],
                                                      "time": orderlist[index]['time']}),);
                                                    if(response.statusCode==200){
                                                      var murl = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord',);
                                                      var response = await http.post(murl,
                                                        headers: <String, String>{
                                                          'Content-Type': 'application/json; charset=UTF-8',
                                                        },
                                                        body: jsonEncode(<String, String>{
                                                          "id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                                          "user_id": orderlist[index]['user_id'],
                                                          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                                          "token_no": orderlist[index]['token_no'],
                                                          "order_id": orderlist[index]['order_id'],
                                                          "client_id": orderlist[index]['id'],
                                                          "received_amount": values,
                                                          "sent_amount": "0",
                                                          "description": "Payment of orderid- ${orderlist[index]['order_id'].toString()} \n Token no - ${orderlist[index]['token_no'].toString()}",
                                                          "payment_mod":"" ,
                                                          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                                                          "time":DateFormat("HH:mm:ss").format(DateTime.now())}),);
                                                      if(response.statusCode==200){
                                                        await doesProfitAlreadyExist(values, paid);setdocument();
                                                      }
                                                    }
                                                  Navigator.pop(context);
                                                  }
                                                },)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                  TextButton(
                                      child:Container(
                                          width:190,
                                          padding:EdgeInsets.all(3),
                                          child:Row(children:[Icon(Icons.add),
                                            Text("ADDITIONAL AMOUNT")])), onPressed:()async{
                                    await FirebaseAnalytics.instance.logEvent(
                                      name: "add_order_additional_amount",
                                    );
                                    var values;
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  <Widget>[
                                                SizedBox(height:15),
                                                TextField(
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value){
                                                    values= value.trim();},
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.currency_rupee),
                                                    labelText: 'Enter amount',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height:15),
                                                TextButton(child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                    child:Center(child:Text("ADD", style:TextStyle(color:Colors.white)))), onPressed: ()async{
                                                  if(values.isEmpty || values.startsWith("0",0)){
                                                    Fluttertoast.showToast(msg:"Amount cannot be empty or starts with 0.");
                                                  }
                                                  else{
                                                    var murl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder',
                                                        {"id": orderlist[index]['id']});
                                                    var response = await http.post(murl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(<String, String>{
                                                        "id":orderlist[index]['id'],
                                                        "user_id":orderlist[index]['user_id'],
                                                        "order_id": orderlist[index]['order_id'],
                                                        "token_no": orderlist[index]['token_no'],
                                                        "total": (double.parse(orderlist[index]['total'].toString())+double.parse(values)).toString(),
                                                        "additional_amount": (double.parse(orderlist[index]['additional_amount'].toString())+double.parse(values)).toString(),
                                                        "discount_percent" : orderlist[index]['discount_percent'],
                                                        "discount_amount"  : orderlist[index]['discount_amount'],
                                                        "Advance_amount": orderlist[index]['Advance_amount'].toString(),
                                                        "pending_amount":(double.parse( orderlist[index]['pending_amount'].toString())+double.parse(values)).toString()  ,
                                                        "date": orderlist[index]['date'],
                                                        "time": orderlist[index]['time']}),);
                                                    if(response.statusCode==200){setdocument();
                                                     print("additional success");
                                                    }else{
                                                      Fluttertoast.showToast(msg:"Something went wrong! please try again.");
                                                    }
                                                    Navigator.of(context, rootNavigator: true).pop(context);
                                                  }
                                                },)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                  TextButton(
                                      child:Container(
                                          padding:EdgeInsets.all(3),
                                          width:120,
                                          child:Row(children:[Icon(Icons.add),Text("DISCOUNT")])), onPressed:()async{
                                    await FirebaseAnalytics.instance.logEvent(
                                      name: "add_order_discount",
                                    );
                                    var values;
                                    var inx=0;
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children:  <Widget>[
                                                TabBar(
                                                    onTap:(index){
                                                      setState((){inx= index;});
                                                    },
                                                    controller:TabController(vsync: this, length: 2),
                                                    labelColor:Theme.of(context).primaryColor,
                                                    indicatorColor: Theme.of(context).primaryColor,
                                                    tabs:[ Tab(child:Container(
                                                        padding:EdgeInsets.all(8),
                                                        decoration:BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                            border:Border.all(width:2, color:Colors.grey)
                                                        ),
                                                        child:Text("% Percent", ))),
                                                      Tab(child:Container(
                                                          padding:EdgeInsets.all(8),
                                                          decoration:BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                              border:Border.all(width:1, color:Colors.grey)
                                                          ),
                                                          child:Text(" Amount",)))]),
                                                SizedBox(height:15),
                                                TextField(
                                                  keyboardType: TextInputType.number,
                                                  onChanged: (value){
                                                    values= value.trim();},
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(Icons.currency_rupee),
                                                    labelText: 'Enter amount',
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.all(Radius.circular(40)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height:15),
                                                TextButton(child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                    child:Center(child:Text("ADD", style:TextStyle(color:Colors.white)))), onPressed: ()async{
                                                  if(values.isEmpty || values.startsWith("0",0)){
                                                    Fluttertoast.showToast(msg:"Amount cannot be empty or starts with 0.");
                                                  }
                                                  else{
                                                    var val="0.0", perval="0.0";
                                                    var discount;
                                                    if(inx==0){
                                                      discount= (double.parse(orderlist[index]['total'].toString())*double.parse(values))/100;
                                                      setState((){perval= values;
                                                      val= ((double.parse(orderlist[index]['total'].toString())*double.parse(values))/100).toString();}); }
                                                    else{setState((){discount= double.parse(values);
                                                    perval = (double.parse(values)/100).toString();
                                                    val= (double.parse(values)).toString();});}
                                                    var murl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder',
                                                        {"id": orderlist[index]['id']});
                                                    var response = await http.post(murl,
                                                      headers: <String, String>{
                                                        'Content-Type': 'application/json; charset=UTF-8',
                                                      },
                                                      body: jsonEncode(<String, String>{
                                                        "id":orderlist[index]['id'],
                                                        "user_id":orderlist[index]['user_id'],
                                                        "order_id": orderlist[index]['order_id'],
                                                        "token_no": orderlist[index]['token_no'],
                                                        "total": (double.parse(orderlist[index]['total'].toString())-double.parse(val)).toString(),
                                                        "additional_amount": orderlist[index]['additional_amount'],
                                                        "discount_percent" : (double.parse(orderlist[index]['discount_percent'].toString())+double.parse(perval)).toString(),
                                                        "discount_amount"  : (double.parse(orderlist[index]['discount_amount'].toString())+double.parse(val)).toString(),
                                                        "Advance_amount": orderlist[index]['Advance_amount'].toString(),
                                                        "pending_amount":(double.parse( orderlist[index]['pending_amount'].toString())-double.parse(val)).toString()  ,
                                                        "date": orderlist[index]['date'],
                                                        "time": orderlist[index]['time']}),);
                                                    if(response.statusCode==200){setdocument();
                                                    var iturl = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitems');
                                                    var response = await http.get(iturl);
                                                    if(response.body.isNotEmpty) {
                                                      var tagObjsJson = jsonDecode(response.body)['products'] as List;
                                                      for (int i = 0; i < tagObjsJson.length; i++) {
                                                        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                                                        if (jnResponse['user_id'] == userid &&
                                                            jnResponse['order_id'] == orderlist[index]['order_id']) {
                                                          var pendurl = Uri.https(
                                                              pendingorderitemapi, 'Pendingitems/pendingitem', {'id':jnResponse['id']});
                                                          var response = await http.post(pendurl,
                                                            headers: <String, String>{
                                                              'Content-Type': 'application/json; charset=UTF-8',
                                                            },
                                                            body: jsonEncode(<String, String>{
                                                              "id": jnResponse['id'],
                                                              "user_id": jnResponse['user_id'],
                                                              "order_id": jnResponse['order_id'],
                                                              "token_no": jnResponse['token_no'],
                                                              "item_id": jnResponse['item_id'],
                                                              "item_name": jnResponse['item_name'].toString(),
                                                              "item_quantity": jnResponse['item_quantity']
                                                                  .toString(),
                                                              "item_price": jnResponse['item_price']
                                                                  .toString(),
                                                              "item_total":(double.parse( jnResponse['item_total'].toString())
                                                                  -(double.parse(jnResponse['item_total'].toString())*double.parse(perval)/100)).toStringAsPrecision(2),
                                                              "item_unit": jnResponse['item_unit'].toString(),
                                                              "check_in_time":jnResponse['check_in_time'],
                                                              "renting_duration": jnResponse['renting_duration']
                                                                  .toString(),
                                                              "Check_out_time": jnResponse['Check_out_time'],
                                                              "item_status": jnResponse['item_status']}),);
                                                        }
                                                      }
                                                    }
                                                    print("Discount success");
                                                    }else{
                                                      Fluttertoast.showToast(msg:"Something went wrong! please try again.");
                                                    }
                                                  }      Navigator.of(context, rootNavigator: true).pop(context);
                                                },)
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),]),
                              const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                              ),

                              Container(color:Colors.grey.withOpacity(.5),
                                padding: EdgeInsets.only(left:8, right:8),
                                child:ListTile(leading:Text("Advance ₹${orderlist[index]['Advance_amount'].toString()}", style: TextStyle(fontSize: 15),),
                                  trailing: Text("Pending ₹${orderlist[index]['pending_amount'].toString()}", style: TextStyle(fontSize: 15),),),
                              ),
                              const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                              ),
                              Container(width: double.maxFinite,
                                color:Colors.grey.withOpacity(.5),
                                child:Table(
                                    defaultColumnWidth: IntrinsicColumnWidth(),
                                    children: [
                                    TableRow(children:[Column(children: [ Container(width:150,margin: EdgeInsets.only( top: 6, ),
                                    child:Text("Additional Charges ", style: TextStyle(fontSize:16),)),
                                  Container(width:150,margin: EdgeInsets.only(left: 20, top: 6, right: 20),
                                    child:Text("Discount amount ", style: TextStyle(fontSize: 16),)),
                                  Container(width:150,margin: EdgeInsets.only(left: 20, top: 6, bottom: 6, right: 20),
                                      child:Text("Total ", style: TextStyle(fontSize: 16),)),
                                ],),Column(children: [ Container(margin: EdgeInsets.only(left: 20, top: 6, right: 20),
                                        child:Text(" ₹${orderlist[index]['additional_amount'].toString()}", style: TextStyle(fontSize:16),)),
                                      Container(margin: EdgeInsets.only(left: 20, top: 6, right: 20),
                                          child:Text(" ₹${orderlist[index]['discount_amount'].toString()} (${orderlist[index]['discount_percent'].toString()}%)", style: TextStyle(fontSize: 16),)),
                                      Container(margin: EdgeInsets.only(left: 20, top: 6, bottom: 6, right: 20),
                                          child:Text(" ₹${orderlist[index]['total'].toString()}", style: TextStyle(fontSize: 16),)),
                                    ],)
                                    ])]),
                             ),
                              const Divider(
                                color: Colors.white,
                                height: 2,
                                thickness: 2,
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceAround,
                                buttonHeight: 32.0,
                                buttonMinWidth: 30.0,
                                // buttonMaxWidth: 50.0,
                                children: [
                                  TextButton(
                                    onPressed: () async{
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "add_more_item_to_order",
                                      );
                                      CheckUserConnection();
                                      List<String> itemchildid= <String>[];
                                      List<String> itemchildlist= <String>[];
                                      List<String> itemchildpricelist= <String>[];
                                      showDialog(
                                          context: context,
                                          builder:(BuildContext context){
                                            return  StatefulBuilder(builder:  (BuildContext context, setState)
                                            {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                                title: const Text("Select"),
                                                content: Container(
                                                  height: 200,
                                                  padding: EdgeInsets.all(10),
                                                  child:SingleChildScrollView(child: Row(
                                                    children: [
                                                      TextButton(onPressed:()async{await openrentaldialog(context, orderlist[index]['order_id'].toString(), orderlist[index]['token_no'].toString(),orderlist[index]['id'].toString(),);},child:Column(children:[Icon(Icons.add_shopping_cart), Text("RENTALS/SERVICES")])),
                                                      TextButton(onPressed:()async{await  openitemsdialog(context, orderlist[index]['order_id'].toString(), orderlist[index]['token_no'].toString(),orderlist[index]['id'].toString(),);},child:Column(children:[Icon(Icons.add), Text("ADD ITEMS")]))
                                                    ],
                                                  )),
                                                ),
                                              );
                                            });
                                          });
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.add,color: Colors.blue,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Text('Add items',style: TextStyle(color: Colors.blue),),
                                      ],
                                    ),),
                                  TextButton(
                                    onPressed:() async {
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "complete_order",
                                      );
                                      var checkincount=0;
                                      var ordertotal=0.0;

                                      var nameslist=[],unitlist=[], rentduration=[], ordercharge=[], extracharges=[],
                                          extratime=[], checkintime=[], productid=[];
                                      var dt= DateTime.now().add(Duration(days: 3));
                                      if(double.parse(orderlist[index]['total'].toString())>0){
                                        var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitems');
                                        var response = await http.get(url);
                                       // var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
                                        var tagObjsJson = jsonDecode(response.body)['products'] as List;
                                        for(int i=0; i<tagObjsJson.length; i++) {
                                          var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                                          if (jnResponse['user_id'] == userid && jnResponse['order_id'] ==orderlist[index]['order_id'])
                                          {
                                            if(jnResponse['renting_duration'].toString()!=""||
                                                jnResponse['item_status'].toString()!=cancelled
                                                || jnResponse['item_status'].toString()!=checkedout ){
                                              checkincount= checkincount+1;
                                              if(jnResponse['item_unit'].toString()==year){
                                                var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(jnResponse['check_in_time'].toString());
                                                var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").
                                                format(DateTime.now()));
                                                var d=DateTimeRange(
                                                    start: cdate,
                                                    end: ndate)
                                                    .duration
                                                    .inDays;
                                                print("durations----- $d");
                                                var acalduration= d/365;
                                                print(d/24);
                                                print(cdate.difference(ndate).inDays);
                                                if(acalduration>double.parse(jnResponse['renting_duration'].toString())){
                                                  var extrduration= acalduration-double.parse(jnResponse['renting_duration'].toString());
                                                  var charge= extrduration*double.parse(jnResponse['item_price'].toString());
                                                  nameslist.add(jnResponse['item_name'].toString());
                                                  rentduration.add(jnResponse['renting_duration'].toString());
                                                  checkintime.add(jnResponse['check_in_time'].toString());
                                                  extratime.add(extrduration.toString());
                                                  extracharges.add(charge.toStringAsFixed(0));
                                                  ordercharge.add(jnResponse['item_total'].toString());
                                                  productid.add(jnResponse['id'].toString());
                                                  unitlist.add(day);
                                                }
                                              }
                                              if(jnResponse['item_unit'].toString()==month){
                                                var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(jnResponse['check_in_time'].toString());
                                                var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
                                                var d=DateTimeRange(start: cdate, end:ndate).duration.inDays;
                                                var acalduration= d/30;
                                                print(acalduration);
                                                if(acalduration>double.parse(jnResponse['renting_duration'].toString())){
                                                  var extrduration= (acalduration-double.parse(jnResponse['renting_duration'].toString()));
                                                  var charge= extrduration*double.parse(jnResponse['item_price'].toString());
                                                  nameslist.add(jnResponse['item_name'].toString());
                                                  rentduration.add(jnResponse['renting_duration'].toString());
                                                  checkintime.add(jnResponse['check_in_time'].toString());
                                                  extratime.add((30.0*extrduration).toString());
                                                  extracharges.add(charge.toStringAsFixed(0));
                                                  ordercharge.add(jnResponse['item_total'].toString());
                                                  productid.add(jnResponse['id'].toString());
                                                  unitlist.add(month);
                                                }
                                              }
                                              if(jnResponse['item_unit'].toString()==day){
                                                var cdate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(jnResponse['check_in_time'].toString());
                                                var ndate= DateFormat("yyyy-MM-dd HH:mm:ss").parse(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
                                                var d=DateTimeRange(
                                                    start: cdate,
                                                    end: ndate)
                                                    .duration
                                                    .inHours;
                                                print("durations----- $d");
                                                var acalduration= d/24;
                                                print(d/24);
                                                print(cdate.difference(ndate).inDays);
                                                if(acalduration>double.parse(jnResponse['renting_duration'].toString())){
                                                  var extrduration= acalduration-double.parse(jnResponse['renting_duration'].toString());
                                                  var charge= extrduration*double.parse(jnResponse['item_price'].toString());
                                                  nameslist.add(jnResponse['item_name'].toString());
                                                  rentduration.add(jnResponse['renting_duration'].toString());
                                                  checkintime.add(jnResponse['check_in_time'].toString());
                                                  extratime.add(extrduration.toString());
                                                  extracharges.add(charge.toStringAsFixed(0));
                                                  ordercharge.add(jnResponse['item_total'].toString());
                                                  productid.add(jnResponse['id'].toString());
                                                  unitlist.add(day);
                                                }
                                              }
                                              if(jnResponse['item_unit'].toString()==hour){
                                                var cdate= DateFormat("yyyy-MM-dd-HH:mm:ss").parse(jnResponse['check_in_time'].toString());
                                                var ndate= DateFormat("yyyy-MM-dd-HH:mm:ss").parse(DateFormat("yyyy-MM-dd-HH:mm:ss").format(DateTime.now()));
                                                var d=DateTimeRange(
                                                    start: cdate,
                                                    end: ndate)
                                                    .duration
                                                    .inMinutes;
                                                print("durations----- $d");
                                                var acalduration= d/60;
                                                print(d/60);
                                                print(cdate.difference(ndate).inDays);
                                                if(acalduration>double.parse(jnResponse['renting_duration'].toString())){
                                                  var extrduration= acalduration-double.parse(jnResponse['renting_duration'].toString());
                                                  var charge= extrduration*double.parse(jnResponse['item_price'].toString());
                                                  nameslist.add(jnResponse['item_name'].toString());
                                                  rentduration.add(jnResponse['renting_duration'].toString());
                                                  checkintime.add(jnResponse['check_in_time'].toString());extratime.add(extrduration.toString());
                                                  extracharges.add(charge.toStringAsFixed(0));
                                                  ordercharge.add(jnResponse['item_total'].toString());
                                                  productid.add(jnResponse['id'].toString());
                                                  unitlist.add(hour);
                                                }
                                              }
                                            }
                                          }
                                        }

                                      if(checkincount!=0){if(nameslist.isNotEmpty){
                                          showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  var values;
                                                  return  Container(height:300,//scrollDirection: Axis.vertical,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:  <Widget>[
                                                          ListTile(
                                                                title: Table(
                                                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                                                  children: [
                                                                    TableRow(
                                                                        children: [
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Item name\ncheckin time', style: TextStyle(fontSize: 14.0)))]),
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Rented duration\n(assigned+extra)', style: TextStyle(fontSize: 14.0)))]),
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, ),padding: EdgeInsets.only(top:4, bottom:4),width: 110,child:Text('Amount \n(total+ extra)', style: TextStyle(fontSize:14.0)))]),
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
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text(nameslist[index]+"\n"+checkintime[index]+"", style: TextStyle(fontSize: 14.0)))]),
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text("("+rentduration[index]+"+"+extratime[index]+")"+unitlist[index], style: TextStyle(fontSize: 14.0)))]),
                                                                          Column(children:[Container(margin:EdgeInsets.only( right: 5, top: 4, ),padding: EdgeInsets.only(top:4, bottom:4),width:110,child:Text("₹"+ordercharge[index]+"+₹"+extracharges[index], style: TextStyle(fontSize:14.0)))]),
                                                                         ]),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),),
                                                         Center(child:Row(children:[
                                                           TextButton(  child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                              child:Center(child:Text("Ignore", style:TextStyle(color:Colors.white)))),
                                                               onPressed:(){
                                                                 openpaymentmodeDialog( context,orderlist[index]['order_id'].toString(),
                                                                     orderlist[index]['total'].toString(),
                                                                     orderlist[index]['Advance_amount'].toString(), orderlist[index]['pending_amount'].toString(),
                                                                     orderlist[index]['date'].toString(), orderlist[index]['time'].toString(),
                                                                     orderlist[index]['token_no'].toString(), orderlist[index]['additional_amount'].toString(),
                                                                     orderlist[index]['discount_amount'].toString(),orderlist[index]['discount_percent'].toString());
                                                               }),
                                                           TextButton(
                                                           child:Container(height:40,width:150,decoration:BoxDecoration(borderRadius: BorderRadius.circular(15), color:Colors.blue),
                                                               child:Center(child:Text("ADD EXTRA", style:TextStyle(color:Colors.white)))),
                                                           onPressed: ()async{
                                                             for(int i=0; i<nameslist.length;i++){
                                                               var url = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem',
                                                                {"id": productid[i]});
                                                               var response = await http.get(url);
                                                               print('Response status: ${response.statusCode}');
                                                               print("oiuhg--------  ${response.body}");
                                                               var jsonResponse =
                                                               convert.jsonDecode(response.body) as Map<String, dynamic>;
                                                               var resnse = await http.post(
                                                                   url,
                                                                   headers: <String, String>{
                                                                     'Content-Type': 'application/json; charset=UTF-8',
                                                                   },
                                                                   body: jsonEncode(<String, String>{
                                                                     "id":jsonResponse["id"],
                                                                     "user_id": jsonResponse['user_id'],
                                                                     "order_id": jsonResponse["order_id"],
                                                                     "token_no": jsonResponse["token_no"],
                                                                     "item_id": jsonResponse['item_id'],
                                                                     "item_name":jsonResponse['item_name'],
                                                                     "item_price": jsonResponse['item_price'],
                                                                     "item_quantity":jsonResponse['item_quantity'],
                                                                     "item_total": (double.parse(jsonResponse['item_total'].toString())+double.parse(extracharges[i])).toString(),
                                                                     "item_unit": jsonResponse['item_unit'],
                                                                     "check_in_time": jsonResponse['check_in_time'],
                                                                     "renting_duration": (double.parse(jsonResponse['renting_duration'].toString())+double.parse(extratime[i])).toString(),
                                                                   }));
                                                               if(resnse.statusCode==200){
                                                                 ordertotal=ordertotal+double.parse(extracharges[i]);

                                                               }
                                                             }
                                                             var pourl = Uri.https(pendingorderapi, 'Pendingorder/pendingorders',
                                                                 {"id": orderlist[index]['id']});
                                                             var resnse = await http.post(
                                                                 pourl,
                                                                 headers: <String, String>{
                                                                   'Content-Type': 'application/json; charset=UTF-8',
                                                                 },
                                                                 body: jsonEncode(<String, String>{
                                                                   "id":orderlist[index]['id'],
                                                                 "user_id": orderlist[index]['user_id'],
                                                                 "order_id": orderlist[index]['order_id'],
                                                                 "token_no": orderlist[index]['token_no'],
                                                                 "total":  (double.parse(orderlist[index]['total'].toString())+ordertotal).toString(),
                                                                 "additional_amount":orderlist[index]['Advance_amount'],
                                                                 "discount_percent": orderlist[index]['discount_percent'],
                                                                 "discount_amount":orderlist[index]['discount_amount'],
                                                                 "date": orderlist[index]['date'],
                                                                 "time": orderlist[index]['time'],
                                                                 "Advance_amount": orderlist[index]['Advance_amount'],
                                                                 "pending_amount": (double.parse(orderlist[index]['pending_amount'].toString())+ordertotal).toString()}));
                                                             if(resnse.statusCode==200){
                                                               await setdocument();
                                                               await openpaymentmodeDialog( context,orderlist[index]['order_id'].toString(), orderlist[index]['total'].toString(),
                                                                   orderlist[index]['Advance_amount'].toString(), orderlist[index]['pending_amount'].toString(),
                                                                   orderlist[index]['date'].toString(), orderlist[index]['time'].toString(),
                                                                   orderlist[index]['token_no'].toString(), orderlist[index]['additional_amount'].toString(),
                                                                   orderlist[index]['discount_amount'].toString(),orderlist[index]['discount_percent'].toString() );
                                                               Navigator.pop( context);
                                                             }
                                                         },)]))
                                                        ],

                                                  ));
                                                },
                                              );}
                                      else{
                                        print("nodus");
                                        openpaymentmodeDialog( context,orderlist[index]['order_id'].toString(), orderlist[index]['total'].toString(),
                                            orderlist[index]['Advance_amount'].toString(), orderlist[index]['pending_amount'].toString(),
                                            orderlist[index]['date'].toString(), orderlist[index]['time'].toString(),
                                            orderlist[index]['token_no'].toString(), orderlist[index]['additional_amount'].toString(),
                                            orderlist[index]['discount_amount'].toString(),orderlist[index]['discount_percent'].toString());
                                      }
                                      }
                                      else{
                                        openpaymentmodeDialog( context,orderlist[index]['order_id'].toString(), orderlist[index]['total'].toString(),
                                            orderlist[index]['Advance_amount'].toString(), orderlist[index]['pending_amount'].toString(),
                                            orderlist[index]['date'].toString(), orderlist[index]['time'].toString(),
                                            orderlist[index]['token_no'].toString(), orderlist[index]['additional_amount'].toString(),
                                            orderlist[index]['discount_amount'].toString(),orderlist[index]['discount_percent'].toString());
                                      }
                                      }
                                      else{Fluttertoast.showToast(msg: "sorry there are no items in this orderid");}},
                                    child: Column(
                                      children: const [
                                        Icon(Icons.save_outlined, color: Colors.blue,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Text('Complete', style:TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {CheckUserConnection();
                                    await FirebaseAnalytics.instance.logEvent(
                                      name: "print_order_invoice",
                                    );
                                    List<String> childitemlist=[];
                                    List<String> childitempricelist=[];
                                    List<String> childitemtotallist=[];
                                    List<String> childitemidlist=[];
                                    List<String> childitemquantitylist=[];
                                    var item= orderlist[index]['order_id'].toString();
                                    var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitems');
                                    var response = await http.get(url);
                                    print('Response status: ${response.statusCode}');
                                    var tagObjsJson = jsonDecode(response.body)['products'] as List;
                                    for(int i=0; i<tagObjsJson.length; i++){
                                      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                                      if(jnResponse['user_id']==userid&& jnResponse['order_id']==orderlist[index]['order_id']){
                                      childitemlist.add(jnResponse['item_name'].toString());
                                      childitempricelist.add(jnResponse['item_price'].toString());
                                      childitemquantitylist.add(jnResponse['item_quantity'].toString()+jnResponse['renting_duration'].toString()+jnResponse['item_unit'].toString());
                                      childitemtotallist .add(jnResponse['item_total'].toString());
                                      childitemidlist    .add(jnResponse['item_id'].toString());
                                      }
                                    }
                                    print(childitemquantitylist);
                                    String oidd= orderlist[index]['order_id'].toString();
                                    String orderdate=orderlist[index]['date'].toString();
                                    String totl=orderlist[index]['total'].toString();
                                    String time=orderlist[index]['time'].toString();
                                    double ttl= double.parse(totl);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  Printorder(orderlist[index]['order_id'].toString(),
                                          orderlist[index]['token_no'].toString(), orderdate, time, childitemlist, childitempricelist,
                                          childitemquantitylist,childitemtotallist , ttl, mode,
                                          orderlist[index]['additional_amount'].toString(), orderlist[index]['discount_amount'].toString())),
                                    );
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.print, color: Colors.blue,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Text('Print', style: TextStyle(color: Colors.blue),),],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:() async {await FirebaseAnalytics.instance.logEvent(
                                      name: "delete_order",
                                    );
                                      opendeletedorderDialog(context, orderlist[index]['order_id'].toString()
                                          , orderlist[index]['total'].toString());
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(Icons.cancel, color: Colors.blue,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2.0),
                                        ),
                                        Text('Cancel', style:TextStyle(color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        headerDecoration: const BoxDecoration(
                          color: Colors.white24,
                          // color: Theme.of(context).primaryColorDark,
                          // color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [ BoxShadow(
                            color: Colors.white10,
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), ],


                        ),
                        expandedHeaderDecoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),),
                      ),)
                  )/*;
                }
                return  Center(
                  child:  CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blueGrey,
                        ),
                      ),
                );
              },
            ),*/
            )/*:
            Center(child:
            Column(children:[
              SizedBox(height: 15,),
              Lottie.asset("assets/animations/order.json", height: 250, width: 300),
              SizedBox(height: 10,),
              Text("You have no pending orders.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              TextButton(onPressed: ()async{await FirebaseAnalytics.instance.logEvent(
                name: "add_order_by_centerbutton",
              );
                Navigator.push(context, MaterialPageRoute(builder: (context) =>Addorder()));
              }, child: Container(
                  decoration: BoxDecoration(
                      color:Colors.blue,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.all(15),
                  child:Text("ADD ORDER", style:TextStyle(color:Colors.white))))
            ])),*/ ),
        floatingActionButton: TextButton(
              onPressed: () async{await FirebaseAnalytics.instance.logEvent(
                name: "add_order_by_floatingbutton",
              );
                Navigator.push(context, MaterialPageRoute(builder: (context) =>Addorder()));
              },
              child: Container(
                  width:135,
                  height: 40,
                  padding:EdgeInsets.only(left:8, right:8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
                            child:Row(children:[Icon(Icons.add,color: Colors.white),
                Text("ADD ORDER".tr(),style: TextStyle(fontSize: 15,color: Colors.white ),
                textAlign: TextAlign.center,
              )])) ,
            ),

      ),
    );}

opendeletedorderDialog(context, String orderid, total){
  showDialog(context: context, builder:(BuildContext context)
  {
    return StatefulBuilder(
        builder: (BuildContext context,
            setState) {
          return AlertDialog(title: const Text(
              'Are you sure to delete this order?'),
            actions: [
              Column(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: cancelorder,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      ),width: 30,
                          margin: EdgeInsets.only(bottom: 12),
                          child: CircularProgressIndicator()),
                    ),
                    ListTile(leading:
                        Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: cancelorderbtn,
                      child:    TextButton(
                        onPressed: () async {
                          setState((){cancelorder= true;
                          cancelorderbtn= false;});
                          await Deleteorder(orderid, total);setdocument();
                          setState((){cancelorder= false;
                          cancelorderbtn= true;});
                          Navigator.pop(context);
                        }, child:  Container(width:150, child:Center(child:Text('Yes', style:TextStyle(fontSize:18)))),
                      ),),
                      trailing:Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: cancelorderbtn,
                        child:   TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Container(width:150, child:Center(child:Text('No', style:TextStyle(fontSize:18)))),
                        ),),
                        )])
            ],
          );
        });
  });
}
  openpaymentmodeDialog(BuildContext context,String orderid, String total, String advance, String pendingamount,
      String date, String time,String tokn , additional, discount, discountper){
    customerid=""; customername="";
    showDialog(context: context, builder:(BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context,
              setState) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .circular(10)),
                title: const Text("Payment Mode"),
                content: Container(
                  // margin: EdgeInsets.only(left: 70),
                  width: 400,
                  height: 205,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          onTap:(){
                            if(nw==false) {
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
                          leading:Checkbox(
                            value: this.nw,
                            onChanged: (value) {
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
                          ), title: Text("Pay Now")),
                      ListTile(onTap: ()async{
                        if(paylater==false){
                          showDialog(
                              context: context,
                              builder:(BuildContext context){
                                return  StatefulBuilder(builder:  (BuildContext context, setState)
                                {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    title: const Text("Select"),
                                    content: Container(
                                      height: 160,
                                      // margin: EdgeInsets.all( 15),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          TextButton(onPressed:()async{ setState((){customerid ="";});await Opencustomerlist(context, orderid);if(customerid!=""){Navigator.pop(context);}},child:Row(children:[Icon(Icons.add), Text("ADD TO CUSTOMER RECORD")])),
                                          TextButton(onPressed:()async{ setState((){customerid ="";});await OpensupplierList(context, orderid);if(customerid!=""){Navigator.pop(context);}},child:Row(children:[Icon(Icons.add), Text("ADD TO SUPPLIER RECORD")]))
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });
                          if(customerid.isNotEmpty){//Navigator.pop(context);
                            setState((){paylater=true;paystatus= pending;
                            nw=false; timdel=false;});
                          }else{Fluttertoast.showToast(msg:"Kindly select customer name/ supplier name");}
                        }else{
                          setState(() {
                            this.paylater = false;
                          });
                        }
                      },
                        leading:Checkbox(
                          value: this.paylater,
                          onChanged: (value) async{
                            if(value==true){
                              showDialog(
                                  context: context,
                                  builder:(BuildContext context){
                                    return  StatefulBuilder(builder:  (BuildContext context, setState)
                                    {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        title: const Text("Select"),
                                        content: Container(
                                          height: 200,
                                          margin: EdgeInsets.all( 15),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              TextButton(onPressed:()async{ await Opencustomerlist(context, orderid);if(customerid!=""){Navigator.pop(context);}},child:Row(children:[Icon(Icons.add_shopping_cart), Text("Open customer list")])),
                                              TextButton(onPressed:()async{ await OpensupplierList(context, orderid);if(customerid!=""){Navigator.pop(context);}},child:Row(children:[Icon(Icons.add), Text("Open Supplier list")]))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  });
                              print(customerid);
                              if(customerid.isNotEmpty){
                                setState((){paylater=true;paystatus= pending;
                                nw=false; timdel=false;});}else{Fluttertoast.showToast(msg:"Kindly select customer name");}
                            }else{
                              setState(() {
                                this.paylater = false;
                              });
                            }
                          },
                        ), title:Text("Pay later"),),
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
                          visible: completeorder,
                          child: Container(
                              child: CircularProgressIndicator()
                          )
                      ),
                      SizedBox(height: 20,),
                      Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: completeorder,
                          child: Container(
                              child:
                              Text(
                                  "Please wait & do not press back!"))),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: completeorderbtn,
                        child:  TextButton(
                          onPressed: () async {
                            setState(() {
                              completeorder = true;
                              completeorderbtn= false;
                            });
                            CheckUserConnection();
                            await additemstocompleteorderitemlist(orderid);
                            if(nw==true){paystatus=paid;}else{paystatus=pending;}
                            if (onvalue != false) {mode = online;}
                            else if (offvalue != false) {mode = offline;}
                            if (paystatus.isNotEmpty) {
                              var placedtime =date;
                              var totalamount = total;
                              print("totalamount----$totalamount");
                              await markorderasComplete(orderid, totalamount, mode, paystatus, tokn, pendingamount,  advance,  additional, discount, discountper);
                              await doesProfitAlreadyExist(pendingamount, paystatus);
                              await addpendingpayment(orderid, supplier,customername, total, paystatus, customerid, tokn,
                                  pendingamount, paymode);
                              await deleteitemsfromorderitemlist(orderid);
                              var purl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder', {'id':userid+orderid});
                              var reso= await http.get(purl);
                              if(reso.body.isNotEmpty) {
                                var tagObjsJson = jsonDecode(reso.body) as Map<String, dynamic>;
                                var response = await http.delete(purl,
                                headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, String>{'id':tagObjsJson['id']}));}
                             setState(() {
                                completeorder = false;
                                completeorderbtn=true;
                              }); setdocument();
                              Navigator.pop(context);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Kindly select payment mode."
                                      .tr());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius
                                  .circular(15),
                              color: Colors.blue,
                            ),
                            width: double.maxFinite,
                            height: 40,
                            child: Text('Okay'.tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15),
                              textAlign: TextAlign
                                  .center,),
                          ),),),
                    ],
                  )
                ]);
          });
    });
  }

  OpensupplierList(BuildContext context, String oid) {
    String? selectedValueSingleMenu;
    showDialog(
        barrierDismissible : show,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ADD IN SUPPLIER ACCOUNT'),
            content: Container(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child:  Container(
                width: 400,
                margin: EdgeInsets.only(top: 15, bottom: 16),
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, left: 5, right: 5),
                height: double.infinity,
                child:SingleChildScrollView(child: Column(
                  children: [
                    FutureBuilder<List<AcceptedSuppliers>>(
                      future: Amplify.DataStore.query(AcceptedSuppliers.classType,
                        where:AcceptedSuppliers.USER_ID.eq(userid),),
                      builder: (BuildContext context,
                          snapshot) {
                        // Safety check to ensure that snapshot contains data
                        // without this safety check, StreamBuilder dirty state warnings will be thrown
                        if (!snapshot.hasData) return Container();
                        if(orderlist.length==0)return Container(child:Text("Kindly add Supplier."));
                        return SearchChoices.single(
                          clearIcon: Icon(Icons.abc),
                          displayClearIcon: false,
                          onClear: () {},
                          icon: Visibility(visible: false,
                            child: Icon(Icons.arrow_drop_down),),
                          //Visibility (visible:false, child: Icon(Icons.arrow_downward)),,
                          //  icon: Icon(Icons.add),
                          isExpanded: true,
                          value: selectedValueSingleMenu,
                          // : selectedValueSingleMenu,
                          hint: "Select Supplier".tr(),
                          // doneButton: Row(children:[Icon(Icons.check),SizedBox(width: 20,),Text("Done")]),
                          // closeButton: false,
                          searchHint: "Select Supplier".tr(),
                          items: orderlist.map((value) {
                            return DropdownMenuItem(
                              value:"${value.supplier_name}/?/${value.supplier_id}",
                              child: ListTile(title:Text('${value.shop_name}'), subtitle:Text('${value.supplier_name}'),),
                            );
                          }).toList(),
                          onChanged: (value) {
                            debugPrint('selected onchange: $value');
                            debugPrint( value);
                            setState((){show= false;
                            var arr = value.split('/?/');
                            customername= arr[0];
                            customerid= arr[1];});
                            print(customername +"CFFFF"+customerid);
                            Navigator.of(context).pop(true);
                          },
                        );
                      },
                    ),
                  ],
                ),
                ),),
            ),
          );
        });
  }
  openitemsdialog(BuildContext context, String oid, String tkn, String od) {
    String itemimage="", itemname="", itemprice="", quantity="", itemid="", price="";
    String? selectedValueSingleDialog;
    var total=0.0;
    bool additem=false, additembtn=true, edititem=false, edititembtn= true;

    CheckUserConnection();
    showDialog(
        context: context,
        builder: (BuildContext context)
        {var unit="";
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: Text("ADD ITEMS".tr()),
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
                                  child: Row(children: [Container(width: 100,child: Text('${value['item_name']}'),) ,
                                    Text('₹'+'${value['item_price_per_unit']}'), ],),
                                );
                              }).toList(),
                              value: selectedValueSingleDialog,
                              hint: "Select one",
                              searchHint: "Select one",
                              onChanged: (value) async{
                                setState(() async {
                                    selectedValueSingleDialog = value;
                                    var url= Uri.https(menuapi, 'Item/item',{'id': value});
                                    var response= await http.get(url );
                                    print("itbbghnbvghjnb${response.body}");
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
                              setState(()=>total= double.parse(price)* double.parse(value));
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
                      String orderid= DateFormat("yyMMddHHmmss").format(DateTime.now());
                      if(itemname.isEmpty || itemname.startsWith("0")){
                        setState((){additem=false; additembtn= true;});
                        Fluttertoast.showToast(msg: "Kindly select item.");
                      }
                      else if(quantity.isEmpty|| quantity.startsWith("0")){
                        setState((){additem=false; additembtn= true;});
                        Fluttertoast.showToast(msg: "Kindly enter quantity.");
                      }
                      else {
                        var url = Uri.https(stockapi, 'StockItemList/stockitem',
                            {"id": itemid});
                        var response = await http.get(url);
                        if (response.body.isNotEmpty) {
                          var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
                          if (double.parse(tagObjsJson['stock_quantity']) >= double.parse(quantity)){
                            var purl = Uri.https(
                                pendingorderitemapi, 'Pendingitems/pendingitem');
                            var response = await http.post(purl,
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, String>{
                                "id": userid +
                                    DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                                "user_id": userid,
                                "order_id": oid,
                                "token_no": tkn,
                                "item_id": itemid,
                                "item_name":itemname,
                                "item_quantity":quantity,
                                "item_price": itemprice,
                                "item_total": total.toString(),
                                "item_unit": unit,
                                "check_in_time": "",
                                "renting_duration": "",
                                "Check_out_time": "",
                                "item_status": pending}),);
                            if(response.statusCode==200){
                                var purl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder', {'id':od});
                                var reso= await http.get(purl);
                                if(reso.body.isNotEmpty) {
                                  var tagObjsJson = jsonDecode(reso.body) as Map<String, dynamic>;
                                  var response = await http.post(purl,
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      "id": tagObjsJson['id'],
                                      "user_id": tagObjsJson['user_id'],
                                      'order_id': tagObjsJson['order_id'],
                                      'token_no': tagObjsJson['token_no'],
                                      'total': (double.parse(tagObjsJson['total'])+total).toString(),
                                      'discount_amount': tagObjsJson['discount_amount'],
                                      'discount_percent': tagObjsJson['discount_percent'],
                                      'additional_amount':tagObjsJson['additional_amount'],
                                      'date': tagObjsJson['date'],
                                      'time': tagObjsJson['time'],
                                      'Advance_amount':tagObjsJson['Advance_amount'],
                                      'pending_amount': (double.parse(tagObjsJson['pending_amount'])+total).toString()}),);
                                  if(response.statusCode==200){
                                    print("item added success");
                                   await substractitemquantityfromstock(itemid, itemname, quantity);
                                   setState((){additem=false; additembtn= true;});
                                   setdocument();
                                   Navigator.pop(context);
                                  }
                                }
                            }
                          }
                          else {
                            setState((){additem=false; additembtn= true;});
                            Fluttertoast.showToast(
                                msg: "Sorry for inconvenience " + itemname + " is not available is not available in your stock, Kindly update your stock then place order.");
                          }
                        }
                      }
                      }, child: Container(height:35, child:Text("Add", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
                ),]),
            ],
          );
        });
        });
  }
  openrentaldialog(BuildContext context, String oid, String tkn, String od) {
    String itemid="", itemname="", itemprice="", quantity="", price="";
    bool additem=false, additembtn=true, edititem=false, edititembtn= true;
    String?selectedValueSingleDialog;
    var ttl=0.0;
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
                          future: renteditems(userid),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) return Container();
                            return SearchChoices.single(
                              items: snapshot.data!.map((value) {
                                print("value      $value");
                                return DropdownMenuItem(
                                  value: value['id'],
                                  child: Container(padding:EdgeInsets.all(6),decoration:BoxDecoration(borderRadius: BorderRadius.circular(10),
                                      color: value['product_engagement']==engaged?Colors.blueAccent:null),
                                      child: Row(children: [Container(width: 100,child: Text('${value['rented_item_name']}', )),
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
                                setState(() {
                                  ttl= double.parse(price)* double.parse(value);
                                  quantity = value;
                                });
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
                      if(itemname.isEmpty &&itemname.startsWith("0", 0)){
                        setState((){additem=false; additembtn= true;});
                        Fluttertoast.showToast(msg: "Kindly select item.");
                      }
                      else if(quantity.isEmpty && quantity.startsWith("0", 0)){
                        setState((){additem=false; additembtn= true;});
                        Fluttertoast.showToast(msg: "Kindly enter quantity.");
                      }
                      else{
                        var url = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem');
                        var response = await http.post(url,
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, String>{
                            "id": userid + DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
                            "user_id": userid,
                            "order_id": oid,
                            "token_no": tkn,
                            "item_id": itemid,
                            "item_name":itemname,
                            "item_quantity":"",
                            "item_price": itemprice,
                            "item_total": ttl.toString(),
                            "item_unit": unit,
                            "check_in_time": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
                            "renting_duration": quantity,
                            "Check_out_time": "",
                            "item_status": pending}),);
                        if(response.statusCode==200){
                          var purl = Uri.https(pendingorderapi, 'Pendingorder/pendingorder', {'id':od});
                          var reso= await http.get(purl);
                          if(reso.body.isNotEmpty){
                              var tagObjsJson = jsonDecode(reso.body) as Map<String, dynamic>;
                              var response = await http.post(purl,
                                headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                },
                                body: jsonEncode(<String, String>{
                                  "id": tagObjsJson['id'],
                                  "user_id": tagObjsJson['user_id'],
                                  'order_id': tagObjsJson['order_id'],
                                  'token_no': tagObjsJson['token_no'],
                                  'total': (double.parse(tagObjsJson['total'])+ttl).toString(),
                                  'discount_amount': tagObjsJson['discount_amount'],
                                  'discount_percent': tagObjsJson['discount_percent'],
                                  'additional_amount':tagObjsJson['additional_amount'],
                                  'date': tagObjsJson['date'],
                                  'time': tagObjsJson['time'],
                                  'Advance_amount':tagObjsJson['Advance_amount'],
                                  'pending_amount': (double.parse(tagObjsJson['pending_amount'])+ttl).toString()}),);
                              if(response.statusCode==200){
                                var renturl= Uri.https(rentedapi, 'RentedItem/renteditem', {'id':itemid}, );
                                var response= await http.get(renturl );
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
                                      "product_engagement": engaged,
                                      "rented_duration": tagObjsJson['rented_duration'],
                                      "rentout_to_client_id": tagObjsJson['rentout_to_client_id']}),);
                                  if(resp.statusCode==200){setdocument();
                                    setState((){ additem=false; additembtn= true; });}
                                }
                              }
                          }
                        }
                        print("quantity -----  $quantity");
                        setState((){ additem=false; additembtn= true; });}
                      Navigator.pop(context);
                      }, child: Container(height:35, child:Text("Add", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color:Colors.white),)))),
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
          print("outgj-- $jnResponse");
          setState(() {
            rentedlist.add(jnResponse);
          });
        }
      }
    }
    return rentedlist;
  }
  Future<List> menulist(user)async{
    var menulist=[];
    var url= Uri.https(menuapi, 'Item/items',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==user){print("outgj-- $jnResponse");
      setState((){
        menulist.add(jnResponse);
      });
      }
    }
    return menulist;
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

  setdocument()async{
    orderlist=[];
    await getorderlist(userid);
  }
  Future doesmonthlyprofitrecordexist(String expn, String exdate, String pst) async {
      print("DEFERG");
      String pttl="0", ttal="0";
      if(pst==pending){pttl= expn;} else{ttal= expn;}
      String month= DateFormat("yyyy-MM-dd").format(DateTime.parse(exdate));
      String year=exdate[2]+exdate[3];
      String proid=DateFormat("yMMMM").format(DateTime.now()) ;

      var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id': userid+proid});
      var response= await http.get(url );
      if(response.body.isEmpty)  {
        var murl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord');
        var esponse = await http.post(
            murl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":userid+proid,
            "user_id": userid,
            "monthly_profit_id":proid,
            "monthly_profit": expn,
            "Expanse_amount": "0",
            "Earned_amount":expn,
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year":  DateFormat("yyyy").format(DateTime.now())
            }));
        if(esponse.statusCode==200){
          print("profitsuccess");
        }
      }
      else{
        var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
        var esponse = await http.post(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id": jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "monthly_profit_id": jsonResponse['monthly_profit_id'],
              "monthly_profit": (double.parse(jsonResponse['monthly_profit'])+double.parse( expn)).toStringAsPrecision(2),
              "Earned_amount":(double.parse(jsonResponse['Earned_amount'])+double.parse(expn) ).toStringAsPrecision(2),
              "Expanse_amount": jsonResponse['Expanse_amount'],
              "month": jsonResponse['month'],
              "year": jsonResponse['year']
            }));
        if(esponse.statusCode==200){
         print('profitsucces');
        }
      }

    }
    Future<void> doesProfitAlreadyExist(String name, String pst) async {CheckUserConnection();
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;

    var url= Uri.https(profitapi, 'Profit/profit',{'id': userid+proid});
    var response= await http.get(url );
    if(response.body.isEmpty){
      var purl = Uri.https(profitapi, 'Profit/profit');
      var response = await http.post(
          purl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+proid,
            "user_i": userid,
            "profit_id": proid,
            "profit":name,
            "earned":name,
            "expanse": "0",
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      if(response.statusCode==200){
       doesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), pst);
      }
    }
    else{
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var purl = Uri.https(profitapi, 'Profit/profit');
      var reponse = await http.post(
          purl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":jsonResponse['id'],
            "user_i": jsonResponse['user_i'],
            "profit_id": jsonResponse['profit_id'],
            "profit":(double.parse(name)+ double.parse(jsonResponse['profit'])).toString(),
            "earned":(double.parse(name)+ double.parse(jsonResponse['earned'])).toString(),
            "expanse": jsonResponse['expanse'],
            "date":  jsonResponse['date'] ,
            "month": jsonResponse['month'] ,
            "year":  jsonResponse['year']
          }));
      if(reponse.statusCode==200){
        doesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), pst);
      }
    }

  }
  Future additemstocompleteorderitemlist(String item,/*String checkout,String duration*/) async{
    var qty="";
    var url = Uri.https(pendingorderitemapi, '/Pendingitems/pendingitems');
    var response = await http.get(url);
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++) {
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if (jnResponse['user_id'] == userid && jnResponse['order_id'] ==item) {
        var curl = Uri.https(completeorderitemapi, 'CompleteOrderItem/completeorderitem');//CompleteOrderItem
        var response = await http.post(curl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": jnResponse['id'].toString(),
            "user_id": jnResponse['user_id'].toString(),
            "order_id": jnResponse['order_id'].toString(),
            "token_no": jnResponse['token_no'].toString(),
            "item_id": jnResponse['item_id'].toString(),
            "item_name": jnResponse['item_name'].toString(),
            "item_quantity": jnResponse['item_quantity'].toString(),
            "item_price": jnResponse['item_price_per_unit'].toString(),
            "item_total": jnResponse['item_total'].toString(),
            "item_unit": jnResponse['item_unit'].toString(),
            "check_in_time":jnResponse['check_in_time'].toString(),
            "rented_duration": jnResponse['rented_duration'].toString(),
            "Check_out_time":  DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
            "item_status": completed}),);
        if(response.statusCode==200){print("Data storeditemvgsuccessfully");}
      }
    }
 }
  Future deleteitemsfromorderitemlist(String item)async{
    var url = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitems');
    var response = await http.get(url);
    if(response.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      for (int i = 0; i < tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if (jnResponse['user_id'] == userid && jnResponse['order_id'] == item) {
          var curl = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem');
          var response = await http.delete( curl,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                "id": jnResponse['id'].toString()}));
        }
      }
    }
       List<PendingOrderItems> CompletedOrderItemss = await Amplify.DataStore.query(PendingOrderItems.classType,
       where: PendingOrderItems.USER_ID.eq(userid).and(PendingOrderItems.ORDER_ID.eq(item)));
       for(int i=0; i<CompletedOrderItemss.length; i++){
         List<RentedItems> MenuItemss = await Amplify.DataStore.query(RentedItems.classType,
             where: RentedItems.USER_ID.eq(userid)
                 .and(RentedItems.PRODUCT_ID.eq(CompletedOrderItemss[i].item_id))
                 .and(RentedItems.RENTED_ITEM_NAME.eq(CompletedOrderItemss[i].item_name)));
         if(MenuItemss.isNotEmpty){
           final newItem =MenuItemss[i].copyWith(
               user_id:MenuItemss[i].user_id,
               product_id:  MenuItemss[i].product_id,
               rented_item_name: MenuItemss[i].rented_item_name,
               charger_per_duration: MenuItemss[i].charger_per_duration,
               product_engagement:vaccant,
               rented_duration: MenuItemss[i].rented_duration,
               rentout_to_client_id: customerid);
           await Amplify.DataStore.save(newItem).whenComplete(() async {
             await Amplify.DataStore.delete(CompletedOrderItemss[i]);
           });}else{ await Amplify.DataStore.delete(CompletedOrderItemss[i]);}
       }
      }
   markorderasComplete(String item, String totalamount, String mode, String payst, String token, String pend, String advan, String additional, String discount, String discoutper) async {
     var url = Uri.https(completeorderapi, 'Completeorders/completeorder', );
     var response = await http.post(url,
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String, String>{
           'id':userid+item,
           'user_id': userid,
           'order_id':item,
           'token_no': token,
           'total': totalamount,
           'payment_mode': mode,
           'payment_status': payst,
           'transaction_id': transactionid,
           'status': "Completed",
           'discount_amout':discount,
           'additional_amount':additional,
           'discount_percent':discoutper,
           'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
           'time': DateFormat("HH:mm:ss").format(DateTime.now()),
           'Advance_amount': advan,
           'pending_amount': pend
         }));
     if(response.statusCode==200){
     print("Data stored successfully");}
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
         updatestockrecords( tagObjsJson['stock_id'].toString(), quantity, stockname,tagObjsJson['selling_price_per_unit'].toString(),
             tagObjsJson['stock_unit'].toString());
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

  /*updatestockrecords(String stockid, String quantity, String stockname, String sellprice, String unit) async {
     final item = StockRecord(
         user_id: userid,
         stock_id: stockid,
         stock_record_id: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
         stock_quantity: "-"+ quantity,
         stock_investment: "-"+(double.parse(sellprice)*double.parse(quantity)).toString(),
         selling_price_per_unit: sellprice,
         stock_name: stockname,
         date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
         time: DateFormat("HH:mm:ss").format(DateTime.now()),);
     await Amplify.DataStore.save(item)
         .whenComplete((){print("stockrecordupdated finished");});
   }
   updatependingorder(String total, String id) async {
       List<PendingOrders> PendingOrderss = await Amplify.DataStore.query(PendingOrders.classType,
       where: PendingOrders.USER_ID.eq(userid).and(PendingOrders.ORDER_ID.eq(id)));
    if(PendingOrderss.isNotEmpty){print("object");
    final updatedItem =  PendingOrderss[0].copyWith(
        user_id: PendingOrderss[0].user_id,
        order_id:  PendingOrderss[0].order_id,
        token_no:  PendingOrderss[0].token_no,
        total: (double.parse( PendingOrderss[0].total.toString())-double.parse(total)).toString(),
        date:  PendingOrderss[0].date,
        time:  PendingOrderss[0].time);
    await Amplify.DataStore.save(updatedItem).whenComplete(() => print("complete delete"));
    }
  }*/
   deletedprofit(String totalamount)async {CheckUserConnection();
     String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
     List<Profit> Profits = await Amplify.DataStore.query(Profit.classType,
     where: Profit.USER_I.eq(userid).and(Profit.PROFIT_ID.eq(proid)));
     if(Profits.isNotEmpty){
       final updatedItem = Profits[0].copyWith(
           user_i: Profits[0].user_i,
           profit_id: Profits[0].profit_id,
           profit: (double.parse(Profits[0].profit.toString())+ double.parse(totalamount)).toString(),
           earned: (double.parse(Profits[0].earned.toString())- double.parse(totalamount)).toString(),
           expanse: Profits[0].expanse,
           date: Profits[0].date,
           month: Profits[0].month,
           year: Profits[0].year);
       await Amplify.DataStore.save(updatedItem)
           .whenComplete((){ print("updateprofitsucess");
       deletemonthlyprofitrecordexist(totalamount, DateFormat("yyyyMMdd").format(DateTime.now()));});
     }
   }
   deletemonthlyprofitrecordexist(String totalamount, String exdate)  async {
     print("DEFERG");
     String month= DateFormat("yyyy-MM-dd").format(DateTime.parse(exdate));
     String year=exdate[2]+exdate[3];
     String proid=DateFormat("yMMMM").format(DateTime.now()) ;
       List<ProfitMonthlyRecord> ProfitMonthlyRecords = await Amplify.DataStore.query(ProfitMonthlyRecord.classType,
       where: ProfitMonthlyRecord.USER_ID.eq(userid).and(ProfitMonthlyRecord.MONTHLY_PROFIT_ID.eq(proid)));
     if(ProfitMonthlyRecords.isNotEmpty){
       final updatedItem = ProfitMonthlyRecords[0].copyWith(
           user_id: ProfitMonthlyRecords[0].user_id,
           monthly_profit_id: ProfitMonthlyRecords[0].monthly_profit_id,
           monthly_profit: (double.parse(ProfitMonthlyRecords[0].monthly_profit.toString())- double.parse(totalamount)).toString(),
           Earned_amount: (double.parse(ProfitMonthlyRecords[0].Earned_amount.toString())-double.parse(totalamount)).toString(),
           Expanse_amount: ProfitMonthlyRecords[0].Expanse_amount,
           month: ProfitMonthlyRecords[0].month,
           year: ProfitMonthlyRecords[0].year);
       await Amplify.DataStore.save(updatedItem).whenComplete(() => print("Deedewfiuewuuuuuu"));
     }
   }
   opendialog(BuildContext context) {
    showDialog(context: context , builder: (BuildContext context){
      print(" ---------------------------   ");
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius
                .circular(10)),
        title: const Text("Payment Mode"),
      );
    }
    );
   }
   void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }
   Deleteorder(String item, String totalamount) async {
     var itemid=[];
     print("deleteorder");
     var url = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitems');
     var response = await http.get(url);
     var tagObjsJson = jsonDecode(response.body)['products'] as List;
     for(int i=0; i<tagObjsJson.length; i++) {
       var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
       if (jnResponse['user_id'] == userid && jnResponse['order_id'] ==item) {  print("deleye orde r   $item");
         await additemquantityfromstock(jnResponse['item_name'].toString(),jnResponse['item_quantity'].toString(),
             jnResponse['item_id'].toString());
         var delurl = Uri.https(deletedorderitemapi, 'DeletedorderItem/deleteditem');
         var resp = await http.post(delurl,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":jnResponse['id'].toString(),
               "user_id":userid,
               "order_id": item,
               "token_no":jnResponse['token_no'].toString(),
               "item_id": jnResponse['item_id'],
               "item_name":jnResponse['item_name'],
               "item_unit": jnResponse['item_unit'],
               "rented_duration":jnResponse['renting_duration'] ,
               "check_in_time": jnResponse['check_in_time'],
               "item_quantity":jnResponse['item_quantity'],
               "item_price": jnResponse['item_price'],
               "item_total": jnResponse['item_total'],}));
         if(resp.statusCode==200){print("senfdrtyhdrtyu    ${jnResponse['item_name']}");
           itemid.add(jnResponse['item_id']);
           var renturl= Uri.https(rentedapi, 'RentedItem/renteditem', {'id':jnResponse['item_id']}, );
           var response= await http.get(renturl );
           if(response.body.isNotEmpty){
             var tagObjsJson = jsonDecode(response.body)as Map<String, dynamic>;
             var resp = await http.post(renturl,
               headers: <String, String>{
                 'Content-Type': 'application/json; charset=UTF-8',
               },
               body: jsonEncode(<String, String>{
                 "id":tagObjsJson['id'].toString(),
                 "user_id":tagObjsJson['user_id'],
                 "product_id": tagObjsJson['product_id'],
                 "rented_item_name": tagObjsJson['rented_item_name'],
                 "charger_per_duration": tagObjsJson['charger_per_duration'],
                 "product_engagement": "",
                 "rented_duration": tagObjsJson['rented_duration'],
                 "rentout_to_client_id": tagObjsJson['rentout_to_client_id']}),);}
           else{addstock(jnResponse['item_id'], jnResponse['item_quantity']);;}
         }
       }
     }
     var pendorurl= Uri.https(pendingorderapi, 'Pendingorder/pendingorder', {'id':userid+item}, );
     var rese= await http.get(pendorurl );
     if(rese.body.isNotEmpty){
       var tagObjsJson = jsonDecode(rese.body)as Map<String, dynamic>;
       var delurl = Uri.https(deletedorderapi, 'DeletedOrder/deletedorder');
     var resp = await http.post(delurl,
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String, String>{
           "id":tagObjsJson['id'].toString(),
           "user_id": userid,
           "order_id": item,
           "token_no": tagObjsJson['token_no'],
           "total": totalamount,
           "status": "deleted",
           "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
           "time": DateFormat("HH:mm:ss").format(DateTime.now())}));
     if(resp.statusCode==200){
       for(int i=0; i<itemid.length; i++){
         var url = Uri.https(pendingorderitemapi, 'Pendingitems/pendingitem', {'id':itemid[i]});
         var resp = await http.delete(url,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":itemid[i]}));
       }
       var re= await http.delete(pendorurl, headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
           body: jsonEncode(<String, String>{
             "id":userid+item})
       );
     }
     }
   }
   Opencustomerlist(BuildContext context, String oid) {
     String? selectedValueSingleMenu;
     showDialog(
         barrierDismissible : show,
         context: context,
         builder: (BuildContext context) {

           return AlertDialog(
             title: Text("ADD IN CUSTOMER'S ACCOUNT"),
             content: Container(
               height: 300.0, // Change as per your requirement
               width: 300.0, // Change as per your requirement
               child:  Container(
                 width: 400,
                 margin: EdgeInsets.only(top: 15, bottom: 16),
                 padding: EdgeInsets.only(
                     top: 10, bottom: 10, left: 5, right: 5),
                 height: double.infinity,
                 child:SingleChildScrollView(child: Column(
                   children: [
                     FutureBuilder<List<CustomerLis>>(
                       future: Amplify.DataStore.query(CustomerLis.classType,
           where:CustomerLis.USER_ID.eq(userid),),
                       builder: (BuildContext context,
                           snapshot) {
                         // Safety check to ensure that snapshot contains data
                         // without this safety check, StreamBuilder dirty state warnings will be thrown
                         if (!snapshot.hasData) return Container();
                         if(orderlist.length==0)return Container(child:Text("Kindly add Customer."));
                         return SearchChoices.single(
                           clearIcon: Icon(Icons.abc),
                           displayClearIcon: false,
                           onClear: () {},
                           icon: Visibility(visible: false,
                             child: Icon(Icons.arrow_drop_down),),
                           //Visibility (visible:false, child: Icon(Icons.arrow_downward)),,
                           //  icon: Icon(Icons.add),
                           isExpanded: true,
                           value: selectedValueSingleMenu,
                           // : selectedValueSingleMenu,
                           hint: "Select Customer".tr(),
                           // doneButton: Row(children:[Icon(Icons.check),SizedBox(width: 20,),Text("Done")]),
                           // closeButton: false,
                           searchHint: "Select Customer".tr(),
                           items: orderlist.map((value) {
                             return DropdownMenuItem(
                               value:"${value.customer_name}?${value.customer_id}",
                               child: Text('${value.customer_name}'),
                             );
                           }).toList(),
                           onChanged: (value) {
                             debugPrint('selected onchange: $value');
                             debugPrint( value); var iddddd="";
                             setState((){show= false;
                             var arr = value.split('?');
                               customername= arr[0];
                               customerid= arr[1];});
                              print(customername +"CFFFF   bnb hbh    $iddddd                      "+customerid);
                              Navigator.pop(context);
                               },
                             );
                           },
                         ),
                   ],
                 ),
                 ),),
             ),
           );
         });if(customerid!=""){Navigator.pop(context);}
   }
   addpendingpayment( String orderid, String supplier, String shpname, String total,String paystatus,
      String cumstomid, String tkn, String pendingamt, String mode) async {

    var url = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
    var response = await http.post(url,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":userid+orderid,
        'user_id': userid,
        'client_id': cumstomid,
        'record_id':orderid,
        'payment_status': paystatus,
        'payment_mode': paymode,
        'transaction_id': transactionid,
        'received_amount':"0",
        'sent_amount': pendingamt,
        'party_name':shpname,
        'date': DateFormat("yyyy-MM-dd").format(
            DateTime.now()),
        'time': DateFormat("HH:mm:ss").format(
            DateTime.now()),
        'party': supplier,
        'description': "Payment of orderid- $orderid \t\t\t $paystatus \n token no - $tkn"
      }),);
   if(response.statusCode==200){print("orderupdated finished");
          transactionid="";
    }
    print(cumstomid);
    if(paystatus==pending){
      var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',{
        'id':userid+cumstomid});
      var resp = await  await http.get(murl );
      if(resp.body.isNotEmpty) {
        var jsonResponse = convert.jsonDecode(resp.body) as Map<String, dynamic>;
        var response = await http.post(murl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":jsonResponse['id'],
            "user_id": jsonResponse['user_id'],
            "customer_id":jsonResponse['customer_id'],
            "customer_name": jsonResponse['customer_name'],
            "customer_phone_no": jsonResponse['customer_phone_no'],
            "advance_amount": '0',
            "pending_amount": (double.parse(jsonResponse['pending_amount'].toString())+double.parse(pendingamt)).toString(),
            "date": jsonResponse['date'],
            "time": jsonResponse['time']}),);
      }
      else{
        var surl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':userid+cumstomid});
        var response= await http.get(surl );
        if(response.body.isNotEmpty){
          setState((){supplier='Supplier';});
          var jnResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
          double advance=0.0, pendi=0.0;
          if(double.parse(jnResponse['Advance_amount'].toString())>0){
            var result= double.parse(jnResponse['Advance_amount'].toString())-double.parse(pendingamt);
            if(result>0){setState((){advance=result;});}else{setState((){pendi= (-1.0)*result;});}
          }else{
            var result= double.parse(jnResponse['Pending_amount'].toString())+double.parse(pendingamt);
            setState((){pendi= result;});
          }
          var respo = await http.post(surl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              'Advance_amount': (advance).toString() ,
              'Pending_amount': (pendi).toString() ,
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
      }
      var penurl= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': userid+cumstomid});
      var resonse= await http.get(penurl );
      if(resonse.body.isNotEmpty){
        print("object${resonse.body}");
        var jsonResponse =
        convert.jsonDecode(resonse.body) as Map<String, dynamic>;
        var esponse = await http.post(
            penurl,
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
              "Pending_amount": (double.parse(pendingamt)+double.parse(jsonResponse['Pending_amount'].toString())).toString()
            }));
        if(esponse.statusCode==200){
        }
      }
      else{
        var esponse = await http.post(
            penurl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id": userid+cumstomid,
              "user_id": userid,
              "client_id": cumstomid,
              "record_id": userid+cumstomid,
              "party": supplier,
              "party_name": shpname,
              "Pending_amount": (double.parse(pendingamt)).toString()
            }));
      }
      print("shopname----- $shpname");
    }
    else{
      var purl = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
      var response = await http.post(
          purl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            "user_id": userid,
            "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            "token_no": "",
            "order_id": "",
            "client_id": cumstomid,
            "received_amount": pendingamt,
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "time": DateFormat("HH:mm:ss").format(DateTime.now()),
            "payment_mod": mode,
            "sent_amount": "0",
            "description":"Payment of orderid- $orderid \n token no - $tkn",
          }));
     if(response.statusCode==200){

       var curl = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
       var response = await http.post(curl,   headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
         body: jsonEncode(<String, String>{
           "id":userid+orderid,
           'user_id': userid,
           'client_id': cumstomid,
           'record_id': orderid,
           'payment_status': paystatus,
           'payment_mode':paymode,
           'transaction_id': transactionid,
           'received_amount':pendingamt,
           'sent_amount': "0",
           'party_name':shpname,
           'date': DateFormat("yyyy-MM-dd").format(
               DateTime.now()),
           'time': DateFormat("HH:mm:ss").format(
               DateTime.now()),
           'party': supplier,
           'description':"Payment of orderid- $orderid \n token no - $tkn",
         }),);
      }
    }
  }

  Future<void> addstock(id, qty) async {
    var turl = Uri.https(stockapi, 'StockItemList/stockitem',
        {"id": id});
    var respon = await http.get(turl);
    if (respon.body.isNotEmpty) {
      var tagObjsJson = jsonDecode(respon.body) as Map<String, dynamic>;
      var response = await http.post(turl, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, String>{
          "id": tagObjsJson['id'].toString(),
          "user_id": tagObjsJson['user_id'],
          "stock_id": tagObjsJson['stock_id'],
          "stock_name": tagObjsJson['stock_name'],
          "stock_quantity": (double.parse(tagObjsJson['stock_quantity']) +
              double.parse(qty)).toString(),
          "stock_investment": tagObjsJson['stock_investment'],
          "selling_price_per_unit": tagObjsJson['selling_price_per_unit'],
          "constant_quantity": tagObjsJson['constant_quantity'],
          "stock_status": tagObjsJson['stock_status'],
          "stock_unit": tagObjsJson['stock_unit']}),);
      if (response.statusCode == 200) {
        addstockrecords(tagObjsJson['stock_id'].toString(), qty,  tagObjsJson['stock_name'], tagObjsJson['selling_price_per_unit'],
            tagObjsJson['stock_unit'].toString());
      }
    }
  }
    addstockrecords(String stockid, String quantity, String stockname, String sellprice, String unit) async {

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


}


