import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:uuid/uuid.dart';
import '../models/DeletedStockReport.dart';
import '../models/Expanse.dart';
import '../models/ExpanseRecord.dart';
import '../models/PaymentRecords.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../reusable_widgets/apis.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'Notifications.dart';
import 'Profit.dart';
import 'Stock.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login/Login.dart';
class UserStockRecord extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const UserStockRecord({Key? key, this.stid}) : super(key: key);
  final stid;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'DashBoard',
            theme: ThemeData(primarySwatch: Colors.blue,
                primaryColor: Colors.black87,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home:/* FirebaseAuth.instance.currentUser == null
                ? LoginScreen()
                : */ UserStockRecordPage(stockid: stid),
          );
        });
  }
}

class UserStockRecordPage extends StatefulWidget {
   UserStockRecordPage({Key? key,this.stockid}) : super(key: key);
final stockid;

  @override
  State<UserStockRecordPage> createState() => _itemPageState(title: stockid);
}

class _itemPageState extends State<UserStockRecordPage> {
   _itemPageState({this.title});
  final title;
   var removed= "removed";
  var doc;

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
   final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

   String userid="", complete= "complete";
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final _formKey = GlobalKey<FormState>();
  var stockreportlist=[], datetimelist=[];
  DateTime _dateTime= DateTime(2015);
  bool addstockbtn= true, addstock= false, updatestock=false, updatestockbtn= true;
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String email="";
  var progress=false;
  String restroname="", username="", suppliername="", areacode="", imgprofile="", stockname="";
   getuserdetails() async {
     final SharedPreferences prefs = await preferences;
     var counter = prefs.getString('user_Id');
     if(counter!=null){
       setState((){userid=counter;}); //getstockname(title,counter);
       await getstockrecordlist(counter);}
     else{runApp(LoginScreen());}

   }
   getstockrecordlist(useid)async{
     var url= Uri.https(stockapi, 'StockItemList/stockitem',{'id':title});
     var response= await http.get(url );
     var tagObjsJson = jsonDecode(response.body)as Map<String, dynamic>;
     setState((){stockname= tagObjsJson['stock_name'];});
     var surl= Uri.https(stockrecapi, 'Stockrecord/stockrecords',);
     var sresponse= await http.get(surl );
     datetimelist=[];
     var stagObjsJson = jsonDecode(sresponse.body)['products'] as List;
     for(int i=0; i<stagObjsJson.length; i++){
       var jnResponse = stagObjsJson[i] as Map<String, dynamic>;
       if(jnResponse['user_id']==useid && jnResponse['stock_id']==tagObjsJson['stock_id']){
         setState((){stockreportlist.add(jnResponse);
         datetimelist.add(DateFormat("yyyy-MM-dd HH:mm:ss").parse(jnResponse['date']+" "+jnResponse['time']));
         });
       }
     }print(stockreportlist.length);
     return stockreportlist;
   }
  @override
   initState()   {CheckUserConnection();
    getuserdetails();
    print("object-- $title");

  super.initState();
  }
   setdocument(){stockreportlist=[];
  getstockrecordlist(userid);
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Theme.of(context).primaryColorLight,
        leading: IconButton(icon:Icon(Icons.arrow_back,),onPressed: (){ //sendPushMessage("f8HDlfRRQkq7DQRjXp5s3l:APA91bG06z4-F_QbfHuGPzf5b3UAq-DIf0kkx8UHp6mkwLEW6IcEgawRtifNylS8XpY3gM2kMN3XawxJxPpAq51inhaskeA_IyTyoLp2QNsm2K6vHqfi9fg3LQvDYhHe84npkWK3N1e3", "$supliername has accepted you as a supplier.", "");
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserStock()));}, ),
        actions: [
          Container(margin: EdgeInsets.only(top: 20, right: 10),
            child: Text("The Billing Coach", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),),
     /*     PopupMenuButton(
            itemBuilder: (_) {
              return [

                PopupMenuItem(child: ExpansionTile(title: Text("Filter"),
                  children: [
                    ListTile(title:    TextButton(onPressed: (){CheckUserConnection();
                    setState((){
                      doc=Amplify.DataStore.query(StockRecord.classType,
                          where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)),
                          sortBy: [StockRecord.DATE.descending(),
                            StockRecord.TIME.descending(), ]
                      );});
                    }, child: Row(children: [
                      Icon(Icons.account_balance_wallet_outlined, ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("All".tr(), style: TextStyle(fontSize: 15), ),
                    ],)),
                    ),
                    ListTile(title:   TextButton(onPressed: () {
                      setState(() {CheckUserConnection();
                      _dateTime = DateTime.now();
                      String formattedDate = DateFormat('yyyy-MM-dd').format(_dateTime);
                      print(formattedDate);
                      doc=Amplify.DataStore.query(StockRecord.classType,
                          where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)).and(StockRecord.DATE.eq(formattedDate)),);  });
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
                      doc=Amplify.DataStore.query(StockRecord.classType,
                        where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)).and(StockRecord.DATE.eq(formattedDate)),); });
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
                        doc=Amplify.DataStore.query(StockRecord.classType,
                          where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)).and(StockRecord.DATE.eq(formattedDate)),); });
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
                    doc=Amplify.DataStore.query(StockRecord.classType,
                      where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title))
                          .and(StockRecord.DATE.between(DateFormat("yyyy-MM-dd").format(newDateRange.start),
                          DateFormat("yyyy-MM-dd").format(newDateRange.end))),);});

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
                      doc=Amplify.DataStore.query(StockRecord.classType,
                          where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)),
                          sortBy: [StockRecord.DATE.descending(),]
                      ); });
                    }, child: Row(children: [
                      Icon(Icons.calendar_today, ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Sort By date".tr(),),
                    ],))),
                    ListTile(title: TextButton(onPressed: (){CheckUserConnection();
                    setState((){
                      doc=Amplify.DataStore.query(StockRecord.classType,
                          where:StockRecord.USER_ID.eq(userid).and(StockRecord.STOCK_ID.eq(title)),
                          sortBy: [StockRecord.TIME.descending(), ]
                      );
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
          )*/
        ],
        title: Text(stockname, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      ),

      body:RefreshIndicator(onRefresh: ()async{},
            child: Container(height: 600,
                child:/*FutureBuilder<List<StockRecord>>(
                  future:  doc,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      else if (snapshot.hasData || snapshot.data != null) {
                        return*/ ListView.builder(
                            shrinkWrap: true,
                            itemCount: stockreportlist.length,
                            itemBuilder: (BuildContext context, int indx) {
                              return  Card(
                                // elevation: 4,
                                child: ListTile(onLongPress: ()async{
                                  if(double.parse(stockreportlist[indx]['stock_quantity'].toString())>0){
                                  showDialog(context: context, builder: (BuildContext context){
                                    var progress=false;
                                   return  StatefulBuilder(builder:  (BuildContext context, setState){
                                     return AlertDialog(
                                       shape: RoundedRectangleBorder(
                                           borderRadius: BorderRadius.circular(10)),
                                       title: Text("Are you sure you wanna delete this stock history."),
                                       actions: [progress==true? Center(child:Container(padding: EdgeInsets.all(20),child:CircularProgressIndicator()))
                                        : Row(children: [ SizedBox(width: 10,),
                                         Container(padding: EdgeInsets.all(10),child: TextButton(child:Text("Cancel"),
                                           onPressed: (){ Navigator.of(context, rootNavigator: true).pop(context);},),),
                                         SizedBox(width: 60,),
                                         Container(padding: EdgeInsets.all(10),
                                             child: TextButton(onPressed: () async{
                                               final maxDate = datetimelist.reduce((a,b) => a.isAfter(b) ? a : b);
                                             print(maxDate);
                                             if((stockreportlist[indx]['date']+" "+stockreportlist[indx]['time'])==DateFormat("yyyy-MM-dd hh:mm:ss").format(maxDate)){
                                               setState(() {
                                                 progress=true;
                                               });
                                               var url= Uri.https(stockrecapi, 'Stockrecord/stockrecord',{'id':stockreportlist[indx]['id']});
                                               var delres= await http.delete(url, headers: <String, String>{
                                                 'Content-Type': 'application/json; charset=UTF-8',
                                               },
                                                   body: jsonEncode(<String, String>{
                                                     "id":stockreportlist[indx]['id'],}));
                                               if(delres.statusCode==200){
                                                 var url = Uri.https(stockapi, '/StockItemList/stockitem', {'id':userid+stockreportlist[indx]['stock_name']});
                                                 var res= await http.get(url);
                                                 if(res.body.isNotEmpty){
                                                   var tagObjsJson = jsonDecode(res.body) as Map<String, dynamic>;
                                                 var response = await http.post(url,   headers: <String, String>{
                                                   'Content-Type': 'application/json; charset=UTF-8',
                                                 },
                                                   body: jsonEncode(<String, String>{
                                                     "id":tagObjsJson['id'],
                                                     "user_id": tagObjsJson['user_id'],
                                                     "stock_id":tagObjsJson['stock_id'],
                                                     "stock_name": tagObjsJson['stock_name'],
                                                     "stock_quantity": (double.parse(tagObjsJson['stock_quantity'].toString())-
                                                   double.parse(stockreportlist[indx]['stock_quantity'].toString())).toString(),
                                                     "stock_investment": tagObjsJson['selling_price_per_unit'],
                                                     "selling_price_per_unit": tagObjsJson['selling_price_per_unit'],
                                                     "constant_quantity":(double.parse(tagObjsJson['constant_quantity'].toString())-double.parse(stockreportlist[indx]['stock_quantity'].toString())).toString(),
                                                     "stock_status": tagObjsJson['stock_status'],
                                                     "stock_unit": tagObjsJson['stock_unit'],
                                                   }),);
                                                 if(response.statusCode==200){
                                                   var exurl = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord', {'id':userid+stockreportlist[indx]['stock_record_id'],});
                                                   var repso= await http.get(exurl);
                                                   if(repso.body.isNotEmpty){
                                                     var jsResponse = convert.jsonDecode(repso.body) as Map<String, dynamic>;
                                                     final http.Response exresponse = await http.post(
                                                         exurl,
                                                         headers: <String, String>{
                                                           'Content-Type': 'application/json; charset=UTF-8',
                                                         },
                                                         body: jsonEncode(<String, String>{
                                                           "id":jsResponse['id'],
                                                           "user_id": jsResponse['user_id'],
                                                           "expanse_id": jsResponse['expanse_id'],
                                                           "expanse_record_id":jsResponse['expanse_record_id'],
                                                           "expanse_name": jsResponse['expanse_name'],
                                                           "description": jsResponse['description'],
                                                           "investment": jsResponse['investment'],
                                                           "date": jsResponse['date'],
                                                           "time": jsResponse['time'],
                                                           "status": removed
                                                         })
                                                     );
                                                     print(DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(stockreportlist[indx]['date'])));
                                                     if(exresponse.statusCode==200){
                                                       var payurl = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord', {"id":userid+stockname,});
                                                       var pyresponse= await http.get(payurl );
                                                       var tagObjsJson = jsonDecode(pyresponse.body)as Map<String, dynamic>;
                                                       if(tagObjsJson.isNotEmpty){
                                                         var payresponse = await http.post(
                                                             payurl,
                                                             headers: <String, String>{
                                                               'Content-Type': 'application/json; charset=UTF-8',
                                                             },
                                                             body: jsonEncode(<String, String>{
                                                               "id":tagObjsJson["id"],
                                                               "user_id": tagObjsJson["user_id"],
                                                               "record_id": tagObjsJson['record_id'],
                                                               "token_no": tagObjsJson['token_no'],
                                                               "order_id": tagObjsJson['order_id'],
                                                               "client_id":tagObjsJson['client_id'],
                                                               "received_amount": tagObjsJson['received_amount'],
                                                               "date": tagObjsJson['date'],
                                                               "time": tagObjsJson['time'],
                                                               "payment_mod": tagObjsJson['payment_mod'],
                                                               "sent_amount": tagObjsJson['sent_amount'],
                                                               "description": tagObjsJson['description'] +"\n\tCANCELLED\t"
                                                             }));}
                                                       print("expanse record deleted ${exresponse.statusCode}");
                                                       var exurl = Uri.https(expanseapi, 'Expanse/expanse' , {"id":userid+ (DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(stockreportlist[indx]['date']))).toString()});
                                                       var repo= await http.get(exurl);
                                                       var jsonResponse = convert.jsonDecode(repo.body) as Map<String, dynamic>;
                                                       final http.Response eresponse =  await http.post(
                                                         exurl,
                                                         headers: <String, String>{
                                                           'Content-Type': 'application/json; charset=UTF-8',
                                                         },
                                                         body: jsonEncode(<String, String>{
                                                           "id":jsonResponse['id'],
                                                           "user_id": jsonResponse['user_id'],
                                                           "expanse_id": jsonResponse['expanse_id'],
                                                           "expanse": (double.parse(jsonResponse['expanse'])-double.parse(stockreportlist[indx]['stock_investment']) ).toString(),
                                                           "status": jsonResponse['status'],
                                                           "date":jsonResponse['date']
                                                         }),);
                                                       if(eresponse.statusCode==200){
                                                         print("expanse updated ${eresponse.statusCode}");
                                                       }
                                                       var url= Uri.https(profitapi, 'Profit/profit',{'id':userid+ (DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(stockreportlist[indx]['date']))).toString()});
                                                       var response= await http.get(url );
                                                       if(response.body.isNotEmpty){   print(" profit record exoist ${response.body}")      ;
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
                                                             "profit": (double.parse(jsonesponse['profit'])+double.parse(stockreportlist[indx]['stock_investment'])).toString(),
                                                             "earned": jsonesponse['earned'],
                                                             "expanse": (double.parse(jsonesponse['expanse'])-double.parse(stockreportlist[indx]['stock_investment'])).toString(),
                                                             "date": jsonesponse['date'] ,
                                                             "month":jsonesponse['month'] ,
                                                             "year": jsonesponse['year']
                                                           }));
                                                       print("profitupate  ${esponse.statusCode}");
                                                       var mourl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id':userid+ (DateFormat("yMMMM").format(DateFormat("yyyy-MM-dd").parse(stockreportlist[indx]['date']))).toString()});
                                                       var mpresponse= await http.get(mourl );
                                                       if(mpresponse.body.isNotEmpty) {
                                                         var jsonesponse = convert.jsonDecode(mpresponse.body) as Map<String, dynamic>;
                                                         var esponse = await http.post(
                                                             mourl,
                                                             headers: <String, String>{
                                                               'Content-Type': 'application/json; charset=UTF-8',
                                                             },
                                                             body: jsonEncode(<String, String>{
                                                               "id":jsonesponse['id'],
                                                               "user_id": jsonesponse['user_id'],
                                                               "monthly_profit_id": jsonesponse['monthly_profit_id'],
                                                               "monthly_profit": (double.parse(jsonesponse['monthly_profit'].toString())+double.parse(stockreportlist[indx]['stock_investment'])).toString(),
                                                               "Earned_amount":jsonesponse['Earned_amount'],
                                                               "Expanse_amount": (double.parse(jsonesponse['Expanse_amount'].toString())-double.parse(stockreportlist[indx]['stock_investment'].toString()) ).toString(),
                                                               "month": jsonesponse['month'],
                                                               "year": jsonesponse['year']
                                                             }));
                                                         if(esponse.statusCode==200){
                                                           setdocument();
                                                               setState((){progress=true;});
                                                         }

                                                       }
                                                       }
                                                     }}
                                                 }
                                                 }
                                               }
                                             }
                                               else{Fluttertoast.showToast(msg: "Stock has been update after this record. you can only delete latest record.");}
                                             Navigator.of(context, rootNavigator: true).pop(context); },
                                         child: Text("Yes"),)),],)],
                                     );});});}else{
                                    Fluttertoast.showToast(msg: "Stock report cannot be deleted.");
                                  }
                                  },
                                  title: Row(children: [Text("Investment : "), Container(
                                    width: 80,child:Text("₹"+stockreportlist[indx]['stock_investment'].toString()),),
                                  ],),
                                  subtitle:Row(children:[Text("Quantity: "),
                                    Container(
                                      child:Text(stockreportlist[indx]['stock_quantity'].toString()+stockreportlist[indx]['stock_unit'].toString()),),]),
                                  trailing:Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(stockreportlist[indx]['date'].toString()),
                                        Text(stockreportlist[indx]['time'].toString()),
                                      ]
                                  ),
                                ),
                              );
                            })/*;
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      );
                    },
                  )*/,),
            ),
      );
  }

   deletepaymentrecord(String id)async{
     List<PaymentRecords> PaymentRecordss = await Amplify.DataStore.query(PaymentRecords.classType,
         where:PaymentRecords.USER_ID.eq(userid).and(PaymentRecords.RECORD_ID.eq(id)));
     if(PaymentRecordss.isNotEmpty){
       await Amplify.DataStore.delete(PaymentRecordss[0]);
     }

   }
}



