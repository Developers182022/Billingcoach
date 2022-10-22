import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:toggle_list/toggle_list.dart';
import '../models/CompletedOrderItems.dart';
import '../models/CompletedOrders.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'HomePage.dart';
import 'Notifications.dart';
import 'login/Login.dart';
import 'print_order.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class CompleteOrderScreen extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const CompleteOrderScreen({Key? key}) : super(key: key);
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
            home: const CompleteOrdersPage()
          );
        });
  }
}
class CompleteOrdersPage extends StatefulWidget {
  const CompleteOrdersPage({Key? key}) : super(key: key);


  @override
  State<CompleteOrdersPage> createState() => _itemPageState();
}

class _itemPageState extends State<CompleteOrdersPage> {
  bool ActiveConnection = false;
  String T = "";
  var doc;
  var completelist=[];
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
  late  final List<String> ordercount = <String>[];
  late String userid="";
  List<String> orderid= <String>[];
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String restroname="", username="", suppliername="", areacode="", profileimg="";

  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  Future<void> getcompletelist(us)async{
    var url= Uri.https(completeorderapi, 'Completeorders/completeorders',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if(jnResponse['user_id']==us){
          setState(() {
            completelist.add(jnResponse);
          }); }
      }
    }
  }
  getcompleteitemlist(order)async{
    var deleteditmelist=[];
    var url= Uri.https(completeorderitemapi, 'CompleteOrderItem/completeorderitems',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if(jnResponse['user_id']==userid && jnResponse['order_id']==order){
          deleteditmelist.add(jnResponse);
        }
      }
      return deleteditmelist;
    }
  }
  Future<void> getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      getcompletelist(counter);
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
            username = jsonResponse['username'].toString();
            suppliername = jsonResponse['supplier_name'].toString();
          });}
      }
    }
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar:  AppBar(  backgroundColor:Theme.of(context).primaryColorDark,
            leading: TextButton(child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor)),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));}, ),
            title: Text("Completed Orders",style: TextStyle(color:Theme.of(context).primaryColor,
                fontSize: 22, fontWeight: FontWeight.bold)),
         /* actions: [ PopupMenuButton(
            icon:Icon(Icons.more_vert, color:Theme.of(context).primaryColor,),
            itemBuilder: (_) {
                return [
                  PopupMenuItem(child:  TextButton(onPressed: (){CheckUserConnection();
                  setState((){
                    doc=Amplify.DataStore.query(CompletedOrders.classType,
                        where:CompletedOrders.USER_ID.eq(userid),
                        sortBy: [CompletedOrders.DATE.descending()]);
                  });
                  }, child: Row(children: [
                    Icon(Icons.account_balance_wallet_outlined, color: Colors.white,),
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
                          doc=Amplify.DataStore.query(CompletedOrders.classType,
                            where:CompletedOrders.USER_ID.eq(userid).and(CompletedOrders.DATE.eq(formattedDate)) ,
                          ); });

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
                        doc=Amplify.DataStore.query(CompletedOrders.classType,
                          where:CompletedOrders.USER_ID.eq(userid).and(CompletedOrders.DATE.eq(formattedDate)) ,
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
                          doc=Amplify.DataStore.query(CompletedOrders.classType,
                            where:CompletedOrders.USER_ID.eq(userid).and(CompletedOrders.DATE.eq(formattedDate)) ,
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
                       doc=Amplify.DataStore.query(CompletedOrders.classType,
                        where:CompletedOrders.USER_ID.eq(userid).and(CompletedOrders.DATE.between(DateFormat("yyyy-MM-dd").format(newDateRange.start),
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
                        doc=Amplify.DataStore.query(CompletedOrders.classType,
                            where:CompletedOrders.USER_ID.eq(userid),
                            sortBy: [CompletedOrders.DATE.descending()]); });
                      }, child: Row(children: [
                        Icon(Icons.calendar_today, ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Sort By date".tr(),),
                      ],))),
                      ListTile(
                        title: TextButton(onPressed:(){CheckUserConnection();
                          setState((){
                          doc=Amplify.DataStore.query(CompletedOrders.classType,
                          where:CompletedOrders.USER_ID.eq(userid),
                          sortBy: [CompletedOrders.TOTAL.descending()]);
                          });
                          },
                          child:Row(children: [
                                Icon(Icons.money, ),
                                SizedBox(
                                width: 10,
                                ),
                                Text("Sort by price".tr()),
                                ],), )),
                      ListTile(title: TextButton(onPressed: (){CheckUserConnection();
                      setState((){
                        doc=Amplify.DataStore.query(CompletedOrders.classType,
                            where:CompletedOrders.USER_ID.eq(userid),
                            sortBy: [CompletedOrders.TIME.descending()]);
                      });
                      }, child: Row(children: [
                        Icon(Icons.alarm,),
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

        ),
        body:RefreshIndicator(onRefresh: ()async{getcompletelist(userid);},
            child: completelist.isNotEmpty?Container(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: ToggleList(
                  divider: const SizedBox(height: 10),
                  toggleAnimationDuration: const Duration(milliseconds: 400),
                  scrollPosition: AutoScrollPosition.begin,
                  trailing: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.expand_more),
                  ),
                  children: List.generate(completelist.length, (index) => ToggleListItem(//parent list
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                      child:ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading:Column(crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('Token no  ${completelist[index]['token_no'].toString()}',
                              style:Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 14),
                            ),],),
                        trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:[Text(completelist[index]['date'].toString(),  style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontSize: 11),),
                              Text(completelist[index]['time'].toString(),  style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontSize: 11),)]),
                      ),),//parent listitems
                    content: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ Container(//color:Colors.grey.withOpacity(.5),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(margin: EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 100),
                                  child:Text("Payment Mode", style: TextStyle(fontSize: 15),)),
                              Container(
                                margin: EdgeInsets.only(right: 20, top: 8, bottom: 8),
                                child: Text(completelist[index]['payment_mode'].toString(), style: TextStyle(fontSize: 15),),),
                            ],),),
                          FutureBuilder<List>(
                            future: getcompleteitemlist(completelist[index]['order_id']),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              else if (snapshot.hasData || snapshot.data != null) {
                               return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                                          elevation: 4,
                                          child: ListTile(
                                            title: Row(children: [Container(width:120,child:Text(snapshot.data![i].item_name.toString())) ,
                                              SizedBox(width:10,),Text("₹"+snapshot.data![i].item_total.toString()), ],),
                                            subtitle: Row(children:[Container(width:120,child:Text("₹"+snapshot.data![i].item_price.toString()+"/"+snapshot.data![i].item_unit.toString())),
                                              SizedBox(width: 10,),Text(snapshot.data![i].item_quantity.toString()!=""?"Qty: "+snapshot.data![i].item_quantity.toString():"🕝 "+snapshot.data![i].rented_duration.toString()+"/"+snapshot.data![i].item_unit.toString()), ]),
                                            trailing: IconButton(icon:Icon(Icons.delete), onPressed: (){},),

                                          )
                                      );
                                    });
                              }
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                           // color: Colors.white,
                            height: 2,
                            thickness: 2,
                          ),
                          Container(width: double.maxFinite,
                            color:Colors.grey.withOpacity(.5),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(margin: EdgeInsets.only(left: 20, top: 6, right: 20),
                                    child:Text("Additional Charges ₹${completelist[index]['additional_amount'].toString()}", style: TextStyle(fontSize:16),)),
                                Container(margin: EdgeInsets.only(left: 20, top: 6, right: 20),
                                    child:Text("Discount amount ₹${completelist[index]['discount_amout'].toString()} "
                                        "(${completelist[index]['discount_percent'].toString()}%)", style: TextStyle(fontSize: 16),)),
                                Container(margin: EdgeInsets.only(left: 20, top: 6, bottom: 6, right: 20),
                                    child:Text("Total ₹${completelist[index]['total'].toString()}", style: TextStyle(fontSize: 16),)),
                                ],),),
                          const Divider(
                            // color: Colors.white,
                            height: 2,
                            thickness: 2,
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 32.0,
                            buttonMinWidth: 90.0,
                            children: [
                              TextButton(
                                onPressed: () async {CheckUserConnection();
                                  String mode=completelist[index]['payment_mode'].toString();
                                  List<String> childitemlist=[];
                                  List<String> childitempricelist=[];
                                  List<String> childitemtotallist=[];
                                  List<String> childitemidlist=[];
                                  List<String> childitemquantitylist=[];
                                  var item=completelist[index]['order_id'];

                                var url= Uri.https(completeorderitemapi, 'CompleteOrderItem/completeorderitems',);
                                var response= await http.get(url );
                                if(response.body.isNotEmpty){
                                  var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
                                  for(int i=0; i<tagObjsJson.length; i++) {
                                    var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                                    if(jnResponse['user_id']==userid && jnResponse['order_id']==completelist[index]['order_id']){
                                      childitemlist.add(jnResponse['item_name'].toString());
                                      childitempricelist.add(jnResponse['item_price'].toString());
                                      childitemquantitylist.add(jnResponse['item_quantity'].toString());
                                      childitemtotallist .add(jnResponse['item_total'].toString());
                                      childitemidlist    .add(jnResponse['item_id'].toString());
                                    }
                                  }
                                }
                                  double ttl= double.parse(completelist[index]['total'].toString());
                                await FirebaseAnalytics.instance.logEvent(
                                  name: "took_print_of_completed_order",
                                  parameters: {
                                    "user_id":  userid,
                                  },
                                );
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>  Printorder(completelist[index]['order_id'].toString(),completelist[index]['token_no'].toString(),
                                        completelist[index]['date'], time, childitemlist, childitempricelist,childitemquantitylist,childitemtotallist ,
                                        ttl, mode, completelist[index]['additional_amount'].toString(), completelist[index]['discount_amout'].toString())),
                                  );
                                },
                                child: Column(
                                  children: const [
                                    Icon(Icons.print, color: Colors.blue,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text('Print', style: TextStyle(color: Colors.blue,),),],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    headerDecoration: const BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    expandedHeaderDecoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),),
                  ),
                  ),),
        ): Center(child:
            Column(children:[
              SizedBox(height: 15,),
              Lottie.asset("assets/animations/nocompletedorders.json", height: 250, width: 300),
              Container(padding: EdgeInsets.all(25),
                child:Text("You haven't completed any order yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),),
              SizedBox(height: 10,),
            ]))),
      ),);
  }
}
