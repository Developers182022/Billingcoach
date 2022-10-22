import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ModelProvider.dart';
import '../reusable_widgets/apis.dart';
import 'HomePage.dart';
import 'Notifications.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class PaymentRecordScreen extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const PaymentRecordScreen({Key? key}) : super(key: key);
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
            home: const PaymentRecordPage(),
          );
        });
  }
}
class PaymentRecordPage extends StatefulWidget {
  const PaymentRecordPage({Key? key,}) : super(key: key);
  @override
  State<PaymentRecordPage> createState() => _PaymentRecordState();
}
class _PaymentRecordState extends State<PaymentRecordPage> {

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
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  var doc;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String date="";
  String time="";
  String userid= "";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String restroname="", phoneno="", address="", areacode="", profileimg="";
  bool fetched= false;
 var paymentlist=[];
  var records=[];
  @override
  void initState() {
    CheckUserConnection();
    getcurrentuser();
    super.initState();
  }
  Future <void>getpaymentlist(us)async{
    await FirebaseAnalytics.instance.logEvent(
      name: "show_payment_record",
      parameters: {
        "user_id":  userid,
      },
    );
    var url= Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecords',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        // if(jnResponse['user_id']==us){
        setState(() {
          paymentlist.add(jnResponse);
        });

      }//}
    }
   

  }
  Future<void> getcurrentuser()async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      getpaymentlist(counter);
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
             areacode = jsonResponse['supplier_name'].toString();
          });}
      }
    }
    else{runApp(LoginScreen());}
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor:Theme.of(context).primaryColorDark,
            leading: TextButton(child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),
              child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor,)),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));}, ),
            title: Text("Payment Record", style:TextStyle(color:Theme.of(context).primaryColor,)),
            /*actions: [     PopupMenuButton(
              icon:Icon(Icons.more_vert, color:Theme.of(context).primaryColor,),
              itemBuilder: (_) {
                  return [
                    PopupMenuItem(child:  TextButton(onPressed: (){CheckUserConnection();
                    setState((){
                      doc=Amplify.DataStore.query(PaymentRecords.classType,
                        where:PaymentRecords.USER_ID.eq(userid) ,
                      );
                    });
                    }, child: Row(children: [
                      Icon(Icons.account_balance_wallet_outlined, ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("All".tr() , style: TextStyle(fontFamily: 'RobotoMono')),
                    ],)
                    )),
                    PopupMenuItem(child: ExpansionTile(title: Text("Filter"),
                      children: [
                        ListTile(title:   TextButton(onPressed: () {
                          setState(() {CheckUserConnection();
                          _dateTime = DateTime.now();
                          String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
                          print(formattedDate);
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                            where:PaymentRecords.USER_ID.eq(userid).and(PaymentRecords.DATE.eq(formattedDate)) ,
                          );  });

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
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                            where:PaymentRecords.USER_ID.eq(userid).and(PaymentRecords.DATE.eq(formattedDate)) ,
                          ); });

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
                            doc=Amplify.DataStore.query(PaymentRecords.classType,
                              where:PaymentRecords.USER_ID.eq(userid).and(PaymentRecords.DATE.eq(formattedDate)) ,
                            ); });
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
                        doc=Amplify.DataStore.query(PaymentRecords.classType,
                          where:PaymentRecords.USER_ID.eq(userid)
                              .and(PaymentRecords.DATE.between(DateFormat("yyyy-MM-dd").format(newDateRange.start),
                              DateFormat("yyyy-MM-dd").format(newDateRange.end))),
                        ); });

                        }, child: Row(children: [
                          Icon(Icons.date_range, ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Filter by date range".tr()),
                        ],))),
                      ],
                    )),
                    PopupMenuItem(child: ExpansionTile(title: Text("Sort"),
                      children: [
                        ListTile(title:TextButton(onPressed: (){CheckUserConnection();
                        setState((){
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                              where:PaymentRecords.USER_ID.eq(userid),
                              sortBy: [PaymentRecords.DATE.descending()]); });
                        }, child: Row(children: [
                          Icon(Icons.calendar_today, ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Sort By date".tr(),),
                        ],))),
                        ListTile(title:   TextButton(onPressed: (){CheckUserConnection();
                        setState((){
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                              where:PaymentRecords.USER_ID.eq(userid),
                              sortBy: [PaymentRecords.RECEIVED_AMOUNT.descending()]);
                        });
                        }, child: Row(children: [
                          Icon(Icons.money, ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Sort by received".tr()),
                        ],)),),
                        ListTile(title:   TextButton(onPressed: (){CheckUserConnection();
                        setState((){
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                              where:PaymentRecords.USER_ID.eq(userid),
                              sortBy: [PaymentRecords.SENT_AMOUNT.descending()]);
                        });
                        }, child: Row(children: [
                          Icon(Icons.money, ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Sort by sent".tr()),
                        ],)),),
                        ListTile(title: TextButton(onPressed: (){CheckUserConnection();
                        setState((){
                          doc=Amplify.DataStore.query(PaymentRecords.classType,
                              where:PaymentRecords.USER_ID.eq(userid),
                              sortBy: [PaymentRecords.TIME.descending()]);
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
              ),
            ],*/
             bottom:Tab(child:Container(child:ListTile(leading: Container(width:100,child:Center(child:Text("Sent", style: TextStyle(fontSize: 18)),)),
               title: Text("Received", style: TextStyle(fontSize: 18)),trailing: Text("date", style: TextStyle(fontSize: 18)),)))
             ),
            body: RefreshIndicator(onRefresh:() async{
              getpaymentlist(userid);},
                child:
                paymentlist.isNotEmpty? ListView.builder(
                          shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: paymentlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              child: ExpansionTile(
                                leading:Container(width: 100, child:Center(child: Text("₹"+paymentlist[index]['sent_amount'].toString(),
                                    style: TextStyle(fontSize: 18, decoration: paymentlist[index]['description'].toString().contains("CANCELLED")?
                                    TextDecoration.lineThrough:TextDecoration.none))),) ,
                                title: Center(child: Text("₹"+paymentlist[index]['received_amount'].toString(), style: TextStyle(fontSize: 18,
                                    decoration: paymentlist[index]['description'].toString().contains("CANCELLED")?
                                    TextDecoration.lineThrough:TextDecoration.none)),),
                                trailing: Column(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(paymentlist[index]['date'].toString()),
                              Text(paymentlist[index]['time'].toString())],),
                                children: [Divider(height: 2,),
                                  Container(width:double.maxFinite, padding: EdgeInsets.all(8),
                                  child: Text("Payment mode: "+ paymentlist[index]['payment_mod'].toString()),),
                            paymentlist[index]['description'].toString().isNotEmpty?
                            Container(width:double.maxFinite, padding: EdgeInsets.all(8), child:
                            Text( paymentlist[index]['description'].toString()),):Container()],
                              ),
                            );
                          }): Center(child:
              Column(children:[
              SizedBox(height: 15,),
            Lottie.asset("assets/animations/paymentrecor.json", height: 250, width: 300),
            SizedBox(height: 10,),
            Text("No records present.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            ]))
            ),
        ));
  }
 }

