import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/ReceivedRequests.dart';
import '../models/SentRequest.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'login/Login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class SentRequests extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SentRequests({Key? key}) : super(key: key);
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
            home:const SentRequestsPage(),
          );
        });
  }
}
class SentRequestsPage extends StatefulWidget {
  const SentRequestsPage({Key? key,}) : super(key: key);
  @override
  State<SentRequestsPage> createState() => _SentRequestsState();
}
class _SentRequestsState extends State<SentRequestsPage> {
  bool ActiveConnection = false;
  String T = "";
  var doc;
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
  String time="";
  String userid= "";
  var sentlist=[];
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String username="", usershpname= "", usersupplier="", usertoken="", useraddress="";
  String itemimage="";
  Future<void>getsentreq(us)async{
    var url= Uri.https(sentreqapi, 'SentRequest/sentrequests',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        sentlist.add(jnResponse);
      });
      }
    }
  }
  Future<void>getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      await getsentreq(counter);
      await FirebaseAnalytics.instance.logEvent(
        name: "show_sent_request",
        parameters: {
          "user_id":  counter,
        },
      );
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
      var response= await http.get(url );
      print(response.body);
      if(response.body.isNotEmpty){
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print("stocklosy-uhgyuj-  ${jsonDecode(response.body)}");
        if (this.mounted) {
          setState(() {
            usershpname = jsonResponse['shop_name'].toString();
            username = jsonResponse['username'].toString();
            usersupplier = jsonResponse['supplier_name'].toString();
          });}
      }}
    else{runApp(LoginScreen());}
  }
  @override
  void initState() {
    CheckUserConnection();
    getuserdetails();
    super.initState();
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
        body:
            RefreshIndicator(onRefresh: ()async{ doc= Amplify.DataStore.query(SentRequest.classType,
                where:SentRequest.USER_ID.eq(userid));
             await getsentreq(userid);
              },
                child:
                sentlist.isNotEmpty?Container(//color: Theme.of(context).primaryColorDark,
          margin: EdgeInsets.only(bottom: 10, ),
          child:SingleChildScrollView(scrollDirection: Axis.vertical,
              child:ListView.builder(
                    shrinkWrap: true,
                    itemCount: sentlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Row(children: [
                            Container(padding: EdgeInsets.only(top: 5),
                              margin: EdgeInsets.only(left: 20),
                              child:Column(mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sentlist[index]['client_shop_name'].toString()),
                                    Container(child:Text(sentlist[index]['client_phone_no'].toString())),]),),
                          ],),
                          subtitle:
                                Container(width: double.maxFinite,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blueAccent.shade100),
                                    child: TextButton(onPressed: () async {
                                      await declineRequest(userid, sentlist[index]['client_id'].toString());
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "cancelled_req_from_sentreq",
                                        parameters: {
                                          "user_id":  userid,
                                        },
                                      );
                                    await getsentreq(userid);},
                                        child: Column(children: [Icon(Icons.person_add_disabled), Text("Cancel request")],))),

                          // onLongPress: ,
                        ),
                      );
                    })),): Center(child:
                Column(children:[
                  SizedBox(height: 15,),
                  Lottie.asset("assets/animations/sentreq.json", height: 250, width: 300),
                  SizedBox(height: 10,),
                  Text("You haven't sent any request yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                ])),),
      ),);
  }
  declineRequest(String uid, String clientid) async {
    var reurl=Uri.https(sentreqapi, 'SentRequest/sentrequest',{
      "id":userid+clientid
    });
    var notsponse = await http.delete(reurl,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id":userid+clientid
      }),);
    if(notsponse.statusCode==200){
      var senturl=Uri.https(receivedreqapi, 'ReceivedRequest/receivedrequest',{
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

