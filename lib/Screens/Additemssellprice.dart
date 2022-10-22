import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:upi_india/upi_india.dart';
import 'package:upi_india/upi_response.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import '../main.dart';
import '../models/ModelProvider.dart';
import '../reusable_widgets/apis.dart';
import 'ChatPage.dart';
import 'Notifications.dart';
import 'SubscriptionModule.dart';
import 'login/Login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class addsellingpricetochatorder extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const addsellingpricetochatorder({Key? key, this.ccid, this.oid}) : super(key: key);
  final ccid, oid;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'Billing Coach',
              theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                  primaryColor: Colors.black,
                  brightness: Brightness.light,
                  primaryColorDark:Colors.white ),
              darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                  primaryColor: Colors.white,
                  brightness: Brightness.dark,
                  primaryColorDark:Colors.black ),

              themeMode: ThemeMode.system,
            home: addsellingpricetochatorderPage(clid: ccid,orid: oid)//:SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class addsellingpricetochatorderPage extends StatefulWidget {
  const addsellingpricetochatorderPage({Key? key,this.clid, this.orid}) : super(key: key);
  final clid, orid;
  @override
  State<addsellingpricetochatorderPage> createState() => _addsellingpricetochatorderState(clientid: clid,orderid: orid);
}
class _addsellingpricetochatorderState extends State<addsellingpricetochatorderPage> {
  _addsellingpricetochatorderState({this.clientid, this.orderid});
  final clientid, orderid;
  Future<UpiResponse>? _transaction;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  var doc;
  bool ActiveConnection = false;
  String T = "", sell_price="";
  String userid="", complete= "complete", removed= "removed";
  String pending= "Pending", delivered= "Delivered", cancelled= "Cancelled", sent="Sent", received="Received";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result. isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
  var total=0;
  List<String> pricelist=[];
  var categoryname;
  String  transactionid="", price="";
  String restroname="", phoneno="", address="", areacode="", profileimg="", paymode= "", deliverymode="", shpname="", shpid="";
  String itemimage="";
  String? selectedValueSingleMenu;
  String dmodesdel= "delivery", demodestk= "takeaway", paystatus="", shno="";
  List<DropdownMenuItem> items = [];
  var totalcost=0;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
var itemlist=[];
  bool addorder= false, addorderbtn=true;
  String? selectedValueSingleDialog;
  @override
  void initState() {
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
    getuserdetails();
 /*   doc= Amplify.DataStore.query(ChatItems.classType,
      where:ChatItems.USER_ID.eq(userid).and(ChatItems.CLIENT_ID.eq(clientid).and(ChatItems.CHAT_ID.eq(orderid))),
    );*/
    super.initState();
  }
  getuserdetails() async {
      final SharedPreferences prefs = await preferences;
      var counter = prefs.getString('user_Id');
      if(counter!=null){ await FirebaseAnalytics.instance.logEvent(
        name: "show_notification",
        parameters: {
          "user_id":  userid,
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
            restroname = jsonResponse['shop_name'].toString();
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
      await getitemlist(counter);
      }
      else{runApp(LoginScreen());}
  }
  Future<void> getitemlist(us)async{
    var url= Uri.https(chatitemsapi, 'ChatItem/chatitems',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us &&jnResponse['client_id']==clientid&&jnResponse['chat_id']==orderid){print("outgj-- $jnResponse");
      setState((){
       itemlist.add(jnResponse);
      });
      }
    }
  }

  Future<void>getsupllier()async{
      final Supplierss = await Amplify.DataStore.query(Suppliers.classType,
      where: Suppliers.SUPPLIER_ID.eq(clientid));
      if(Supplierss.isNotEmpty){
      setState((){
        shpname= Supplierss[0].shop_name.toString();
        shno= Supplierss[0].supplier_phone_no.toString();});}
      await FirebaseAnalytics.instance.logEvent(
        name: "selected_to_add_purchased_item_from_chat_on_stock",
      );
      }
  String paid= "Paid", payltr= "Pay later", payondelivery= "Pay on delivery";
  bool upi=false, cash= false, nw= false, timdel= false, paylater= false, delivery= false, takeaway= false;
  List<int> selectedItemsMultiMenu = [];

  Future<void> checkstockexistanceinmenu(String id, String stockname, String sell_price, String unit) async {
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
            "item_id": itemCount,
            "item_unit": unit,
            "item_name": stockname,
            "item_price_per_unit": sell_price}),);
      }

      /*List<MenuItems> MenuItemss = await Amplify.DataStore.query(MenuItems.classType,
      where: MenuItems.USER_ID.eq(userid).and(MenuItems.ITEM_NAME.eq(stockname)));

    if(MenuItemss.isEmpty){print("object");
    final item = MenuItems(
        user_id: userid,
        item_id: id,
        item_name: stockname,
        item_price_per_unit: sell_price,);
    await Amplify.DataStore.save(item).whenComplete(() {print("profitsucess");});
    }
    else{
      final updatedItem = MenuItemss[0].copyWith(
          user_id:MenuItemss[0].user_id,
          item_id:MenuItemss[0].item_id,
          item_name: MenuItemss[0].item_name,
          item_price_per_unit: MenuItemss[0].item_price_per_unit,);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete(() {print("itemupdated");
     });
    }
    return MenuItemss.length == 1;*/
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemid= <String>[];
    List<String> iteminvestment=[];
    List<String> itemquantity= <String>[];
    List<String> itemnamelist= <String>[];
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
        padding:EdgeInsets.all(4),child:Icon(Icons.arrow_back, color:Theme.of(context).primaryColor,))
            ,onPressed: () async {await FirebaseAnalytics.instance.logEvent(
              name: "open_Chatpage",
            );
            Navigator.push(context, MaterialPageRoute(builder: (context)=>  ChatItemsPage(clid:clientid)));}, ),
          title:Column(children: [Text(shpname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,
            color:Theme.of(context).primaryColor,),),
            Text(shno, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,
              color:Theme.of(context).primaryColor,),)],),

        ),
        body: RefreshIndicator(onRefresh: ()async{
          setState((){
          doc= Amplify.DataStore.query(ChatItems.classType,
            where:ChatItems.USER_ID.eq(userid).and(ChatItems.CLIENT_ID.eq(clientid).and(ChatItems.CHAT_ID.eq(orderid))),
          );});
        },
          child: SingleChildScrollView(scrollDirection: Axis.vertical,child:
        Container(//color: Theme.of(context).primaryColorDark,
          margin: EdgeInsets.only(top:10,bottom: 10, ),
          child: Column(children: [ Container(width: double.infinity,
            margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
            child:Table(
              defaultColumnWidth: IntrinsicColumnWidth(),
              children: [
                TableRow(
                    children: [
                      Column(children:[Container(width: 35,child:Text('Sno.', style: TextStyle(fontSize: 16.0)))]),
                      Column(children:[Container(width: 90,child:Text('Item name', style: TextStyle(fontSize: 16.0)))]),
                      Column(children:[Container(width: 200,child:Text('Selling Price', style: TextStyle(fontSize:16.0)))]),
                    ]),
              ],
            ) ,),
            /*FutureBuilder<List<ChatItems>>(
              future:  Amplify.DataStore.query(ChatItems.classType,
                where:ChatItems.USER_ID.eq(userid).and(ChatItems.CLIENT_ID.eq(clientid).and(ChatItems.CHAT_ID.eq(orderid))),
              ),
              builder: (context, snapshot) {print(snapshot);
            if (snapshot.hasError) {
              return Text('Something went wrong');
            } else if (snapshot.hasData || snapshot.data != null) {   print(itemlist.length);
            return*/ ListView.builder(
                shrinkWrap: true,
                itemCount: itemlist.length,
                itemBuilder: (BuildContext context, int index) {
                  itemid.add(itemlist[index]['item_id'].toString());
                  itemnamelist.add(itemlist[index]['item_name'].toString());
                  iteminvestment.add(itemlist[index]['item_total'].toString());
                  itemquantity.add(itemlist[index]['item_quantity'].toString());

                  return Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                    elevation: 4,
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                            children: [
                              Column(children:[Container(width: 35,padding: EdgeInsets.only(top:8, bottom:8),child:
                              Center(child:Text((index+1).toString(), style: TextStyle(fontSize: 16.0))))]),
                              Column(children:[Container(width: 90,padding: EdgeInsets.only(top:8, bottom:8),child:
                              Center(child:Text(itemlist[index].item_name.toString(), style: TextStyle(fontSize: 16.0))))]),
                              Column(children:[ Container(width: 200,
                                  child: TextField(decoration: InputDecoration(
                                      labelText: "Selling price per stock item",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      hintText: "Selling price per stock item".tr(),
                                      prefixIcon: Icon(Icons.price_change)),
                                    style: TextStyle(fontSize: 15),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      print(index);
                                      if(pricelist.length==index+1){
                                        pricelist[index]=value;}else{pricelist.add( value);}
                                    },)
                              ),]),
                            ]),
                      ],
                    ),

                  );
                }),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: addorder,
                child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: CircularProgressIndicator()
                )
            ),
            Visibility(
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: addorderbtn,
              child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius
                      .circular(15),
                    color: Colors.blue,
                  ), width: double.maxFinite,
                  height: 45,
                  margin: EdgeInsets.only(left:15, right: 15, bottom: 20),
                  child:  ElevatedButton(onPressed: ()async{
                    await FirebaseAnalytics.instance.logEvent(
                      name: "Added_ordered_item_fromchat_to_stock",
                      parameters: {
                        "user_id": userid,
                      },
                    );
                    setState((){addorder=true; addorderbtn= false;});
                    if(itemlist.length>pricelist.length){  setState((){addorder=false; addorderbtn= true;});
                    Fluttertoast.showToast(msg: "Kindly fill enter selling price for all items");}
                    else{//opendialogcompleted(context);
                      print(pricelist);
                      if(ActiveConnection== true){
                      for(int i=0; i<itemlist.length; i++){
                        await createStockItem(itemlist[i]['item_id'].toString(), itemlist[i]['item_name'].toString(),
                            itemlist[i]['item_quantity'].toString(), pricelist[i],  itemlist[i].item_total.toString(), itemlist[i]['item_unit'].toString());
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  ChatItemsPage(clid: clientid,),
                        ),
                      );
                      }else{
                        Fluttertoast.showToast(msg: "No Internet connection.");
                      }
                      setState((){addorder=false; addorderbtn= true;
                      });
                    }

                  }, child: Container(height:35,margin: EdgeInsets.only(top: 10), child:Text("Order", textAlign: TextAlign.center,style: TextStyle(fontSize: 20),)))),
            ),
          ],),
        ), ) ,)
       ,
      ),);
  }
  createStockItem(String id, String stockname, String stockquantity, String sell_price, String amount, String unit) async{

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
        "stock_unit": unit}),);
    if(response.statusCode==200){print('Response status: ${response.statusCode}');
    await createstockreport(id, stockname, stockquantity, amount, sell_price, unit,  DateFormat("yyyyMMddHHmmss").format(
        DateTime.now()));
    }
    /*   List<StockList> StockLists = await Amplify.DataStore.query(StockList.classType,
      where: StockList.USER_ID.eq(userid).and(StockList.STOCK_NAME.eq(stockname)));

   if(StockLists.isEmpty){
      final item = StockList(
          user_id: userid,
          stock_id:id,
          stock_name: stockname,
          stock_quantity: stockquantity,
          stock_investment: amount,
          selling_price_per_unit: sell_price,
          constant_quantity:stockquantity,
          stock_status: complete,);
      await Amplify.DataStore.save(item).whenComplete(() async{
      print("finished");
      await createstockreport(id, stockname, stockquantity, amount, sell_price);  });
  }else{
      final item = StockLists[0].copyWith(
          user_id: StockLists[0].user_id,
          stock_id:StockLists[0].stock_id,
          stock_name: StockLists[0].stock_name,
          stock_quantity: (double.parse(stockquantity)+double.parse(StockLists[0].stock_quantity.toString())).toString(),
          stock_investment: (double.parse(amount)+double.parse(StockLists[0].stock_investment.toString())).toString(),
          selling_price_per_unit: sell_price,
          constant_quantity:(double.parse(stockquantity)+double.parse(StockLists[0].stock_quantity.toString())).toString(),
          stock_status: StockLists[0].stock_status,);
      await Amplify.DataStore.save(item)
          .whenComplete(() async{
        print("finished");
        await createstockreport(id, stockname, stockquantity, amount, sell_price);  });
    }*/
  }
  createstockreport(String id, String stockname, String stockquantity, String amount, String sell_price, String unit, String idd) async {

    var url = Uri.https(stockrecapi, 'Stockrecord/stockrecord');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id":userid+stockname+id,
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
    print('Response status: ${response.statusCode}');
    if(response.statusCode==200){ print('reportResponse status: ${response.statusCode}');
    await checkstockexistanceinmenu(id, stockname, sell_price, unit);
    }

  }
  addExpanse(String id, String stockname, String stockquantity, String amount) async {
    String de= DateFormat("yyyyMMdd").format(DateTime.now());
    final item = ExpanseRecord(
        user_id: userid,
        expanse_id: id,
        expanse_record_id: DateFormat("yyyyMM").format(DateTime.now()),
        expanse_name: stockname,
        description: "Itemname : "+stockname +"\nQunatity : "+stockquantity,
        investment: amount,
        date: DateFormat("yyyyMMdd").format(DateTime.now()),
        time: DateFormat("yyyyMMdd").format(DateTime.now()),
        status: paid);
    await Amplify.DataStore.save(item)
        .whenComplete(() {doesexpanseexistifdothenupdate(amount);
    doesProfitAlreadyExist(amount);});
  }
  Future<bool> doesProfitAlreadyExist(String amount) async {
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    final Profits = await Amplify.DataStore.query(Profit.classType,
        where: Profit.USER_I.eq(userid).and(Profit.PROFIT_ID.eq(proid)));
    print(proid);
    print(Profits);
    if(Profits.isEmpty){print("object");
    var profit= 0;
    final item = Profit(
        user_i: userid,
        profit_id: proid,
        profit: (profit-double.parse(amount)).toString(),
        earned: "0",
        expanse: amount,
        date: DateFormat("yMMMMdd").format(DateTime.now()) ,
        month: DateFormat("MMMM").format(DateTime.now()) ,
        year: DateFormat("yyyy").format(DateTime.now()) );
    await Amplify.DataStore.save(item)
        .whenComplete(() {print("profitsucess");
    updateprofitMonthlyreport(amount);
    } );
    }
    else{
      final updatedItem = Profits[0].copyWith(
          user_i: Profits[0].user_i,
          profit_id: Profits[0].profit_id,
          profit: (double.parse(Profits[0].profit.toString())-double.parse(amount)).toString(),
          earned: Profits[0].earned,
          expanse: (double.parse(Profits[0].expanse.toString())+double.parse(amount)).toString(),
          date: Profits[0].date,
          month: Profits[0].month,
          year: Profits[0].year);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete((){ print("updateprofitsucess");updateprofitMonthlyreport(amount);});
    }
    return Profits.length == 1;
  }
  updateprofitMonthlyreport(String amount) async{
    String monthid= DateFormat("yMMMM").format(DateTime.now());

    final ProfitMonthlyRecords = await Amplify.DataStore.query(ProfitMonthlyRecord.classType,
        where: ProfitMonthlyRecord.USER_ID.eq(userid).and(ProfitMonthlyRecord.MONTHLY_PROFIT_ID.eq(monthid)));
    if(ProfitMonthlyRecords.isEmpty)  {
      final item = ProfitMonthlyRecord(
          user_id: userid,
          monthly_profit_id: monthid,
          monthly_profit: (0-double.parse(amount)).toString(),
          Earned_amount: "0",
          Expanse_amount: amount,
          month: DateFormat("MMMM").format(DateTime.now()),
          year: DateFormat("yyyy").format(DateTime.now()));
      await Amplify.DataStore.save(item)
          .whenComplete((){ print("profitsucess");});}
    else{
      final updatedItem = ProfitMonthlyRecords[0].copyWith(
          user_id: ProfitMonthlyRecords[0].user_id,
          monthly_profit_id: ProfitMonthlyRecords[0].monthly_profit_id,
          monthly_profit: (double.parse(ProfitMonthlyRecords[0].monthly_profit.toString())-double.parse(amount)).toString(),
          Earned_amount: ProfitMonthlyRecords[0].Earned_amount,
          Expanse_amount: (double.parse(ProfitMonthlyRecords[0].Expanse_amount.toString())+double.parse(amount) ).toString(),
          month: ProfitMonthlyRecords[0].month,
          year: ProfitMonthlyRecords[0].year);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete(() {
        print("profitsucess");
      });
    }
  }
  doesexpanseexistifdothenupdate(String investment) async {
    String id= DateFormat("yyyyMM").format(DateTime.now());
    final Expanses = await Amplify.DataStore.query(Expanse.classType,
        where: Expanse.USER_ID.eq(userid).and(Expanse.EXPANSE_ID.eq(id)));
    if(Expanses.isNotEmpty){
      final updatedItem = Expanses[0].copyWith(
          user_id: Expanses[0].user_id,
          expanse_id: Expanses[0].expanse_id,
          expanse: (double.parse(Expanses[0].expanse.toString())+double.parse(investment)).toString(),
          status: paid,
          date: Expanses[0].date);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete(() => print("expanseupdated"));
    }
    else{
      final item = Expanse(
          user_id: userid,
          expanse_id: id,
          expanse: investment,
          status: paid,
          date:DateFormat("yyyy-MM-dd").format(DateTime.now()));
      await Amplify.DataStore.save(item)
          .whenComplete(() => print("expanserecord created"));

    }
  }
  Future<UpiResponse> initiateTransaction(UpiApp app, String clntupid,String clntshopname ) async {
    var uuid = Uuid();
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: clntupid,
      receiverName: clntshopname,
      transactionRefId: uuid.v4(options: {
        'rng': UuidUtil.cryptoRNG
      }),
// -,
      transactionNote: 'Not actual. Just an example.',
      amount: 1.00,
    );
  }
  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app, shpid, shpname );
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }
  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred';
    }
  }
  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }
  Widget displayTransactionData(title, body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", ),
          Flexible(
              child: Text(
                body,
              )),
        ],
      ),
    );
  }
  opendialogcompleted(BuildContext context) {
    showDialog(
        context: context,
        builder:  (BuildContext context)
        {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Container(
                width: 400,
                height: 200,
                padding: EdgeInsets.all(30),
                child:Column(children: [
                  SizedBox(height: 15,),
                  Lottie.asset('assets/animations/placeorder.json'),
                ],),
              ),
              actions: [],
            );
          });
        });
  }

// maintainduesuserend(String paystatus, int total) async {
  //   String status= "";
  //   if(paystatus==paid){total=0;}
  //   final QuerySnapshot<Map<String, dynamic>> reslt = await
  //   FirebaseFirestore.instance.collection(userid+"_Suppliers_dues_" +clientid).get();
  //   final List<DocumentSnapshot> documents = reslt.docs;
  //   final QuerySnapshot<Map<String, dynamic>> clresult = await
  //   FirebaseFirestore.instance.collection(clientid+"_Suppliers_dues_" +userid).get();
  //   final List<DocumentSnapshot> cldocuments = clresult.docs;
  //   if(documents.isNotEmpty){
  //     DocumentReference docs= FirebaseFirestore.instance.collection(userid+"_Suppliers_dues_"+clientid)
  //         .doc(reslt.docs[0].get("record_id"));
  //     Map<String, String>dueusertodoList = {
  //       "time":DateFormat("HH:mm:ss").format(DateTime.now()),
  //       "date":DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //       "sent_amount":(double.parse(reslt.docs[0].get("sent_amount"))+total).toString(),
  //       "total":"0",
  //       "status":pending,
  //     };
  //     DocumentReference docsclient= FirebaseFirestore.instance.collection(clientid+"_Suppliers_dues_"+userid)
  //         .doc(clresult.docs[0].get("record_id"));
  //     Map<String, String>dueclienttodoList = {
  //       "time":DateFormat("HH:mm:ss").format(DateTime.now()),
  //       "date":DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //       "Payment_status":received,
  //       "received_amount":(double.parse(clresult.docs[0].get("received_amount"))+total).toString(),
  //       "total":"0",
  //       "status":pending,
  //     };
  //     await docs.update(dueusertodoList).whenComplete(() => print("userdue"));
  //     await docsclient.update(dueclienttodoList).whenComplete(() => print("clientdue"));
  //   }
  //   else{
  //     String id= DateFormat("yyMMddHHmmss").format(DateTime.now());
  //     DocumentReference docs= FirebaseFirestore.instance.collection(userid+"_Suppliers_dues_"+clientid).doc(id);
  //     Map<String, String>dueusertodoList = {
  //       "userid":userid,
  //       "record_id":id,
  //       "time":DateFormat("HH:mm:ss").format(DateTime.now()),
  //       "date":DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //       "client_id": clientid,
  //       "amount_to_be_receive":"0",
  //       "amount_to_be_send":"0",
  //       "Payment_status":paystatus,
  //       "sent_amount":total.toString(),
  //       "total":total.toString(),
  //       "status":pending,
  //     };
  //     DocumentReference docsclient= FirebaseFirestore.instance.collection(clientid+"_Suppliers_dues_"+userid).doc(id);
  //     Map<String, String>dueclienttodoList = {
  //       "userid":clientid,
  //       "record_id":id,
  //       "time":DateFormat("HH:mm:ss").format(DateTime.now()),
  //       "date":DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //       "client_id": userid,
  //       "Payment_status":received,
  //       "total":(-total).toString(),
  //       "received_amount":total.toString(),
  //       "amount_to_be_receive":"0",
  //       "amount_to_be_send":"0",
  //       "status":pending,
  //     };
  //     await docs.set(dueusertodoList).whenComplete(() => print("userdue"));
  //     await docsclient.set(dueclienttodoList).whenComplete(() => print("clientdue"));
  //   }
  // }

}


