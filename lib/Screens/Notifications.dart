
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:uuid/uuid.dart';
import '../Screens/Orders.dart';
import '../main.dart';
import '../models/Notifications.dart';
import '../models/ReceivedRequests.dart';

import '../reusable_widgets/apis.dart';
import '../reusable_widgets/namedIcon.dart';
import 'HomePage.dart';
import 'PendingRequest.dart';
import 'login/Login.dart';
class NotificationScreen extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const NotificationScreen({Key? key}) : super(key: key);
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
            home: const NotificationsPage(user: "userid"),
          );
        });
  }
}
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key, required this.user}) : super(key: key);

  final String user;

  @override
  State<NotificationsPage> createState() => _NotificationState();
}
class _NotificationState extends State<NotificationsPage> {
  bool ActiveConnection = false;
  String T = "";
  int reqcount=0;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
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
  var doc;
  var notificationlist=[];
  var totalexpanse=0;
   String userid="";
   var hm;
  String restroname="", phoneno="", address="", areacode="", email="";
  final reqkey= GlobalKey();
  @override
  void initState() {
    CheckUserConnection();
    getuserdetails();super.initState();
  }


 Future<void> getuserdetails() async {
   final SharedPreferences prefs = await preferences;
   var counter = prefs.getString('user_Id');
   if(counter!=null){ await FirebaseAnalytics.instance.logEvent(
     name: "show_notification",
     parameters: {
       "user_id":  userid,
     },
   );
     setState((){userid=counter;});
     getrequestscount(counter);
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
     }
     await getnotificationlist(counter);
   }
   else{runApp(LoginScreen());}
 
  }
  Future<void> getnotificationlist(us)async{
    var url= Uri.https(notifyapi, 'Notification/notifications',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        notificationlist.add(jnResponse);
      });
      }
      // print(jnResponse['item_name']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
        leading: TextButton(child:Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey,width: 1)),
        padding:EdgeInsets.all(4),
        child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor)),onPressed: (){ //sendPushMessage("f8HDlfRRQkq7DQRjXp5s3l:APA91bG06z4-F_QbfHuGPzf5b3UAq-DIf0kkx8UHp6mkwLEW6IcEgawRtifNylS8XpY3gM2kMN3XawxJxPpAq51inhaskeA_IyTyoLp2QNsm2K6vHqfi9fg3LQvDYhHe84npkWK3N1e3", "$supliername has accepted you as a supplier.", "");
          Navigator.push(context, MaterialPageRoute(builder: (context) => IncompleteOrders()));}, ),
        title: Text("Notifications", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),),
      body:RefreshIndicator(onRefresh: ()async{
        setState((){
        getrequestscount(userid);});},
          child:Column(children: [
         Container(child:Card(child: ListTile(onTap: ()async{print(reqcount);
         await FirebaseAnalytics.instance.logEvent(
           name: "show_requests",
           parameters: {
             "user_id":  userid,
           },
         );
          Navigator.push(context, MaterialPageRoute(builder: (context) => PendingRequests()));
    },
          leading:Icon(Icons.account_circle_rounded),
      title: Text("Supplier request", style: TextStyle(fontSize: 18),),
          trailing:NamedIcon(
            text: 'Requests',
            iconData: Icons.person_add,
            notificationCount: reqcount,
            onTap: () {  Navigator.push(context, MaterialPageRoute(builder: (context) => PendingRequests()));},
          ),

        ),)
        ),
        Container(height: 600,
        // margin: EdgeInsets.only(bottom: 60, ),
        child:SingleChildScrollView(scrollDirection: Axis.vertical,
          child: /* FutureBuilder<List<Notifications>>(
            future:  doc,
            builder: (context, snapshot) {totalexpanse=0;
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          else if (snapshot.hasData || snapshot.data != null) {
            return*/ ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: notificationlist.length,
                itemBuilder: (BuildContext context, int index) {

                  return  Card(
                    elevation: 4,
                    child: ListTile(
                        title: Container(width: 120,
                          child: Text(notificationlist[index]['title'].toString(), style: TextStyle(),),),
                        subtitle: Text(notificationlist[index]['subtitle'].toString()),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(notificationlist[index]['date'].toString()),
                              Text(notificationlist[index]['time'].toString()),
                            ]
                        )
                    ),
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
        ),*/)
      ),],))
    );
    // );
  }

   getrequestscount(String userid) async {
       List<ReceivedRequests> ReceivedRequestss = await Amplify.DataStore.query(ReceivedRequests.classType,
       where:ReceivedRequests.USER_ID.eq(userid) );
         setState((){
           reqcount=ReceivedRequestss.length;
          });
   }
}
