import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:search_choices/search_choices.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toggle_list/toggle_list.dart';
import '../Screens/CustomerPage.dart';
import '../models/CompletedOrderItems.dart';
import '../models/CustomerRecord.dart';
import '../models/PendingOrderItems.dart';
import '../models/PendingPayments.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'SubscriptionModule.dart';
import 'SupplierPage.dart';
import 'login/Login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class PendingPaymentScreen extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const PendingPaymentScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'DashBoard',
              theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                  primaryColor: Colors.black,
                  brightness: Brightness.light,
                  primaryColorDark:Colors.white ),
              darkTheme: ThemeData(
                  primaryColor: Colors.white,
                  brightness: Brightness.dark,
                  primaryColorDark:Colors.black ),
            themeMode: ThemeMode.system,
            home: const PendingPaymentsPage(user: "userid")// :SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class PendingPaymentsPage extends StatefulWidget {
  const PendingPaymentsPage({Key? key, required this.user}) : super(key: key);
  final String user;
  @override
  State<PendingPaymentsPage> createState() => _PendingPaymentsPageState();
}
class _PendingPaymentsPageState extends State<PendingPaymentsPage> {
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
  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String selectedTime = DateFormat("HH:mm:ss").format(DateTime.now());
  List todos = List.empty();
  String name = "";
  final pendingkey= GlobalKey();
  final supplkey= GlobalKey();
  final customkey= GlobalKey();
  final listkey= GlobalKey();
  bool addexpanse=false, addexpansebtn= true;
  var removed= "removed";
  var status= "paid";
  bool visible=true;
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> filteritem = [];
  var expanse_id;
  var totalexpanse=0;
  String? selectedValueSingleMenu;
  String? selectedValueSinglefilter;
  String description = "";
  String investment = "";
  String st="";
  String filtervalue="";
  String inputString = "";
  TextFormField? input;
  TextEditingController myController = TextEditingController();
  String userid= "";
  String? phoneno="";
  var hm;
  late TabController _tabController;
  String restroname="",  address="", areacode="", email="";
  var dd= TextDecoration.none;
  var pendinglist=[];
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  @override
  void initState() {

    CheckUserConnection();
    getuserdetails();
    super.initState();
  }
  Future<void> getpendinglist(us)async{
    var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayments',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        pendinglist.add(jnResponse);
      });
      }
      // print(jnResponse['item_name']);
    }
   /* final py= await Amplify.DataStore.query(PendingPayments.classType,
        where:PendingPayments.USER_ID.eq(us));
    if(pendinglist.isNotEmpty){
    setState((){pendinglist= py;});}*/
  }
  Future<List> getpendingrecordlist(clid)async{
    var pendingrecordlist=[];
    var curl= Uri.https(customerrecordapi, 'CustomerRecords/customerrecords',);
    var cresponse= await http.get(curl );
    var ctagObjsJson = jsonDecode(cresponse.body)['products'] as List;
    print(ctagObjsJson.length);
    for(int i=0; i<ctagObjsJson.length; i++){
      var jnResponse = ctagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==userid && jnResponse['client_id']==clid ){
        setState((){
          pendingrecordlist.add(jnResponse);
        });
      }
    }
    return pendingrecordlist;

  }
  Future<void>getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){  await FirebaseAnalytics.instance.logEvent(
      name: "show_pending_payment",

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
            restroname = jsonResponse['shop_name'].toString();
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
      await getpendinglist(counter);}
    else{runApp(LoginScreen());}
  }
  late String dropdownvalue;
  List dataList = [];
  String _selectedDate="";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  TextEditingController filtercontroller= TextEditingController();
  String? selectedValueSingleDialog;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child:Scaffold(
      appBar: AppBar(backgroundColor:Theme.of(context).primaryColorDark,
          leading:TextButton(onPressed:(){Scaffold.of(context).openDrawer();},child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),child:
          Icon(Icons.menu,color:Theme.of(context).primaryColor,))),
          actions: [
            Container(margin: EdgeInsets.only(top: 10, right: 10),
              child: Text("The Billing Coach", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic,
                color:Theme.of(context).primaryColor,),),)
          ],
          bottom:TabBar( //controller: _tabController,
            labelColor:Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
            onTap: (index){
    pendinglist=[];
                getpendinglist(userid);
            
            },
            tabs: [
         Tab(icon: Icon(Icons.pending_actions_outlined), text: 'Pending \nPayments'),
         Tab(icon: Icon(Icons.store), text: 'Supplier \nRecords'),
            Tab(icon: Icon(Icons.person), text: 'Customer \nRecords'),
        ],
        )
      ),
      body:TabBarView(
        children: [
          RefreshIndicator(onRefresh: ()async{setState((){
        });},
            child:pendinglist.isNotEmpty? Container(//color: Theme.of(context).primaryColorDark,
        padding: const EdgeInsets.symmetric(vertical: 1),
        child:ToggleList(
                divider: const SizedBox(height: 10),
                toggleAnimationDuration: const Duration(milliseconds: 400),
                scrollPosition: AutoScrollPosition.begin,
                trailing: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.expand_more),
                ),
                children: List.generate(pendinglist.length, (index) => ToggleListItem(//parent list
                  title: Padding(
                    padding: const EdgeInsets.all(2),
                    child:ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title:Text( pendinglist[index]['party_name'].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 15),
                      ),
                      subtitle: Text(pendinglist[index]['party'].toString()),
                      trailing: /* Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                          children: [*/Text("₹"+pendinglist[index]['Pending_amount'].toString(),
                          style: Theme.of(context)
                              .textTheme.headline6!
                              .copyWith(fontSize: 15),),/*],)),*/
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
                      children: [
                        Container(
                          child: FutureBuilder<List>(
                                future:  getpendingrecordlist(pendinglist[index]['client_id']),
                            builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            else if (snapshot.hasData || snapshot.data != null) {
                              // print(spendinglist);
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, int indx) {
                                    // var st= spendinglist[indx].status.toString();
                                    if(st==status){visible=true; print("object------$st");
                                    dd=TextDecoration.none;}
                                    else if(st==removed){visible=false;
                                    dd=TextDecoration.lineThrough;
                                    print("object---$st");}
                                    return  Card(
                                      elevation: 4,
                                      child: ListTile(onTap: ()async{
                                        await FirebaseAnalytics.instance.logEvent(
                                          name: "show_pending_payment_record",
                                        );
                                      /*  var list= await Amplify.DataStore.query(CompletedOrderItems.classType,
                                        where:CompletedOrderItems.USER_ID.eq(userid)
                                            .and(CompletedOrderItems.ORDER_ID.eq(spendinglist[indx].record_id.toString())),);
                                        if(list.isNotEmpty){
                                        showDialog(context: context, builder: (BuildContext context){
                                          return AlertDialog(
                                            content: SingleChildScrollView(scrollDirection:Axis.vertical,
                                              child:Container(
                                              height: 400, // Change as per your requirement
                                              width: 300.0, // Change as per your requirement
                                              child:SingleChildScrollView(child:Column(children: [
                                                Container(width: double.infinity,
                                                // margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                                                child:Table(
                                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                                  children: [
                                                    TableRow(
                                                        children: [
                                                          Column(children:[Container(width: 85,child:Text('Item name', style: TextStyle(fontSize: 14.0)))]),
                                                          Column(children:[Container(width: 45,child:Text('Qty/🕝 ', style: TextStyle(fontSize:14.0)))]),
                                                          Column(children:[Container(width: 55,child:Text('₹/unit', style: TextStyle(fontSize:14.0)))]),
                                                          Column(children:[Container(width: 45,child:Text('Total', style: TextStyle(fontSize:14.0)))]),
                                                        ]),
                                                  ],
                                                ) ,),
                                                SizedBox(height: 8,),
                                                Divider(height: 2,),
                                                SizedBox(height: 10,),
                                                FutureBuilder<List<CompletedOrderItems>>(
                                                    future:   Amplify.DataStore.query(CompletedOrderItems.classType,
                                                      where:CompletedOrderItems.USER_ID.eq(userid)
                                                          .and(CompletedOrderItems.ORDER_ID.eq(spendinglist[indx].record_id.toString())),),
                                                builder: (context, snap) {
                                                if (snap.hasError) {
                                                return Text('Something went wrong');
                                                }
                                                else if (snap.hasData || snap.data != null) {
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  // physics: NeverScrollableScrollPhysics(),
                                                  itemCount: snap.data?.length,
                                                  itemBuilder: (BuildContext context, int ind) {
                                                   return  Table(
                                                        defaultColumnWidth: IntrinsicColumnWidth(),
                                                        children: [
                                                          TableRow(
                                                              children: [
                                                                Column(children:[Container(width: 85,padding: EdgeInsets.only(top:8, ),child: Center(child:Text(snap.data![ind].item_name.toString(), style: TextStyle(fontSize: 14.0))))]),
                                                                Column(children:[Container(width: 45,padding: EdgeInsets.only(top:8, ),child: Center(child:Text(snap.data![ind].item_quantity.toString()!=""?snap.data![ind].item_quantity.toString():"🕝 "+snap.data![ind].rented_duration.toString(), style: TextStyle(fontSize:14.0))))]),
                                                                Column(children:[Container(width: 55,padding: EdgeInsets.only(top:8, ),child: Center(child:Text("₹"+snap.data![ind].item_price.toString()+"/\n"+snap.data![ind].item_unit.toString(), style: TextStyle(fontSize:14.0))))]),
                                                                Column(children:[Container(width: 45,padding: EdgeInsets.only(top:8, ),child: Center(child:Text("₹"+snap.data![ind].item_total.toString(), style: TextStyle(fontSize:14.0))))]),
                                                              ]),
                                                        ],
                                                    );
                                                  },
                                                );}
                                                return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.blueGrey,
        ),
      ),
    );})
                                            ]))),),
                                            actions: [Center(child:ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Okay")))],
                                          );
                                        });}*/},
                                        leading: Text((indx+1).toString()),
                                          title: Row(children: [Container(width: 150,
                                            child: Text("₹"+ snapshot.data![indx]['record_id'].toString(), style: TextStyle(decoration: dd),),),
                                          ],),
                                          subtitle:  Row(crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[Text("Purchase: "),
                                                Text("₹"+ snapshot.data![indx]['sent_amount'].toString()),
                                              ]),
                                          trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text( snapshot.data![indx]['time'].toString()),
                                                Text( snapshot.data![indx]['date'].toString()),
                                              ]
                                          )
                                      ),
                                    );
                                  });
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueGrey,
                                ),
                              ),
                            );
                            },
                          ),
                        ),
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
      ):Center(child:
          Column(children:[
            SizedBox(height: 15,),
            Lottie.asset("assets/animations/nopendings.json", height: 250, width: 300),
            SizedBox(height: 10,),
            Text("You have no Dues to receive.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
          ]))),
          SupplierDuesList(),
          CustomerList(),
        ],
      )),
    );
  }
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }
  Widget getDateRangePicker() {
    return Container(
      height: 250,
      child: SfDateRangePicker(
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.range,
        initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3))),
      ),);
  }
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = DateFormat('dd MMMM, yyyy').format(args.value);

    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

}
