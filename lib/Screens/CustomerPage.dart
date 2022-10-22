import 'dart:convert';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/CustomerRecord.dart';
import '../models/CustomerLis.dart';
import '../models/MenuItems.dart';
import '../reusable_widgets/apis.dart';
import 'Customer_record.dart';
import 'login/Login.dart';
class CustomerList extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const CustomerList({Key? key}) : super(key: key);
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
            home:/* FirebaseAuth.instance.currentUser == null
                ?  LoginScreen():FirebaseFirestore.instance.collection("Subscription").doc(FirebaseAuth.instance.currentUser!.uid)
                .get().then((value){value.get("status");})!="Inactive"?*/
                 const CustomerListPage()//:SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key,}) : super(key: key);
  @override
  State<CustomerListPage> createState() => _CustomerListState();
}
class _CustomerListState extends State<CustomerListPage> {
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
  var customerlist=[];
  String time="";
  String userid= "";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  String restroname="", username="", suppliername="", areacode="", profileimg="";
  String itemimage="";
  Future<List> getcustomerlist(us)async{
    var customerlist=[];
    var url= Uri.https(customerlistapi, 'CustomerList/customerlists',);
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){
      setState((){
        customerlist.add(jnResponse);
      });
      }
    }
    return customerlist;
  }
  Future<void>  getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
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
     /* await getcustomerlist(counter);*/}
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
        body:RefreshIndicator(onRefresh: ()async{},
        child: Container(
          margin: EdgeInsets.only(bottom: 10, ),
          child:FutureBuilder<List>(
          future:  getcustomerlist(userid),
          builder: (context, snapshot) {
          if (snapshot.hasError) {
          return Center(child:Text('Something went wrong'));
          } else if (snapshot.hasData || snapshot.data != null) {
          return snapshot.data!.isNotEmpty? ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 4,
                                child: ListTile(
                                  onTap: (){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                      CustomerScreenRecord(ccid:snapshot.data![index]['customer_id'].toString(), iid: snapshot.data![index]['id'].toString())));},
                                  leading:Container(width:65,child:CircleAvatar(backgroundImage: AssetImage("assets/logofront.png"),
                                  ),),
                                  title: Column(mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data![index]['customer_name'].toString()),
                                          Container(child:Text("₹"+snapshot.data![index]['pending_amount'].toString()),),]),
                                  trailing:Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey,width: 1)),
                                      child: IconButton(icon:Icon(Icons.edit, ),
                                    tooltip: "Edit customer details",
                                    onPressed: (){
                                    var description=snapshot.data![index]['customer_name'].toString();
                                    var investment= snapshot.data![index]['customer_phone_no'].toString();
                                      showDialog(
                                          context: context,
                                          builder:  (BuildContext context) {
                                            return StatefulBuilder(builder: (BuildContext context, setState) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)),
                                                title: const Text("Edit Customer"),
                                                content: Container(
                                                  width: 400,
                                                  height: 250,
                                                  child: Column(
                                                    children: [
                                                      TextField(controller: TextEditingController(text: description),
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(),
                                                          ),
                                                          hintText: 'Enter Customer Name'),
                                                        onChanged: (String value) {
                                                          description = value.trim();
                                                        },
                                                      ),
                                                      SizedBox(height: 10,),
                                                      TextField(controller: TextEditingController(text: investment),
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(
                                                            borderSide: BorderSide(),
                                                          ),
                                                          hintText: 'Enter mobile no(optional)'),
                                                        onChanged: (String value) {
                                                          investment = value.trim();
                                                        },
                                                      ),
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
                                                          visible: additem,
                                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                          ),width: 30,
                                                              margin: EdgeInsets.only(bottom: 12),
                                                              child: CircularProgressIndicator()),
                                                        ),
                                                        Visibility(
                                                          maintainSize: true,
                                                          maintainAnimation: true,
                                                          maintainState: true,
                                                          visible: additembtn,
                                                          child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                            color: Colors.blue,
                                                          ),width: double.maxFinite,
                                                            height: 40,
                                                            child:  TextButton(
                                                              onPressed: () async {
                                                                setState(() {
                                                                  additem = true;
                                                                });
                                                                String id = DateFormat("yyyyMMddHHmmss").format(
                                                                    DateTime.now());
                                                                if(description.isEmpty|| description.startsWith("0", 0)){
                                                                  Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");
                                                                }
                                                               else {
                                                                  var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',{
                                                                    'id':snapshot.data![index]['id']
                                                                  });
                                                                  var response = await http.post(murl,
                                                                    headers: <String, String>{
                                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                                    },
                                                                    body: jsonEncode(<String, String>{
                                                                      "id":snapshot.data![index]['id'],
                                                                      "user_id": snapshot.data![index]['user_id'],
                                                                      "customer_id":snapshot.data![index]['customer_id'],
                                                                      "customer_name": description,
                                                                      "customer_phone_no": investment,
                                                                      "advance_amount": snapshot.data![index]['advance_amount'],
                                                                      "pending_amount": snapshot.data![index]['pending_amount'],
                                                                      "date": snapshot.data![index]['date'],
                                                                      "time": snapshot.data![index]['time']}),);
                                                                    setState(() {additem = false;});
                                                                    if(response.statusCode==200){
                                                                    }else{
                                                                      await FirebaseAnalytics.instance.logEvent(
                                                                        name: "error caused",
                                                                        parameters: {
                                                                          "user_id": userid,
                                                                          "response":response.body,
                                                                          "response_code":response.statusCode
                                                                        },
                                                                      );
                                                                    }
                                                                  }
                                                                  Navigator.pop(context);
                                                              }, child: Text('CONTINUE', style: TextStyle(color: Colors.white),),
                                                            ),
                                                          ),
                                                        ),]),
                                                ],
                                              );
                                            });
                                          });
                                  },)),
                                ),
                              );
                            }):
            Center(child:
            Column(children:[
            SizedBox(height: 15,),
            Lottie.asset("assets/animations/customersrecord.json", height: 250, width: 300),
            SizedBox(height: 10,),
            Text("You haven't added any customer yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            TextButton(onPressed: (){
            opencustomerentrydialog(context);
            }, child: Container(
            decoration: BoxDecoration(
            color:Colors.blue,
            borderRadius: BorderRadius.circular(15)
            ),
            padding: EdgeInsets.all(15),
            child:Text("ADD CUSTOMER", style:TextStyle(color:Colors.white))))
            ])); }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blueGrey,
              ),
            ),
          );
          },
          )
        )
        ),
        floatingActionButton: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder:  (BuildContext context) {
                  return StatefulBuilder(builder: (BuildContext context, setState) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: const Text("Add Customer"),
                      content: Container(
                        width: 400,
                        height: 250,
                        child: Column(
                          children: [
                            TextField(decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                                hintText: 'Enter Customer Name'),
                              onChanged: (String value) {
                                description = value;
                              },
                            ),
                            SizedBox(height: 10,),
                            TextField(decoration: InputDecoration(
                                border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                                hintText: 'Enter mobile no(optional)'),
                              onChanged: (String value) {
                                investment = value;
                              },
                            ),
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
                                visible: additem,
                                child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                ),width: 30,
                                    margin: EdgeInsets.only(bottom: 12),
                                    child: CircularProgressIndicator()),
                              ),
                              Visibility(
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: additembtn,
                                child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue,
                                ),width: double.maxFinite,
                                  height: 40,
                                  child:  TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        additem = true;
                                      });
                                      String id = DateFormat("yyyyMMddHHmmss").format(
                                          DateTime.now());
                                      if(description.isEmpty || description.startsWith("0", 0)|| investment.startsWith("0", 0)){
                                        setState(() {
                                          additem = false;
                                        });
                                        Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");
                                      }else{
                                        CheckUserConnection();
                                        if(investment.isNotEmpty &&investment.length!=10){
                                          Fluttertoast.showToast(msg: "Mobile cannot be less then 10 digit or starts with 0");
                                          setState((){
                                              additem = false;
                                           });}else{
                                          if(investment.length==10){
                                          setState((){
                                            investment= "+91"+investment;
                                          });}
                                          createcustomer(description,investment );
                                      setState(() {
                                        additem = false;
                                       });}}
                                      Navigator.pop(context);
                                    }, child: Text('SAVE', style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              ),]),
                      ],
                    );
                  });
                });
          },
              child:Container(width:160, height: 40,
        padding: EdgeInsets.only(left:15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
        child:Row(children: [Icon(
            Icons.person_add,
            color: Colors.white,
          ), SizedBox(width:4),Text("ADD CUSTOMER", style: TextStyle(color:Colors.white),)],) /*],) ,*/
          // backgroundColor: Colors.blue,
        )),
    ),);
  }
  opencustomerentrydialog(context){
      showDialog(
          context: context,
          builder:  (BuildContext context) {
            return StatefulBuilder(builder: (BuildContext context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                title: const Text("Add Customer"),
                content: Container(
                  width: 400,
                  height: 250,
                  child: Column(
                    children: [
                      TextField(decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Enter Customer Name'),
                        onChanged: (String value) {
                          description = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextField(decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                          hintText: 'Enter mobile no(optional)'),
                        onChanged: (String value) {
                          investment = value;
                        },
                      ),
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
                          visible: additem,
                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                          ),width: 30,
                              margin: EdgeInsets.only(bottom: 12),
                              child: CircularProgressIndicator()),
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: additembtn,
                          child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),width: double.maxFinite,
                            height: 40,
                            child:  TextButton(
                              onPressed: () async {
                                setState(() {
                                  additem = true;
                                });
                                String id = DateFormat("yyyyMMddHHmmss").format(
                                    DateTime.now());
                                if(description.isEmpty || description.startsWith("0", 0)|| investment.startsWith("0", 0)){
                                  setState(() {
                                    additem = false;
                                  });
                                  Fluttertoast.showToast(msg: "Fields cannot be empty or starts with 0");
                                }else{
                                  CheckUserConnection();
                                  if(investment.isNotEmpty &&investment.length!=10){
                                    Fluttertoast.showToast(msg: "Mobile cannot be less then 10 digit or starts with 0");
                                    setState((){
                                      additem = false;
                                    });}else{
                                    if(investment.length==10){
                                      setState((){
                                        investment= "+91"+investment;
                                      });}
                                    createcustomer(description,investment );
                                    setState(() {
                                      additem = false;
                                    });}}
                                Navigator.pop(context);
                              }, child: Text('SAVE', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),]),
                ],
              );
            });
          });
  }
  createcustomer(name, phn)async{
      var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',);
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMddHHmmss").format(
              DateTime.now()),
          "user_id": userid,
          "customer_id":DateFormat("yyyyMMddHHmmss").format(
              DateTime.now()),
          "customer_name": name,
          "customer_phone_no": phn,
          "advance_amount": "0",
          "pending_amount": "0",
          "date": DateFormat("yyyy-MM-dd").format(
              DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(
              DateTime.now())}),);
    print('Response status: ${response.statusCode}');
    if(response.statusCode==200){
      await FirebaseAnalytics.instance.logEvent(
        name: "new_customer_added",
        parameters: {
          "user_id": userid,
        },
      );
    }else{
      await FirebaseAnalytics.instance.logEvent(
        name: "error caused",
        parameters: {
          "user_id": userid,
          "response":response.body,
          "response_code":response.statusCode
        },
      );
      Fluttertoast.showToast(msg: "Something went wrong! please try again.");
    }

  }
}

