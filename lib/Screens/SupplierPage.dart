import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/ExpanseRecord.dart';
import '../models/StockList.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'Supplier_record.dart';
import 'listserach.dart';
import 'package:lottie/lottie.dart';

import 'login/Login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class SupplierDuesList extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SupplierDuesList({Key? key}) : super(key: key);
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
            home: const SupplierDuesListPage(),
          );
        });
  }
}
class SupplierDuesListPage extends StatefulWidget {
  const SupplierDuesListPage({Key? key,}) : super(key: key);
  @override
  State<SupplierDuesListPage> createState() => _SupplierDuesListPageState();
}
class _SupplierDuesListPageState extends State<SupplierDuesListPage> {
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
  bool additem=false, additembtn=true, edititem=false, edititembtn= true;
  String imgurl= "https://dominionmartialarts.com/wp-content/uploads/2017/04/default-image-620x600.jpg";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String userid= "";
  String restroname="", username="", suppliername="", areacode="", profileimg="";
  String itemimage="";
  var supplierslist=[];
  var doc;
Future<List>getsupplierlist(us)async{
  var supplierlist=[];
   var url= Uri.https(acceptedsupplierapi,'AcceptedSuppliers/acceptedsuppliers');
   var response= await http.get(url );
   var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   print("stocklosy--  ${jsonDecode(response.body)}");
   var tagObjsJson = jsonDecode(response.body)['products'] as List;
   print(tagObjsJson.length);
   for(int i=0; i<tagObjsJson.length; i++){
     var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
     if(jnResponse['user_id']==us){
     if(this.mounted){setState((){
       supplierslist.add(jnResponse);
       supplierlist.add(jnResponse);
     });}
     }
   }
   return supplierlist;

  }
  Future<void> getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){getsupplierlist(counter);
      setState((){userid=counter;});
      var url= Uri.https(supplierapi, 'Suppliers/suppliers',);
      var response= await http.get(url );
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy--  ${jsonDecode(response.body)}");
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      if(response.body.isNotEmpty) {
        setState(() {
          setState(() {
            restroname = tagObjsJson[0]['shop_name'].toString();
            username = tagObjsJson[0]['username'].toString();
            suppliername = tagObjsJson[0]['supplier_name'].toString();
            areacode = tagObjsJson[0]['pincode'].toString();
          });
        });
      }
    }else{
      runApp(LoginScreen());}
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body:RefreshIndicator(onRefresh: ()async{
          getsupplierlist(userid);
        },
            child:
        Container(
          margin: EdgeInsets.only(bottom: 10, ),
          child: supplierslist.isNotEmpty?SingleChildScrollView(child:ListView.builder(
                    shrinkWrap: true,
                    itemCount: supplierslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SupplierRecord(ccid: supplierslist[index]['supplier_id'])));},
                          leading:Container(width:65,child:CircleAvatar(backgroundImage: AssetImage("assets/logofront.png"),
                          ),),
                          title: Row(children: [Container(width:150,
                            child:Column(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(supplierslist[index]['shop_name'].toString()),]),),
                          ],),
                          subtitle: Text("₹"+supplierslist[index]['Pending_amount'].toString()),
                        ),
                      );
                    })):
          Center(child:
              Column(mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    Lottie.asset("assets/animations/noclientrecord.json", height: 250, width: 300),
                    SizedBox(height: 10,),
                    Text("No records found.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                  ])),)),
      ),);
  }
  updateStockifexist(String id, String name, String cost) async{
      List<StockList> StockLists = await Amplify.DataStore.query(StockList.classType,
          where: StockList.USER_ID.eq(userid).and(StockList.STOCK_ID.eq(id)));
      if(StockLists.isNotEmpty){
        final updatedItem = StockLists[0].copyWith(
            user_id: StockLists[0].user_id,
            stock_id: StockLists[0].stock_id,
            stock_name: name,
            stock_quantity: StockLists[0].stock_quantity,
            stock_investment: StockLists[0].stock_investment,
            selling_price_per_unit: cost,
            constant_quantity: StockLists[0].constant_quantity,
            stock_status: StockLists[0].stock_status,
            );
        await Amplify.DataStore.save(updatedItem).whenComplete((){print("finished");
        updateexpanseitemname(id, name);});
      }
  }

  updateexpanseitemname(String stockid, String itemname) async {
    print("diwjdhufe");
      List<ExpanseRecord> ExpanseRecords = await Amplify.DataStore.query(ExpanseRecord.classType,
      where: ExpanseRecord.USER_ID.eq(userid).and(ExpanseRecord.EXPANSE_RECORD_ID.eq(stockid)));
      if(ExpanseRecords.isNotEmpty){
        final updatedItem = ExpanseRecords[0].copyWith(
            user_id: ExpanseRecords[0].user_id,
            expanse_id: ExpanseRecords[0].expanse_id,
            expanse_record_id: ExpanseRecords[0].expanse_record_id,
            expanse_name: itemname,
            description: ExpanseRecords[0].description,
            investment: ExpanseRecords[0].investment,
            date: ExpanseRecords[0].date,
            time: ExpanseRecords[0].time,
            status: ExpanseRecords[0].status);
        await Amplify.DataStore.save(updatedItem).whenComplete((){print("expansetckreportnamefinished");
    });
      }


  }
}

