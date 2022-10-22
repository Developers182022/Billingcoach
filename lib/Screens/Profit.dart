import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_list/toggle_list.dart';
import '../Screens/Expanse.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'login/Login.dart';
class ProfitScreen extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  ProfitScreen({Key? key}) : super(key: key);
  String ?_paymentMethodId;
  String inactive= "Inactive";
  String? _errorMessage = "";
  var _isNativePayAvailable = false;
  var difference=0;
  String itemimage="", subscriptionstatus="";
  var total=0;
  String expired= "Expired";
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String restroname="", phoneno="", address="", areacode="", profileimg="", paymode= "", deliverymode="";
  var now = new DateTime.now();
  var date= DateFormat("yy-MM-dd").parse("22-07-31");
  var noww= DateFormat("yy-MM-dd").format(DateTime.now());
  var det;
  Razorpay? razorpay;
  get setState => null;
  void handlerPaymentSuccess(){
    print("Pament success");
    Fluttertoast.showToast(msg: "Payment success");
  }
  void handlerErrorFailure(){
    print("Pament error");
    Fluttertoast.showToast(msg: "Pament error");
  }
  void handlerExternalWallet(){
    print("External Wallet");
    Fluttertoast.showToast(msg: "External Wallet");
  }
  @override
  void initState()async{

    print("FWGTYHTUTY");
    setState((){
    det = DateFormat("yy-MM-dd").parse(noww);
    print(det);
    print(date.difference(det).inDays);
    print(date.difference(det).inDays);});
     initState();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'DashBoard',
            theme:ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.black,
                brightness: Brightness.light,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.white,
                brightness: Brightness.dark,
                primaryColorDark:Colors.black ),
            themeMode: ThemeMode.system,
            home: const ProfitPage(user: "userid"),
          );
        });
  }
}
  class ProfitPage extends StatefulWidget {
    const ProfitPage({Key? key, required this.user}) : super(key: key);
    final String user;
    @override
    State<ProfitPage> createState() => _itemPageState();
  }
class _itemPageState extends State<ProfitPage> with TickerProviderStateMixin  {
  bool ActiveConnection = false;
  String T = "";

  var childdoc;
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
  int pageIndex = 0;
  var totalexpanse=0;
  late String userid="";
  List<String> orderidcount=<String>[];
  List<String> orderid= <String>[];
  List<int> price= <int>[];
  var o_id;
  var pending= "pending";
  var appname="Profit";
  String completed= "completed";
  List<String> totalprice= <String>[];
  late final List<String> itemcount = <String>[];
  final Map counts = {};
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? selectedValueSingleMenu;
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> editableItems = [];
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String inputString = "";
  TextFormField? input;
  var removed= "removed";
  late TabController _controller;
  var id, g, k, l, hm;
  int _page = 2;
  var selectedindex=0;
  String restroname="", username="", suppliername="", areacode="", email="";
  @override
  void initState() {
    _controller = new TabController(vsync: this, length: 2);
    CheckUserConnection();
    getuserdetails();
    super.initState();
  }
  Future getshowcasestatus()async{
    final SharedPreferences pref= await SharedPreferences.getInstance();
    hm= pref.getBool('showShowcase');
    var st= pref.getBool("showprofit");
    if(hm!=null){
      if(st==null){pref.setBool("showprofit", true);}
    }
    return st;
  }
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  var profitlist=[];
  Future<void> getprofitlist(us)async{
    var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthlyprofitrecords',);
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        profitlist.add(jnResponse);
      });
      }
    }print("profitlist   $profitlist");

  }
  Future<List> getitmeprofitlist( mnth, year)async{
    var profititemlist=[];
      var url= Uri.https(profitapi, 'Profit/profits',);
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length );
    for(int i=0; i<tagObjsJson.length; i++){ print("object   ${tagObjsJson[i]}   $mnth  $year");
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_i']==userid &&jnResponse['month'] ==mnth&&jnResponse['year'] ==year){print("outgj-- $jnResponse");
      if(this.mounted){setState((){
        profititemlist.add(jnResponse);
      });}
      }
    }
    print('n                 ${profititemlist}');
    return profititemlist;

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
            restroname = jsonResponse['shop_name'].toString();
            username = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
      await getprofitlist(counter);}
    else{runApp(LoginScreen());}
  }
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
        length: 2,
       child:Scaffold(
      appBar: AppBar(  backgroundColor: Theme.of(context).primaryColorDark,
        leading:TextButton(onPressed:(){Scaffold.of(context).openDrawer();},child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100,width: 2)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.menu,color:Theme.of(context).primaryColor,))),

      /*  actions: [
          IconButton(tooltip: "See Progress of your business",
              onPressed: (){
            if(selectedindex==0){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  var values;
                  return Container(height: 300,//scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  <Widget>[

                      ],
                    ),
                    // ),
                  );
                },
              );
            }
              }, icon: Icon(Icons.stacked_line_chart,color:Theme.of(context).primaryColor,)),
        ],*/
       bottom:TabBar(labelColor:Theme.of(context).primaryColor,
         indicatorColor: Theme.of(context).primaryColor,
          tabs: [
          Tab(icon: Icon(Icons.bar_chart_outlined,), text: 'Profits', ),
            Tab(icon: Icon(Icons.currency_rupee_sharp), text: 'Expanse'),
    ],
         physics: NeverScrollableScrollPhysics(),
    onTap: (index) async {
         if(index==0){
           await FirebaseAnalytics.instance.logEvent(
             name: "show_profit",
           );
           setState((){selectedindex=0;

             appname= "Profit";
           });
         }else{await FirebaseAnalytics.instance.logEvent(
           name: "show_expanse",
         );
           setState((){selectedindex=1;

         appname= "Expanse";});}
    },

    ),),
      body:TabBarView(
        children: [ RefreshIndicator(onRefresh: ()async{ setState((){
          childdoc=  Amplify.DataStore.query(ProfitMonthlyRecord.classType,
          where:ProfitMonthlyRecord.USER_ID.eq(userid));}); },
          child:profitlist.isNotEmpty?Container(
          margin: EdgeInsets.only(bottom: 60, ),
          child: /*FutureBuilder<List<ProfitMonthlyRecord>>(
            future:  childdoc,
            builder: (context, napshot) {
              if (napshot.hasError) {
                return Text('Something went wrong');
              } else if (napshot.hasData || napshot.data!= null) {
                return */ToggleList(
                  toggleAnimationDuration: const Duration(milliseconds: 400),
                  scrollPosition: AutoScrollPosition.begin,
                  trailing: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.expand_more),
                  ),
                  children: List.generate(profitlist.length, (index) => ToggleListItem(//parent list
                    title: Padding(
                      padding: const EdgeInsets.all(10),
                        child: ListTile(
                            title: Container(
                              child:  Table(
                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                  children: [
                                    TableRow( children: [
                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:[ Container(padding: EdgeInsets.all(5),
                                            child:  Text("Total profit ${profitlist[index]['monthly_profit'].toString()}"),),
                                           ]),
                                    ]),]),),
                            trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(profitlist[index]['month'].toString()),
                                  Text(profitlist[index]['year'].toString()),
                                ])

                        ),
                      ),//parent listitems
                    content: Container(
                      // margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<List>(
                            future: getitmeprofitlist(profitlist[index]['month'].toString(), profitlist[index]['year'].toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              else if (snapshot.hasData || snapshot.data != null) {
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data?.length,
                                    itemBuilder: (BuildContext context, int indx) {
                                      print(snapshot.data);
                                      return  Card(
                                        elevation: 4,
                                        child: ListTile(
                                            title:Container(
                                              padding: EdgeInsets.all(10),
                                              child: Text(snapshot.data![indx]['date'].toString()),
                                            ),
                                            subtitle:Column(children: [
                                              Container(width: double.infinity,
                                              child:  Table(
                                                  defaultColumnWidth: IntrinsicColumnWidth(),
                                                  border: TableBorder.all(
                                                      borderRadius: const BorderRadius.vertical(
                                                        bottom: Radius.circular(10),
                                                        top:  Radius.circular(10),
                                                      ),
                                                      width: 0.5),
                                                  children: [
                                                    TableRow( children: [
                                                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children:[ Container(padding: EdgeInsets.all(8),
                                                            child:  Text("Total Earned Amount"),),
                                                            Container(padding: EdgeInsets.all(8),
                                                              child:  Text("Total Expanse Amount"),),
                                                           ]),
                                                      Column(crossAxisAlignment:CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children:[
                                                            Container(padding: EdgeInsets.all(8),
                                                              child:  Text(snapshot.data![indx]['earned'].toString()),),
                                                            Container(padding: EdgeInsets.all(8),
                                                              child:  Text(snapshot.data![indx]['expanse'].toString()),),
                                                           ]
                                                      ),
                                                    ]),]),),
                                              const Divider(
                                                // color: Colors.white70,
                                                height: 2,
                                                thickness: 2,
                                              ),
                                              Container(color:Colors.grey.withOpacity(.5),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(margin: EdgeInsets.only(left: 10, top: 8, bottom: 8, ),
                                                        width: 150,
                                                        child:Text("Total Profit", style: TextStyle(fontSize: 15),)),
                                                 SizedBox(width: 80,),
                                                    Container(
                                                      margin: EdgeInsets.only(right: 20, top: 8, bottom: 8),
                                                      child: Text(snapshot.data![indx]['profit'].toString(), style: TextStyle(fontSize: 15),),),
                                                  ],),),
                                            ]),


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
                  ),)
              /*;}
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red,
                  ),
                ),
              );
            },
          ),*/

        )
        :  Center(child:
          Column(children:[
            SizedBox(height: 15,),
            Lottie.asset("assets/animations/statistics.json", height: 250, width: 300),
            SizedBox(height: 10,),
            Text("No records found.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
          ])),),
          couchExpanse()])),
    );
  }
}
