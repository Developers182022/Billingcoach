
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../Screens/listserach.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'login/Login.dart';
class SupplierDetails extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SupplierDetails({Key? key,this.stid}) : super(key: key);
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
            theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.black,
                brightness: Brightness.light,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.white,
                brightness: Brightness.dark,
                primaryColorDark:Colors.black ),
            themeMode: ThemeMode.system,
            home: SupplierDetailsPage(stockid: stid),
          );
        });
  }
}
class SupplierDetailsPage extends StatefulWidget {
  const SupplierDetailsPage({Key? key,this.stockid}) : super(key: key);
  final stockid;
  @override
  State<SupplierDetailsPage> createState() => _SupplierDetailsState(title: stockid);
}
class _SupplierDetailsState extends State<SupplierDetailsPage> {
  _SupplierDetailsState({this.title});
  final title;
  var itemdoc, rentdoc;
  var item=true;
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
  String userid= "";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String restroname="", username="", suppliername="", areacode="", profileimg="";
  String shopname="", shopaddress="", shopphoneno="", shopownername="", idd= "", supplierusername="";
  Future<void> getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      await FirebaseAnalytics.instance.logEvent(
        name: "show_supplier_detail",
        parameters: {
          "user_id": counter,
        },
      );
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
            suppliername = jsonResponse['supplier_name'].toString();
            areacode= jsonResponse['pincode'].toString();
          });}
      }
      }
    else{runApp(LoginScreen());}

  }
  @override
  void initState() {
    CheckUserConnection();
    print("title   $title");
   getuserdetails();
    loaddetails(title);
    var key;
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
        appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
          leading:TextButton(child:Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              child:Icon(Icons.arrow_back,
                color:Theme.of(context).primaryColor,)),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListExample()));}, ),
          title:Text(supplierusername, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color:Theme.of(context).primaryColor,),),
          ),
        body:RefreshIndicator(
          onRefresh: ()async{},
          child: Container(
          margin: EdgeInsets.only(bottom: 10, ),
          child:SingleChildScrollView(scrollDirection: Axis.vertical,
            child:Column(children: [
            Container(child:Column(children: [
            Container(width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),),
            child: Text("Shop name: "+shopname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
            Container(width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),),
            child: Text("Shop owner name: "+shopownername,style: TextStyle(fontSize: 15),),),
            shopaddress.isNotEmpty? Container(width: double.infinity,
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),),
              child: Text("Address: "+ shopaddress,style: TextStyle(fontSize: 15),),):Container()],)),
            Container(width: double.infinity,
              margin: EdgeInsets.only(left: 15,  right: 10,top:8 ),
              decoration: BoxDecoration(borderRadius:BorderRadius.circular(10),),
              child: Row(children: [Text("Recommeneded Items",style: TextStyle(fontSize: 20),),
                PopupMenuButton(
                  tooltip: "Filter",
                  icon: Icon(Icons.filter_list),
                  itemBuilder: (_) {
                    return [
                      PopupMenuItem(child: ExpansionTile(title: Text("Filter"),
                        children: [
                        ListTile(onTap:(){
                          setState(() {
                            item=true;
                          });
                        },title:Text("Filter by Inventory/stock")),
                        ListTile(onTap:(){
                          setState(() {
                            item=false;
                          });
                        },title:Text("Filter by Services"))
                        ],
                      )),
                    ];
                  },
                ),],),),
            ListTile(title: Text("Itemname"),trailing: Text("Price"),),
            Container(height:435,
              child: item?  FutureBuilder<List>(
              future:  menulist(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {return Text('Something went wrong');}
                else if (snapshot.hasData || snapshot.data != null) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 4,
                          child: ListTile(
                            // leading: Text("Item: "),
                            title: Text(snapshot.data![index]['item_name'].toString()),
                            trailing:Container(child:Text("₹ "+snapshot.data![index]['item_price_per_unit'].toString(),),
                            ), // onLongPress: ,
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
            ):
              FutureBuilder<List>(
                future:  renteditems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(snapshot.data![index]['rented_item_name'].toString()),
                              trailing:Text(""+snapshot.data![index]['charger_per_duration'].toString()),
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
              )),
          ],))
           ),
      )),);
  }

  Future<List> menulist()async{
    var menulist=[];
    var url= Uri.https(menuapi, 'Item/items',);
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==title){
        setState((){
          menulist.add(jnResponse);
        });
      }
    }
    return menulist;
  }
  Future<List> renteditems()async{
    var rentedlist=[];
    var url= Uri.https(rentedapi, 'RentedItem/renteditems', );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = jsonDecode(response.body)['products'] as List;
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        if(jnResponse['user_id']==title) {
          setState(() {
            rentedlist.add(jnResponse);
          });
        }
      }
    }
    return rentedlist;
  }
  Future<void> loaddetails(title) async {
    var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': title} );
    var response= await http.get(url );
    print(response.body);
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("stocklosy-uhgyuj-  ${jsonDecode(response.body)}");
      if (this.mounted) {
        setState(() {
          idd = jsonResponse['supplier_id'].toString();
          shopname = jsonResponse['shop_name'].toString();
          supplierusername = jsonResponse['username'].toString();
          shopownername = jsonResponse['supplier_name'].toString();
          shopaddress= jsonResponse['shop_address'].toString();
        });}
    }
  }

}

