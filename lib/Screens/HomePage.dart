import 'dart:convert';
import 'dart:convert' as convert;
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl_browser.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../Screens/Help.dart';
import '../Screens/Orders.dart';
import '../models/ModelProvider.dart';
import '../reusable_widgets/apis.dart';
import 'AddSupplierdetails.dart';
import 'Notifications.dart';
import 'dart:async';
import 'Pending_payments.dart';
import 'Privacy_policy.dart';
import 'Profit.dart';
import 'Stock.dart';
import 'SubscriptionModule.dart';
import 'SuppliersList.dart';
import 'aboutus.dart';
import 'deletedOrders.dart';
import 'login/Login.dart';
import 'menu.dart';
import 'order_complete.dart';
import 'package:path/path.dart';

import 'payment_Records.dart';
import 'package:share_plus/share_plus.dart';
import 'package:awesome_notifications/android_foreground_service.dart';
class Home extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,

            title: 'DashBoard',
            theme: ThemeData(//primarySwatch: Colors.lightBlue,
              primaryColor: Colors.black87,
              primaryColorDark:Colors.white,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home:   const HomePage(user: "",),
          );
        });
  }
}
class HomePage extends StatefulWidget {

  const HomePage({Key? key, required this.user}) : super(key: key);

  final String user;

  @override
  State<HomePage> createState() => _itemPageState();
}
class _itemPageState extends State<HomePage> {
  var pageIndex=2;
  String appname= "The Billing Coach", deliverd= "Delivered" ;
  int _page=0;
  String fetchlocation='Fetch your restaurant location'.tr();
  final geolocator =
  Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? _currentPosition;
  String currentAddress = "", username="";
  var first;
  var userlatitude, userlongitude, postaladdress, pincode;
  void getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }
  String month="Month", day="Day", hour= "Hour", minute= "Minute", year="Year";
  @override
  void didChangeDependencies(){
    if(1==1){
      // Theme.of(context).primaryColorLight;
    }
    super.didChangeDependencies();
  }
  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];

      setState(() {
        currentAddress =
        "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
        print("currentAddress------ $currentAddress");
      });
    } catch (e) {
      print(e);
    }
  }
  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    debugPrint('location: ${position.latitude}');
    List<Placemark> addresses = await
    placemarkFromCoordinates(position.latitude,position.longitude);
    userlatitude  = position.latitude;
    userlongitude = position.longitude;
    first = addresses.first;
    print(first);
    postaladdress=first.name +" "+ first.subLocality +" "+ first.locality +" "+ first.administrativeArea +" "+ first.country +" "+first.postalCode ;
    pincode= first.postalCode;
    print(first.subAdministrativeArea);
    print(first.subLocality);
    print(first.locality);
    print("${first.name} : ${first..administrativeArea} ");
    return first;
  }
  String userid="";
 final pages = [
   const UserStock(),
   const SuppliersList(),
   const IncompleteOrders(),
   ProfitScreen(),
   const PendingPaymentScreen(),
   const SuppliersList(),
   const MenuViewScreen(),
 ];
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
var suplieridexist;
  var Supplierss=[];
  String restroname="",link="" ,phoneno="", address="",delchrge="",delstts="", areacode="", profileimg="", email="";
  bool addetails=false, updatepasswrd=false, adddetailsbtn= true, updatepasswordbtn= true;
  Future<void> getsubscription(context, uid) async{
    var noww= DateFormat("yy-MM-dd").format(DateTime.now());
    var det= DateFormat("yy-MM-dd").parse(noww);
    var kyurl= Uri.https(subscript, 'AppSubscription/appsubscriptions',{'id':uid} );
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
      print("poiuy76t54rewaszdxcfgvbhjkio0987=============   "+jsonResponse['status'].toString());
      print(jsonResponse['expiry_date'].toString());
      print('dtegdtdg      ${jsonResponse['status'].toString()}');
      if(jsonResponse['status'].toString()!="Inactive"){print("moccccccccccccccccccc");runApp(Home());}
      else{
        var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
        var cdate= DateFormat("yy-MM-dd").parse(date);
        var exdate= jsonResponse['expiry_date'].toString();
        var edate= DateFormat("yy-MM-dd").parse(exdate);
        print(edate.difference(cdate).inDays);
        if(edate.difference(cdate).inDays<=0){print("uhbftr");
        var response = await http.post(kyurl,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id": jsonResponse['id'],
            'user_id': jsonResponse['user_id'],
            'plan_id':jsonResponse['plan_id'],
            'transaction_id': jsonResponse['transaction_id'],
            'plan':jsonResponse['plan'],
            'issue_date': jsonResponse['issue_date'],
            'expiry_date': jsonResponse['expiry_date'],
            'plan_charges': jsonResponse['plan_charges'],
            'status': "Inactive",
            "valid_till": jsonResponse['valid_till']}),);
        if(response.statusCode==200){
          runApp(SubscriptionModule(ccid: uid,));
        }
        }
      }
    }
    else{
      runApp(SubscriptionModule(ccid: uid,));
    }
  }
 Future<void> getuserdetails() async {
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
           suplieridexist=true;
           restroname = jsonResponse['shop_name'].toString();
           phoneno = jsonResponse['username'].toString();
           delstts= jsonResponse['delivery_status'].toString();
           delchrge = jsonResponse['delivery_charges'].toString();
           areacode = jsonResponse['supplier_name'].toString();
         });}

       var kyurl= Uri.https(rkey, 'Rzorkey/rzorkey',{'id': "1"} );
       var kresponse= await http.get(kyurl );
       if(kresponse.body.isNotEmpty){
         var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
         if(this.mounted){
         setState((){
           link= jsonResponse['link'].toString();});}
       }
     }
   }
   else{runApp(LoginScreen());}
  }
 Future getsupplier(String use)async{
   var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': userid} );
   var response= await http.get(url );
   print(response.body);
   if(response.body.isNotEmpty){
     var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   print("stocklosy--  ${jsonDecode(response.body)}");
   if (this.mounted) {
       setState(() {
         suplieridexist=true;
         restroname = jsonResponse['shop_name'].toString();
         phoneno = jsonResponse['username'].toString();
         delstts= jsonResponse['delivery_status'].toString();
         delchrge = jsonResponse['delivery_charges'].toString();
         areacode = jsonResponse['supplier_name'].toString();
       });}
   }
    }

  var showcasestatus;
var home;
 Future getpreferencestatus()async{
    final SharedPreferences prefs = await preferences;
    final counter = prefs.getBool('showShowcase');
    setState(() {
      home=prefs.getBool('showShowcase');
      });
    if(counter==null){
      setState((){pageIndex=2;});
      prefs.setBool('showShowcase', true);
    }
    return counter;
  }
  @override
  void initState() {CheckUserConnection();
  AndroidForegroundService.startForeground(
      content: NotificationContent(
          id: 2341234,
          body: 'Service is running!',
          title: 'Android Foreground Service',
          channelKey: 'basic_channel',
          bigPicture: 'asset://assets/logofront.png',
          notificationLayout: NotificationLayout.BigPicture,
          category: NotificationCategory.Service
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'SHOW_SERVICE_DETAILS',
            label: 'Show details'
        )
      ]
  );
  getuserdetails();
  super.initState();
}
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
      });
    }
  }
  bool ShowAppBar = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController _restroname=TextEditingController();
    TextEditingController _restrophoneno=TextEditingController();
    TextEditingController _restroaddress=TextEditingController();
    TextEditingController _restropincode=TextEditingController();
    GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    bool onvalue = false, offvalue= false;
    var mode="", storename="", storeownername="", storemobno, delivery="", storeaddress="",
       deliverycharge="", upi="";
    List<int> selectedItemsMultiMenu = [];
    return WillPopScope(
        onWillPop: ()async {print("object");
          // return false;},
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Do you want to go back?'),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            });
           return false;},
      child: Scaffold(
        body:pageIndex!=null? pages[pageIndex]:Container(),
        drawer: Drawer(//backgroundColor: Colors.white,
      child:ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(// decoration: BoxDecoration(color:  Theme.of(context).primaryColorDark,),
            padding: EdgeInsets.only(top:70, left: 10, right: 10, bottom: 10),//BoxDecoration
            child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                children:[
              Image.asset("assets/logofront.png",
              height: 60, width: 60,),
             ListTile(title: Text(
               restroname==""?"Billing Coach":restroname,
               style: TextStyle(fontSize: 18),
             ),subtitle: Container(padding: EdgeInsets.only(top:6),
               child:Text(userid,
               style: TextStyle(fontSize: 16)),
             ) ,)
            ]),
          ),
          Divider(height: 2,),
          ListTile(
            leading:  Icon(Icons.payment_outlined),
            title: const Text('Subscription'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>SubscriptionModule(ccid:userid)));//Subscribetoapp()
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: const Text('Register as a supplier'),
            onTap: ()async {
             await getsupplier(userid);
             Navigator.push(context, MaterialPageRoute(builder: (context) => Supplierdetails()));
            },
          ),
          ListTile(
            leading: Icon(Icons.pending_actions_outlined),
            title: const Text('Payment Records'),
            onTap: () async {
    /*  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
              String utcTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 5,
                  channelKey: 'scheduled',
                  title: 'wait 5 seconds to show',
                  body: 'now is 5 seconds later',
                  wakeUpScreen: true,
                  category: NotificationCategory.Alarm,
                ),
                schedule: NotificationInterval(
                    interval: 5,
                    timeZone: localTimeZone,
                    preciseAlarm: true,
                    // timezone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
            ));*/
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentRecordScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.check_circle_outlined),
            title: const Text('Completed orders'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteOrderScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: const Text('Deleted orders'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DeletedOrderScreen()));
            },
          ),
          ListTile(
            leading:  Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));
            },
          ),
          ListTile(
              leading:  Icon(Icons.supervisor_account),
              title: const Text('Invite friend'),
              onTap: () {
                Share.share(link);
              }
          ),
      Divider(height: 2,),
      ExpansionTile(
          title: Text("About Us"),
      children:[ ListTile(
          leading:  Icon(Icons.info),
          title: const Text('About us'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Aboutus()));
          }
      ),
        ListTile(
            leading:  Icon(Icons.policy_outlined),
            title: const Text('Privacy policy'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Policy()));
            }
        ),]
      ),
      Divider(height: 2,),
          ListTile(leading: Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {CheckUserConnection();
            // opendialog(context);
            final userPool = CognitoUserPool(
              'ap-south-1_8euTR5YQA',
              '59jiqdmbtdabj6tqrd7ce4u796',
            );
            final cognitoUser = CognitoUser(userid, userPool);
            await cognitoUser.signOut().whenComplete(() async{
              // Remove data for the 'counter' key.
              final SharedPreferences prefs = await preferences;
              final success = await prefs.remove('user_Id');
              runApp(LoginScreen());});
            },
          ),
          SizedBox(height: 10,),
          Container(width: double.infinity,child:Center(child:Text('BY DA Developers')))
        ],
      ),
    ),
        bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: pageIndex,
        height:50.0,
        items: <Widget>[Icon(Icons.category, size: 30,),
          Icon(Icons.people, size: 30,),
          Icon(Icons.home, size: 30,),
          Icon(Icons.currency_rupee_sharp, size: 30,),
          Icon(Icons.pending_actions, size: 30,),],
        color:   Theme.of(context).primaryColorDark,
        buttonBackgroundColor: Theme.of(context).primaryColorLight,
        backgroundColor:Colors.transparent,
        animationCurve: Curves.easeInOutCirc,
        animationDuration: Duration(milliseconds: 100),
             onTap: (index) async {
              await getuserdetails();
              await getsupplier(userid);
               // await getsubscription(context, userid);
               setState(() {
                 pageIndex=index;
               });
             },
             letIndexChange: (index) => true, ),
      ),
    );
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


