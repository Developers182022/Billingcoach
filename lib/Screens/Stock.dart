import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:uuid/uuid.dart';
import '../models/Expanse.dart';
import '../models/ExpanseRecord.dart';
import '../models/MenuItems.dart';
import '../models/PaymentRecords.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/StockList.dart';
import '../models/StockRecord.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'login/Login.dart';
import 'menu.dart';
import 'onrenteditems.dart';
import 'stockreportdetails.dart';
class UserStock extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const UserStock({Key? key}) : super(key: key);
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
            home: const UserStockPage(),
          );
        });
  }
}
class UserStockPage extends StatefulWidget {
  const UserStockPage({Key? key,}) : super(key: key);


  @override
  State<UserStockPage> createState() => _itemPageState();
}
class _itemPageState extends State<UserStockPage> with TickerProviderStateMixin {
  bool ActiveConnection = false;
  String T = "";
  var doc;
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> filteritem = [];
  var itemunitlist=["Pieces", "Packets", "Bottle","Centimeter","Meter", "Kilometer", "SqMeter", "Yard", "Pouch", "Gram", "KiloGram", "Litre",
    "MiliLitre", "Feet", "SqFeet", "Dozens", "Tonnes" , "Inches" ];
  final String item = "pcs , pkt , btl , cm , m , km , sqm , yd , pch , gm , kg , l , ml , ft , sqft , dz , t , in ";

  String filtervalue="";
  String inputString = "";
  TextFormField? input;
  final _testList = ['Date',];
  final menukey= GlobalKey();
  String appname="Stock", paid= "Paid";

  var expanse_id;
  var totalexpanse=0;
  String? selectedValueSingleMenu;
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
  String userid="", complete= "complete", removed= "removed";
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime= DateTime(2015);
  bool addstockbtn= true, addstock= false, updatestock=false, updatestockbtn= true;
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String email="";
  String restroname="", phoneno="", address="", areacode="", imgprofile="";
  var hm;
  final rentkey= GlobalKey();
  final stocklistkey=GlobalKey();
  final stockfloatkey= GlobalKey();
  late TabController _tabController;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  Future getshowcasestatus()async{
    final SharedPreferences pref= await SharedPreferences.getInstance();
    hm= pref.getBool('showShowcase');
    var st= pref.getBool("showitemslist");
    if(hm!=null){
      if(st==null){pref.setBool("showitemslist", true);}
    }
    return st;
  }
  var stocklist=[];
var selectedindex=0;
   getstocklist(us)async {

     var url = Uri.https(stockapi, 'StockItemList/stockitems',);
     var response = await http.get(url);
     if(response.body.isNotEmpty){
     var tagObjsJson = jsonDecode(response.body)['products'] as List;
     print(tagObjsJson.length);
     for (int i = 0; i < tagObjsJson.length; i++) {
       var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
       if (jnResponse['user_id'] == us) {
         setState(() {
           stocklist.add(jnResponse);
         });
       }
     }
   }
  }
  Future<void> getuserdetails() async {
      final SharedPreferences prefs = await preferences;
      var counter = prefs.getString('user_Id');
      if(counter!=null){
      setState((){userid=counter;});
      await getstocklist(counter);}
      else{runApp(LoginScreen());}
    }
    syncdata()async{
      try {
        await Amplify.DataStore.start();
      } on Exception catch (error) {
        print('Error starting DataStore: $error');
      }
    }
  @override
  void initState() {
    syncdata();
    CheckUserConnection();
    getuserdetails();
    _tabController = new TabController(vsync: this, length: 3);
    String wordPair = "";
    if(_testList.isNotEmpty){
      for(int i=0; i<_testList.length; i++){
        filteritem.add(DropdownMenuItem(child: Text(_testList[i]), value: _testList[i],));
      }}
    item
    // .toLowerCase()
        .replaceAll(",", "")
        .replaceAll(".", "")
        .split(" ")
        .forEach((word) {
      if (wordPair.isEmpty) {
        wordPair = word + "";
      } else {
        wordPair += word;
        if (items.indexWhere((item) {
          return (item.value == wordPair);
        }) ==
            -1) {
          items.add(DropdownMenuItem(
            child:  Row(children: [Container(width: 100,child: Text('${wordPair}'),) ,Text('${itemunitlist[items.length]}'), ],),
            value: wordPair,
          ));
        }
        wordPair = "";
      }
    });
    input = TextFormField(
      validator: (value) {
        return ((value?.length ?? 0) < 6
            ? "must be at least 6 characters long"
            : null);
      },
      initialValue: inputString,
      onChanged: (value) {
        inputString = value;
      },
      autofocus: true,
    ); super.initState();
    _tabController.addListener(() {
      print(_tabController.index);
      setState(() {
        selectedindex = _tabController.index;
      });});

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: DefaultTabController(
      length: 3,
      child:Scaffold(
        appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
            leading:TextButton(onPressed:(){Scaffold.of(context).openDrawer();},child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),
                child:Icon(Icons.menu,color:Theme.of(context).primaryColor,))),
            bottom:TabBar(
              controller: _tabController,
              labelColor:Theme.of(context).primaryColor,
              // unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              isScrollable: false,//controller: _tabController,
              tabs: [
                Tab(icon: Icon(Icons.category), text: 'Stock',),
                Tab(icon: Icon(Icons.shopping_cart_outlined), text: 'Manage Items'),
                Tab(icon: Icon(Icons.timer_sharp), text: 'Rentals/Services',),
              ],
              physics: NeverScrollableScrollPhysics(),
            )
        ),
        body: TabBarView(controller: _tabController,
            children: [RefreshIndicator(onRefresh: ()async{setdocument();},
                child:stocklist.isNotEmpty?Container(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child:
                  ToggleList(
                          divider: const SizedBox(height: 10),
                          toggleAnimationDuration: const Duration(milliseconds: 400),
                          scrollPosition: AutoScrollPosition.begin,
                          trailing: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.expand_more),
                          ),
                          children: List.generate(stocklist.length, (index) => ToggleListItem(//parent list
                            title: Padding(
                              padding: const EdgeInsets.all(10),
                              child:ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title:Text(stocklist[index]['stock_name'].toString(),
                                        style:Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(fontSize: 14),
                                      ),
                                subtitle:Row(
                                  children: [Text("Selling price: ",  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(fontSize: 12),), Text("₹"+stocklist[index]['selling_price_per_unit'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontSize: 12),
                                  ),],) ,
                                trailing:  Container(//margin: EdgeInsets.only(left:45,right: 10),
                                  child: Text("Available : "+stocklist[index]['stock_quantity'].toString(),
                                    style: Theme.of(context)
                                        .textTheme.headline6!
                                        .copyWith(fontSize: 14),),),
                              ),),
                            // content: Container(),//parent listitems
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
                                  // const SizedBox(
                                  //   height: 8,
                                  // ),
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
                                        onPressed: () {
                                          String unit="";
                                          String stock_id= stocklist[index]['stock_id'].toString();
                                          String stockname=stocklist[index]['stock_name'].toString(),
                                              stockquantity="", amount="", sell_price=stocklist[index]['selling_price_per_unit'].toString();
                                          showDialog(context: context, builder: (BuildContext context){
                                            return  StatefulBuilder(builder:  (BuildContext context, setState){
                                              return AlertDialog(
                                                  content: Container(height:400,child:SingleChildScrollView(child: Column(
                                                    children: [
                                                      Container(
                                                          child: TextField(decoration: InputDecoration(hintText: "Stock name".tr(),
                                                            labelText: "Stock name".tr(),
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(),
                                                            ),
                                                            prefixIcon: Icon(Icons.storage),
                                                          ),
                                                            controller: TextEditingController(text: stockname),
                                                            onChanged: (value){
                                                              stockname= value;
                                                            },)
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Container(
                                                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                                              borderRadius: BorderRadius.circular(5)),
                                                          child:SearchChoices.single(
                                                            displayClearIcon: false,
                                                            isExpanded: true,
                                                            hint: "Select stock unit",
                                                            searchHint: "Select stock unit",
                                                            items: items,
                                                            value: unit,
                                                            onChanged: (value) {
                                                              print(value);
                                                              setState(() {
                                                                unit = value;
                                                                selectedValueSingleMenu = value;
                                                              });
                                                            },
                                                          )),
                                                      SizedBox(height: 10,),
                                                      Container(
                                                          child: TextField(
                                                            decoration: InputDecoration(hintText: "Quantity".tr(),
                                                                labelText: "Quantity".tr(),
                                                                border: OutlineInputBorder(
                                                                  borderSide: BorderSide(),
                                                                ),
                                                                prefixIcon: Icon(Icons.production_quantity_limits)),
                                                            keyboardType: TextInputType.number,
                                                            onChanged: (value){
                                                              stockquantity= value;
                                                            },)
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Container(
                                                        child: TextField(decoration: InputDecoration(
                                                            hintText: "Total cost of stock (in rupees)".tr(),
                                                           labelText: "Total cost of stock (in rupees)".tr(),
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(),
                                                            ),
                                                            prefixIcon: Icon(Icons.currency_rupee)),
                                                          keyboardType: TextInputType.number,
                                                          onChanged: (value){
                                                            amount= value.trim();
                                                          }, ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Text(selectedValueSingleMenu!=null?
                                                      "Selling price per $selectedValueSingleMenu (including taxes)"
                                                          :"Selling price per unit (including taxes)"),
                                                      SizedBox(height: 10,),
                                                      Container(
                                                          child: TextField(
                                                            decoration: InputDecoration(
                                                              hintText: selectedValueSingleMenu!=null?
                                                              "Selling price per $selectedValueSingleMenu (including taxes)"
                                                                  :"Selling price per unit (including taxes)",
                                                              labelText:  selectedValueSingleMenu!=null?
                                                              "Selling price per $selectedValueSingleMenu (including taxes)"
                                                                  :"Selling price per unit (including taxes)",
                                                              border: OutlineInputBorder(
                                                                borderSide: BorderSide(),
                                                              ),
                                                              prefixIcon: Icon(Icons.currency_rupee_rounded)),
                                                            controller: TextEditingController(text: sell_price),
                                                            keyboardType: TextInputType.number,
                                                            onChanged: (value){
                                                              sell_price= value.trim();
                                                            },)
                                                      ),
                                                    ],))),
                                                  actions: [
                                                    Column(//crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Visibility(
                                                            maintainSize: true,
                                                            maintainAnimation: true,
                                                            maintainState: true,
                                                            visible: updatestock,
                                                            child: CircularProgressIndicator()
                                                        ),
                                                        Visibility(
                                                            maintainSize: true,
                                                            maintainAnimation: true,
                                                            maintainState: true,
                                                            visible: updatestock,
                                                            child: Container(
                                                                margin: EdgeInsets.only(top: 10, ),
                                                                child:
                                                                Text("Please wait & do not press back!"))),
                                                        Visibility(
                                                          maintainSize: true,
                                                          maintainAnimation: true,
                                                          maintainState: true,
                                                          visible: updatestockbtn,
                                                          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                            color: Colors.blue,
                                                          ),width: double.maxFinite,
                                                            height: 40,
                                                            child: TextButton(
                                                                onPressed: () async{setState((){updatestock=true;
                                                                updatestockbtn=false;});
                                                                String id= stocklist[index]['stock_id'].toString();
                                                                String existingquantity= stocklist[index]['stock_quantity'].toString();
                                                                CheckUserConnection();
                                                                if(stockname.isNotEmpty &&unit.isNotEmpty&& stockquantity.isNotEmpty
                                                                    && sell_price.isNotEmpty && amount.isNotEmpty){
                                                                  var url = Uri.https(stockapi, 'StockItemList/stockitem');
                                                                  var response = await http.post(url,   headers: <String, String>{
                                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                                  },
                                                                    body: jsonEncode(<String, String>{
                                                                      "id":stocklist[index]['id'].toString(),
                                                                      "user_id": userid,
                                                                      "stock_id":id,
                                                                      "stock_name": stockname,
                                                                      "stock_quantity": (double.parse(stockquantity)+double.parse(existingquantity)).toString(),
                                                                      "stock_investment": amount,
                                                                      "selling_price_per_unit": sell_price,
                                                                      "constant_quantity":(double.parse(stockquantity)+double.parse(existingquantity)).toString(),
                                                                      "stock_status": complete,
                                                                      "stock_unit": unit}),);
                                                                  if(response.statusCode==200){
                                                                    String idd= DateFormat("yyyyMMddHHmmss").format(
                                                                        DateTime.now());
                                                                    await createstockreport(stocklist[index]['stock_id'].toString(),
                                                                        stockname, stockquantity, amount, sell_price, unit,
                                                                        idd);
                                                                    await updatepaymentrecord(idd, stockname, stockquantity, amount);

                                                                  }
                                                                  await FirebaseAnalytics.instance.logEvent(
                                                                    name: "updated_item_to_stock",
                                                                    parameters: {
                                                                      "user_id":  userid,
                                                                    },
                                                                  );
                                                                  setState((){updatestock=false;
                                                                  setdocument();
                                                                  updatestockbtn=true;});
                                                                  Navigator.of(context, rootNavigator: true).pop(context);}
                                                                else{
                                                                  setState((){updatestock=false;
                                                                  updatestockbtn=true;});Fluttertoast.showToast(msg: "Kindly all required fields.");
                                                                Navigator.of(context, rootNavigator: true).pop(context);}
                                                                },
                                                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                                  children: [Icon(Icons.update, color: Colors.white,),
                                                                    Text("UPDATE STOCK".tr(), style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),],)
                                                            ),
                                                          ),),],
                                                    )]);
                                            });});
                                        },
                                        child: Column(
                                          children: const [
                                            Icon(Icons.update,color: Colors.blue,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 2.0),
                                            ),
                                            Text('Update stock',style: TextStyle(color: Colors.blue),),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () async{  await FirebaseAnalytics.instance.logEvent(
                                            name: "show_stock_history",
                                            parameters: {
                                              "stock":stocklist[index]['stock_name'].toString(),
                                              "user_id":  userid,
                                            },
                                          );
                                            CheckUserConnection();
                                            String idd= stocklist[index]['stock_id'].toString();
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => UserStockRecord(stid: stocklist[index]['id'].toString())));
                                          },
                                          child:Column(children: [Icon(Icons.history_sharp,),
                                            Text("History", style: TextStyle(),)],)
                                      ),
                                      TextButton(
                                        onPressed: ()async {await FirebaseAnalytics.instance.logEvent(
                                          name: "deleted_stock",
                                          parameters: {
                                            "stock":stocklist[index]['stock_name'].toString(),
                                            "user_id":  userid,
                                          },
                                        );
                                          CheckUserConnection();
                                          String stock_id= stocklist[index]['stock_id'].toString();
                                          String stockname=stocklist[index]['stock_name'].toString(),
                                              stockquantity="", amount="",
                                              sell_price=stocklist[index]['selling_price_per_unit'].toString();
                                        double qunatity= double.parse(stocklist[index]['constant_quantity'].toString());
                                        double recordquntity= double.parse(stocklist[index]['stock_quantity'].toString());
                                        if(qunatity==recordquntity){ await checksifrecordexist(stocklist[index]['stock_id'].toString(), stockname);}
                                        else{ Fluttertoast.showToast(msg: "This record cannot be deleted. You have used items from this record.");}
                                          setdocument();
                                          },
                                        child: Column(
                                          children: const [
                                            Icon(Icons.delete,color: Colors.blue,),
                                            Padding(padding: EdgeInsets.symmetric(vertical: 2.0),),
                                            Text('Delete stock',style: TextStyle(color: Colors.blue),),
                                          ],
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
                          ))
                  )) :
                Center(child:
                SingleChildScrollView(scrollDirection: Axis.vertical,
                child:
                Column(mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                  Lottie.asset("assets/animations/noitemerror.json", height: 250, width: 300),
                  SizedBox(height: 10,),
                  Text("You haven't added any stock/inventory yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){
                   openstockentrydialog(context);
                  }, child: Container(
                      decoration: BoxDecoration(
                          color:Colors.blue,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      padding: EdgeInsets.all(15),
                      child:Text("ADD STOCKS/ INVENTORIES", style:TextStyle(color:Colors.white)))),
                      SizedBox(height: 25,),

                ])))),
              MenuViewScreen(),
              RentedItemScreen()]),
        floatingActionButton:selectedindex==0?TextButton(
          onPressed: () async{
            await FirebaseAnalytics.instance.logEvent(
              name: "selected_to_add_stock",
              parameters: {
                "user_id":  userid,
              },
            );
            String stockname="", stockquantity="", amount="", sell_price="", unit="";
            showDialog(context: context,  builder: (BuildContext context)
            {
              return StatefulBuilder(builder: (BuildContext context, setState) {
                return AlertDialog(
                  content:Container( height: 400,child: SingleChildScrollView(child: Column(
                    children: [
                      Container(

                          child: TextField(decoration: InputDecoration(
                            labelText: "Stock name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              hintText: "Stock name".tr(),
                              prefixIcon: Icon(
                                  Icons.storage),),
                            onChanged: (value) {
                              stockname = value.trim();
                            },)
                      ),
                      SizedBox(height: 10,),
                      Container(
                          child: TextField(decoration: InputDecoration(
                              hintText: "Quantity".tr(),
                              labelText: "Quantity",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              // suffix: TextButton(onPressed: (){},child:Text("djh")),
                              prefixIcon: Icon(
                                  Icons.production_quantity_limits)),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              stockquantity = value.trim();
                            },)
                      ),
                      SizedBox(height: 10,),
                      Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                          child:SearchChoices.single(
                        displayClearIcon: false,
                        isExpanded: true,
                        hint: "Select stock unit",
                        searchHint: "Select stock unit",
                        items: items,
                        value: selectedValueSingleMenu,
                        onChanged: (value) {
                          setState(() {
                            unit = value;
                            selectedValueSingleMenu = value;
                          });
                        },
                      )),
                      SizedBox(height: 10,),
                      Container(
                        child: TextField(decoration: InputDecoration(
                            labelText: "Total cost of stock (in rupees)",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: "Total cost of stock (in rupees)".tr(),
                            prefixIcon: Icon(Icons.currency_rupee)),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            amount = value.trim();
                          },),
                      ),
                      SizedBox(height: 10,),
                      Text(selectedValueSingleMenu!=null?
                      "Selling price per $selectedValueSingleMenu (including taxes)"
                          :"Selling price per unit (including taxes)"),
                      SizedBox(height: 10,),
                      Container(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: selectedValueSingleMenu!=null?
                              "Selling price per $selectedValueSingleMenu (including taxes)"
                                  :"Selling price per unit (including taxes)",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              hintText: "Selling price per $selectedValueSingleMenu (including taxes)".tr(),
                              prefixIcon: Icon(Icons.currency_rupee)),
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.numberWithOptions(),
                            onChanged: (value) {
                              sell_price = value.trim();
                            },)
                      )
                    ],),),),
                  actions: [
                    Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [ Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: addstock,
                            child: Container(
                              // margin: EdgeInsets.only(top: 50, bottom: 30),
                                child: CircularProgressIndicator()
                            )
                        ),
                          Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: addstockbtn,
                              child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                color: Colors.blue,
                              ),width: double.maxFinite,
                                height: 40,
                                child:TextButton(onPressed: () async {
                                  setState((){addstock= true;
                                  addstockbtn= false;});
                                  String id = DateFormat("yyyyMMddHHmmss").format(
                                      DateTime.now());
                                  CheckUserConnection();
                                  if(stockname.isEmpty ||stockquantity.isEmpty || amount.isEmpty ||sell_price.isEmpty||
                                      stockquantity.startsWith("0",0)||
                                      stockquantity.startsWith("0",0)||
                                      amount.startsWith("0", 0) || sell_price.startsWith("0",0)){print("emptyname");
                                  setState((){addstock= false;
                                  addstockbtn= true;});
                                  Fluttertoast.showToast(msg: "Fields cannot be empty or start with 0.");}
                                  else if(unit.isEmpty){
                                    setState((){addstock= false;
                                    addstockbtn= true;});
                                    Fluttertoast.showToast(msg: "Kindly select unit.");
                                  }
                                  else {

                                    var url = Uri.https(stockapi, 'StockItemList/stockitem',{'id': userid+stockname});
                                    var response= await http.get(url );
                                    if (response.body.isEmpty) {print(int.parse(amount)/double.parse(stockquantity));
                                    if((double.parse(amount)/double.parse(stockquantity))<double.parse(sell_price)){
                                      await createStockItem(id, stockname, stockquantity, sell_price, amount,unit, DateFormat("yyyyMMddHHmmss").format(
                                          DateTime.now()) );
                                      await updatepaymentrecord(id, stockname, stockquantity, amount);
                                      await setdocument();
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "added_item_to_stock",
                                        parameters: {
                                          "user_id":  userid,
                                        },
                                      );
                                      Navigator.pop(context);
                                      setState((){addstock= false;
                                      selectedValueSingleMenu="";
                                      id="";
                                      addstockbtn= true;});}
                                    else{ Fluttertoast.showToast(msg: "Selling price should be grater then total/quantity.");
                                    setState((){addstock= false;
                                    id="";
                                    selectedValueSingleMenu="";

                                    addstockbtn= true;});}
                                    }
                                    else {
                                      Fluttertoast.showToast(
                                          msg: "This stockitem already exist kindly update quantity by going to that particular item");
                                      setState((){addstock= false;
                                      addstockbtn= true;});
                                      // getuserdetails();
                                      Navigator.pop(context);

                                    }
                                  }
                                  setState((){addstock= false;
                                  id="";
                                  addstockbtn= true;});
                                },
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: Colors.white,),
                                        Text("ADD", style: TextStyle( color: Colors.white,),),
                                      ],)
                                ),)),]),
                  ],
                );
              });
            });
          },
          child:Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
            // border: Border.all(3),
            color: Colors.blue,),
              padding:EdgeInsets.all(10),
              width:160,
              // height: 40,
              child:Row(
                  children:[Icon(Icons.add, color: Colors.white,),
                Text("NEW INVENTORY", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center, )
              ])),
        ):null,
      ),),
    );
  }
  setdocument()async{
     stocklist=[];
    await getstocklist(userid);
  }
  deletepaymentrecord(String id)async{
      List<PaymentRecords> PaymentRecordss = await Amplify.DataStore.query(PaymentRecords.classType,
          where:PaymentRecords.USER_ID.eq(userid).and(PaymentRecords.RECORD_ID.eq(id)));
      if(PaymentRecordss.isNotEmpty){
        await Amplify.DataStore.delete(PaymentRecordss[0]);
      }

  }
  updatepaymentrecord(id, stockname, stockquantity, amount) async {
    var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": userid+stockname,
          "user_id": userid,
          "record_id": id,
          "token_no": "",
          "order_id": "",
          "client_id": "",
          "received_amount": "0",
          "date":DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": amount,
          "description": "For the purchase of "+"Itemname : "+stockname +"\nQunatity : "+stockquantity
        }));
    print("${response.statusCode} paymentrecord");

  }
  openstockentrydialog(context){
    String stockname="", stockquantity="", amount="", sell_price="", unit="";
    showDialog(context: context,  builder: (BuildContext context)
    {
      return StatefulBuilder(builder: (BuildContext context, setState) {
        return AlertDialog(
          content:Container( height: 400,
            child:  SingleChildScrollView(child:Column(
              children: [
                Container(

                    child: TextField(decoration: InputDecoration(
                      labelText: "Stock name",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "Stock name".tr(),
                      prefixIcon: Icon(
                          Icons.storage),),
                      onChanged: (value) {
                        stockname = value.trim();
                      },)
                ),
                SizedBox(height: 10,),
                Container(
                    child: TextField(decoration: InputDecoration(
                        hintText: "Quantity".tr(),
                        labelText: "Quantity",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        // suffix: TextButton(onPressed: (){},child:Text("djh")),
                        prefixIcon: Icon(
                            Icons.production_quantity_limits)),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        stockquantity = value.trim();
                      },)
                ),
                SizedBox(height: 10,),
                Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5)),
                    child:SearchChoices.single(
                      displayClearIcon: false,
                      isExpanded: true,
                      hint: "Select stock unit",
                      searchHint: "Select stock unit",
                      items: items,
                      value: selectedValueSingleMenu,
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          unit = value;
                          selectedValueSingleMenu = value;
                        });
                      },
                    )),
                SizedBox(height: 10,),
                Container(
                  child: TextField(decoration: InputDecoration(
                      labelText: "Total cost of stock (in rupees)",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: "Total cost of stock (in rupees)".tr(),
                      prefixIcon: Icon(Icons.currency_rupee)),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      amount = value.trim();
                    },),
                ),
                SizedBox(height: 10,),
                Text(selectedValueSingleMenu!=null?
                "Selling price per $selectedValueSingleMenu (including taxes)"
                    :"Selling price per unit (including taxes)"),
                SizedBox(height: 10,),
                Container(
                    child: TextField(decoration: InputDecoration(
                        labelText: selectedValueSingleMenu!=null?
                        "Selling price per $selectedValueSingleMenu (including taxes)"
                            :"Selling price per unit (including taxes)",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: selectedValueSingleMenu!=null?
                        "Selling price per $selectedValueSingleMenu (including taxes)"
                            :"Selling price per unit (including taxes)",
                        prefixIcon: Icon(Icons.currency_rupee)),
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        sell_price = value.trim();
                      },)
                ),
              ],),)),
          actions: [
            Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [ Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: addstock,
                    child: Container(
                      // margin: EdgeInsets.only(top: 50, bottom: 30),
                        child: CircularProgressIndicator()
                    )
                ),
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: addstockbtn,
                      child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                        color: Colors.blue,
                      ),width: double.maxFinite,
                        height: 40,
                        child:TextButton(onPressed: () async {
                          setState((){addstock= true;
                          addstockbtn= false;});
                          String id = DateFormat("yyyyMMddHHmmss").format(
                              DateTime.now());
                          CheckUserConnection();
                          if(stockname.isEmpty ||stockquantity.isEmpty || amount.isEmpty ||sell_price.isEmpty||
                              stockquantity.startsWith("0",0)||
                              stockquantity.startsWith("0",0)||
                              amount.startsWith("0", 0) || sell_price.startsWith("0",0)){print("emptyname");
                          setState((){addstock= false;
                          addstockbtn= true;});
                          Fluttertoast.showToast(msg: "Fields cannot be empty or start with 0.");}
                          else if(unit.isEmpty){
                            setState((){addstock= false;
                            addstockbtn= true;});
                            Fluttertoast.showToast(msg: "Kindly select unit.");
                          }
                          else {
                            var url = Uri.https(stockapi, '/StockItemList/stockitem',{'id': userid+stockname});
                            var response= await http.get(url );
                            if (response.body.isEmpty) {
                            if((double.parse(amount)/double.parse(stockquantity))<double.parse(sell_price)){
                              await createStockItem(id, stockname, stockquantity, sell_price, amount,unit , DateFormat("yyyyMMddHHmmss").format(
                                  DateTime.now()));
                              await updatepaymentrecord(id, stockname, stockquantity, amount);
                              await setdocument();
                              Navigator.pop(context);
                              setState((){addstock= false;
                              selectedValueSingleMenu="";
                              id="";
                              addstockbtn= true;});}
                            else{ Fluttertoast.showToast(msg: "Selling price should be grater then total/quantity.");
                            setState((){addstock= false;
                            id="";
                            selectedValueSingleMenu="";

                            addstockbtn= true;});}
                            }
                            else {
                              Fluttertoast.showToast(
                                  msg: "This stockitem already exist kindly update quantity by going to that particular item");
                              setState((){addstock= false;
                              addstockbtn= true;});
                              // getuserdetails();
                              Navigator.pop(context);

                            }
                          }
                          setState((){addstock= false;
                          id="";
                          doc=Amplify.DataStore.query(StockList.classType,
                            where:StockList.USER_ID.eq(userid),);
                          addstockbtn= true;});
                        },
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white,),
                                Text("ADD", style: TextStyle( color: Colors.white,),),
                              ],)
                        ),)),]),
          ],
        );
      });
    });
  }
  checkstockexistanceinmenu(String id, String stockname, String sell_price, String unit) async {
    var url = Uri.https(menuapi, 'Item/item',{'id': userid+stockname});
    var response= await http.get(url );
    if (response.body.isEmpty) {
      var murl = Uri.https(menuapi, 'Item/item',);
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+stockname,
          "user_id": userid,
          "item_id": id,
          "item_unit": unit,
          "item_name": stockname,
          "item_price_per_unit": sell_price}),);
      print("Menu list add ${response.statusCode}");
    }
    else{
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['item_id'];
      var mresponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+stockname,
          "user_id": userid,
          "item_id": id,
          "item_unit": unit,
          "item_name": stockname,
          "item_price_per_unit": sell_price}),);
        print("Menu list update ${mresponse.statusCode}");

    }
  }
   checksifrecordexist(String stock_id, String stockname) async{
     var recstocklist=[];
     var url= Uri.https(stockrecapi, 'Stockrecord/stockrecords',);
     var response= await http.get(url );
     var tagObjsJson = jsonDecode(response.body)['products'] as List;
     print(tagObjsJson.length);
     for(int i=0; i<tagObjsJson.length; i++){
       var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
       if(jnResponse['user_id']==userid && jnResponse['stock_id']==stock_id){
         setState((){
           recstocklist.add(jnResponse);
         });
       }
     }
     if(recstocklist.length<=1){
       var murl = Uri.https(stockapi, 'StockItemList/stockitem',);
       final http.Response response = await http.delete(
           murl,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id":userid+stockname,})
       );
       if(response.statusCode==200){ print("stockdeleted ${response.statusCode}");
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



         if(recstocklist.length!=0){
           var url= Uri.https(stockrecapi, 'Stockrecord/stockrecord',);

         final http.Response response = await http.delete(
             url,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":recstocklist[0]['id'],})
         );
         if(response.statusCode==200){print("record deleted ${response.statusCode}");}
           var exurl = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord', {'id':userid+recstocklist[0]['stock_record_id'],});
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
           print(DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(recstocklist[0]['date'])));
           if(exresponse.statusCode==200){
             print("expanse record deleted ${exresponse.statusCode}");
             var exurl = Uri.https(expanseapi, 'Expanse/expanse' , {"id":userid+ (DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(recstocklist[0]['date']))).toString()});
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
                 "expanse": (double.parse(jsonResponse['expanse'])-double.parse(recstocklist[0]['stock_investment']) ).toString(),
                 "status": jsonResponse['status'],
                 "date":jsonResponse['date']
               }),);
             if(eresponse.statusCode==200){
               print("expanse updated ${eresponse.statusCode}");
             }
             var url= Uri.https(profitapi, 'Profit/profit',{'id':userid+ (DateFormat("yyyyMMdd").format(DateFormat("yyyy-MM-dd").parse(recstocklist[0]['date']))).toString()});
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
                   "profit": (double.parse(jsonesponse['profit'])+double.parse(recstocklist[0]['stock_investment'])).toString(),
                   "earned": jsonesponse['earned'],
                   "expanse": (double.parse(jsonesponse['expanse'])-double.parse(recstocklist[0]['stock_investment'])).toString(),
                   "date": jsonesponse['date'] ,
                   "month":jsonesponse['month'] ,
                   "year": jsonesponse['year']
                 }));
             print("profitupate  ${esponse.statusCode}");
             var mourl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id':userid+ (DateFormat("yMMMM").format(DateFormat("yyyy-MM-dd").parse(recstocklist[0]['date']))).toString()});
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
                     "monthly_profit": (double.parse(jsonesponse['monthly_profit'].toString())+double.parse(recstocklist[0]['stock_investment'])).toString(),
                     "Earned_amount":jsonesponse['Earned_amount'],
                     "Expanse_amount": (double.parse(jsonesponse['Expanse_amount'].toString())-double.parse(recstocklist[0]['stock_investment'].toString()) ).toString(),
                     "month": jsonesponse['month'],
                     "year": jsonesponse['year']
                   }));
             }
             }
           }}
         }
       }

     }
     else{
       Fluttertoast.showToast(
           msg: "Sorry this stock cannot be deleted from here you can delete particular record by going to history");}

  }
 createStockItem(String id, String stockname, String stockquantity, String sell_price, String amount, String unit, String idd) async {

   var url = Uri.https(stockapi, '/StockItemList/stockitem');
   var response = await http.post(url,   headers: <String, String>{
     'Content-Type': 'application/json; charset=UTF-8',
   },
       body: jsonEncode(<String, String>{
     "id":userid+stockname,
     "user_id": userid,
     "stock_id":id,
     "stock_name": stockname,
     "stock_quantity": stockquantity,
     "stock_investment": amount,
     "selling_price_per_unit": sell_price,
     "constant_quantity":stockquantity,
     "stock_status": complete,
     "stock_unit": unit,
       }),);
   if(response.statusCode==200){print('stockitem status: ${response.statusCode}');
     await createstockreport(id, stockname, stockquantity, amount, sell_price, unit, idd);
   }

  }
  createstockreport(String id, String stockname, String stockquantity, String amount, String sell_price, String unit, String idd) async {

    var url = Uri.https(stockrecapi, 'Stockrecord/stockrecord');
    var response = await http.post(
        url,
        headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
      "id":userid+idd,
      "user_id": userid,
      "stock_id": id,
      "stock_record_id": idd,
      "stock_quantity": stockquantity,
      "stock_investment": amount,
      "stock_unit": unit,
      "selling_price_per_unit": sell_price,
      "stock_name": stockname,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "time": DateFormat("HH:mm:ss").format(DateTime.now())}),);
    print('stockreport status: ${response.statusCode}');
    if(response.statusCode==200){
      await checkstockexistanceinmenu(id, stockname, sell_price, unit);
      addExpanse(idd,stockname,stockquantity,  amount);
    }
  }
  addExpanse(String id, String stockname, String stockquantity, String amount) async {
    String de= DateFormat("yyyyMMdd").format(DateTime.now());
    var url = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+id,
          "user_id": userid,
          "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
          "expanse_record_id":id,
          "expanse_name": stockname,
          "description": "Itemname : "+stockname +"\nQunatity : "+stockquantity,
          "investment": amount,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "status": paid
        }));
    print('expansereportResponse status: ${response.statusCode}');
    if(response.statusCode==200){
    await doesexpanseexistifdothenupdate(amount);
    await  doesProfitAlreadyExist(amount);
    }
  }
  Future<bool> doesProfitAlreadyExist(String amount) async {
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url= Uri.https(profitapi, 'Profit/profit',{'id': userid+proid});
    var response= await http.get(url );
    if(response.body.isEmpty){
      var purl = Uri.https(profitapi, 'Profit/profit');
      var response = await http.post(
          purl,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+proid,
            "user_i": userid,
            "profit_id": proid,
            "profit": "-$amount",
            "earned": "0",
            "expanse": amount,
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit add response ${response.statusCode}");

      if(response.statusCode==200){
        updateprofitMonthlyreport(amount);
      }
    }
    else{
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['investment'];
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+proid,
            "user_i": userid,
            "profit_id": proid,
            "profit": (double.parse(jsonResponse['profit'])-double.parse(amount)).toString(),
            "earned": jsonResponse['earned'],
            "expanse": (double.parse(jsonResponse['expanse'])+double.parse(amount)).toString(),
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit update response ${esponse.statusCode}");
      if(esponse.statusCode==200){
        updateprofitMonthlyreport(amount);
      }
    }

    return true;
  }
  updateprofitMonthlyreport(String amount) async{
    String monthid= DateFormat("yMMMM").format(DateTime.now());
    var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id': userid+monthid});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
       var jsonResponse =
       convert.jsonDecode(response.body) as Map<String, dynamic>;
       var itemCount = jsonResponse['investment'];
       var esponse = await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id": jsonResponse['id'],
             "user_id": jsonResponse['user_id'],
             "monthly_profit_id": jsonResponse['monthly_profit_id'],
             "monthly_profit": (double.parse(jsonResponse['monthly_profit'])-double.parse(amount)).toString(),
             "Earned_amount": jsonResponse['Earned_amount'],
             "Expanse_amount": (double.parse(jsonResponse['Expanse_amount'])+double.parse(amount) ).toString(),
             "month": jsonResponse['month'],
             "year": jsonResponse['year']
           }));

       print("profitmnthly update response ${response.statusCode}");

     }
    else{
    var murl= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord');
    var esponse = await http.post(
    murl,
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
    "id":userid+monthid,
    "user_id": userid,
    "monthly_profit_id":monthid,
    "monthly_profit": (0-double.parse(amount)).toString(),
    "Earned_amount": "0",
    "Expanse_amount": amount,
    "month": DateFormat("MMMM").format(DateTime.now()),
    "year": DateFormat("yyyy").format(DateTime.now())
    }));       print("profitmnthly add response ${response.statusCode}");
    }
  }
  doesexpanseexistifdothenupdate(String investment) async {
    String id= DateFormat("yyyyMMdd").format(DateTime.now());
    var url= Uri.https(expanseapi, 'Expanse/expanse',{'id': userid+id});
    var response= await http.get(url );
    print(response.body);

    if(response.body.isEmpty){
      var exurl= Uri.https(expanseapi, 'Expanse/expanse');
      var exresponse = await http.post(
          exurl,
          headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+id,
          "user_id": userid,
          "expanse_id": id,
          "expanse": investment,
          "status": paid,
          "date":DateFormat("yyyy-MM-dd").format(DateTime.now())
          }),);
      print("exresponse  ${exresponse.statusCode}");
    }
    else{var jsonResponse =
    convert.jsonDecode(response.body) as Map<String, dynamic>;
    var itemCount = jsonResponse['investment'];
    print("itemcount $itemCount");
      var exresponse = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "expanse_id": jsonResponse['expanse_id'],
          "expanse":  (double.parse(jsonResponse['expanse'])+double.parse(investment)).toString(),
          "status": paid,
          "date":jsonResponse['date']
        }),);
    print("exresponse update  ${exresponse.statusCode}");
    }
    print("investmen============================================================================= $investment");
  }
}



