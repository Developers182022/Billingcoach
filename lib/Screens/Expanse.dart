import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:search_choices/search_choices.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:toggle_list/toggle_list.dart';

import '../models/Expanse.dart';
import '../models/ExpanseRecord.dart';
import '../models/MenuItems.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/StockList.dart';
import '../reusable_widgets/apis.dart';
import 'login/Login.dart';
class couchExpanse extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const couchExpanse({Key? key}) : super(key: key);
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
              darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                  primaryColor: Colors.white,
                  brightness: Brightness.dark,
                  primaryColorDark:Colors.black ),

              themeMode: ThemeMode.system,
            home: const couchExpansePage(user: "userid")//:SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class couchExpansePage extends StatefulWidget {
  const couchExpansePage({Key? key, required this.user}) : super(key: key);
  final String user;
  @override
  State<couchExpansePage> createState() => _couchExpansePageState();
}
class _couchExpansePageState extends State<couchExpansePage> {
  bool ActiveConnection = false;
  String T = "";
  int reqcount=0;
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
  var paid = "Paid";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String selectedTime = DateFormat("HH:mm:ss").format(DateTime.now());
  List todos = List.empty();
  String name = "";
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
  final _testList = ['Date',];
  TextEditingController myController = TextEditingController();
  String userid= "";
  String restroname="", phoneno="", address="", areacode="", email="";
  var dd= TextDecoration.none;
  @override
  void initState() {
    CheckUserConnection();
    getuserid();
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
            child: Text(wordPair),
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
    );
    super.initState();
  }
 var expanselist=[];
  Future<void> getexpanselist(us)async{
    var url= Uri.https(expanseapi, 'Expanse/expanses',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us){print("outgj-- $jnResponse");
      setState((){
        expanselist.add(jnResponse);
      });
      }
    }
    print(expanselist);

  }
  Future<void> getuserid() async {
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
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
      await getexpanselist(counter);}
    else{runApp(LoginScreen());}
  }

   doesProfitAlreadyExist(String name) async {
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url =
    Uri.https(profitapi, 'Profit/profit', {'id': userid+'${DateFormat("yyyyMMdd").format(DateTime.now())}'});
    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');
      var reponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":jsonResponse['id'],
          "user_i": jsonResponse['user_i'],
          "profit_id": jsonResponse["profit_id"],
          "profit":(double.parse(jsonResponse["profit"])-double.parse(name)).toString(),
          "earned": jsonResponse["earned"],
          "expanse": (double.parse(jsonResponse["expanse"])+double.parse(name)).toString(),
          "date": jsonResponse['date'],
          "month": jsonResponse['month'],
          "year": jsonResponse['year']}),);
      if(reponse.statusCode==200){
        await updateprofitMonthlyreport(name);
      }

    }
    else{
      var murl =Uri.https(profitapi, 'Profit/profit');
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
          "user_i": userid,
          "profit_id": DateFormat("yyyyMMdd").format(DateTime.now()),
          "profit":(0-double.parse(name)).toString(),
          "earned": "0",
          "expanse": name,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "month": DateFormat("MMMM").format(DateTime.now()),
          "year": DateFormat("yyyy").format(DateTime.now())}),);
      if(response.statusCode==200){
        await updateprofitMonthlyreport(name);
      }
    }

  }
  updateprofitMonthlyreport(name) async {
    String monthid= DateFormat("yMMMM").format(DateTime.now());
    var url =
    Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord', {'id':userid+ '$monthid'});
    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');
      var reponse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "monthly_profit_id": jsonResponse['monthly_profit_id'],
          "monthly_profit": (double.parse(jsonResponse['monthly_profit'])-double.parse(name)).toString(),
          "Earned_amount": jsonResponse['Earned_amount'],
          "Expanse_amount":(double.parse(jsonResponse['Expanse_amount'])+double.parse(name)).toString() ,
          "month": jsonResponse['month'],
          "year": jsonResponse['year']}),);
      if(reponse.statusCode==200){
        print("profitsucess");
      }
    }
    else{
      var murl =Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord');
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
          "user_id": userid,
          "monthly_profit_id": monthid,
          "monthly_profit": (0-double.parse(name)).toString(),
          "Earned_amount": "0",
          "Expanse_amount": name,
          "month": DateFormat("MMMM").format(DateTime.now()),
          "year": DateFormat("yyyy").format(DateTime.now())}),);
      if(response.statusCode==200){
        print("profitsucess");
      }

    }

  }
  late String dropdownvalue;
  final String item = "GST , Rent , Electricity Bill , Travelling , Bank Fee , Employee Salary ,"
      " Repair Maintenance , EMI , Raw Material , Other ";
  List dataList = [];
  var expanseitemlist=[];
  String _selectedDate="";
  DateTime _dateTime= DateTime(2015);
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  TextEditingController filtercontroller= TextEditingController();
  String? selectedValueSingleDialog;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
 Future<List> expanserecordlist(us, date)async{
    var expanseitemlist=[];
    var url= Uri.https(expanserecapi, 'ExpanseRecord/expanserecords',);
    var response= await http.get(url );
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==us &&jnResponse['date'] ==date){print("outgj-- $jnResponse");
        setState((){
          expanseitemlist.add(jnResponse);
        });
      }
    }
    return expanseitemlist;
  }
   doesmonthlyprofitexist(String expn, String exdate) async {
     print("DEFERG");
     final Profits = await Amplify.DataStore.query(Profit.classType,
     where: Profit.USER_I.eq(userid).and(Profit.PROFIT_ID.eq(exdate.replaceAll("-", "") )));
     final ProfitMonthlyRecords = await Amplify.DataStore.query(ProfitMonthlyRecord.classType,
         where: ProfitMonthlyRecord.USER_ID.eq(userid).and(ProfitMonthlyRecord.MONTH.eq(Profits[0].month))
             .and(ProfitMonthlyRecord.YEAR.eq(Profits[0].year)));
     if(ProfitMonthlyRecords.isNotEmpty){
       final updatedItem = ProfitMonthlyRecords[0].copyWith(
           user_id:  ProfitMonthlyRecords[0].user_id,
           monthly_profit_id:  ProfitMonthlyRecords[0].monthly_profit_id,
           monthly_profit:  (double.parse(ProfitMonthlyRecords[0].monthly_profit.toString())+double.parse(expn)).toString(),
           Earned_amount:ProfitMonthlyRecords[0].Earned_amount,
           Expanse_amount:( double.parse(ProfitMonthlyRecords[0].Expanse_amount.toString())-double.parse(expn)).toString(),
           month: ProfitMonthlyRecords[0].month,
           year: ProfitMonthlyRecords[0].year);
       await Amplify.DataStore.save(updatedItem).whenComplete(() => print("Deedewfiuewuuuuuu"));
     }
   }
  Future<void> doesProfitExist(String amount, String nj, String exid, String exdate) async {
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    final Profits = await Amplify.DataStore.query(Profit.classType,
        where: Profit.PROFIT_ID.eq(proid ));
    print(proid);
    print(Profits);
    if(Profits.isNotEmpty){
      final updatedItem = Profits[0].copyWith(
          user_i: Profits[0].user_i,
          profit_id: Profits[0].profit_id,
          profit:(double.parse(Profits[0].profit.toString())+ double.parse(amount)).toString(),
          earned: Profits[0].earned,
          expanse: (double.parse(Profits[0].expanse.toString())-double.parse(amount)).toString(),
          date: Profits[0].date,
          month: Profits[0].month,
          year: Profits[0].year);
      await Amplify.DataStore.save(updatedItem)
          .whenComplete(() async { print("updateprofitsucess");
      checkifexpanseisgeneratedfromstockandremove(amount, exid);
      });
    }
    else{}
    // return Profits.length == 1;
  }
  checkifexpanseisgeneratedfromstockandremove(String name, String id)async{
   final StockLists = await Amplify.DataStore.query(StockList.classType,
   where: StockList.USER_ID.eq(userid).and(StockList.STOCK_ID.eq(id)));
   if(StockLists.isNotEmpty){
   await Amplify.DataStore.delete(StockLists[0]).whenComplete(() {checkstockitematmenulistifexistremove(id);
   print("deleted from stock");});}
  }
  checkstockitematmenulistifexistremove(String id) async{
    final MenuItemss = await Amplify.DataStore.query(MenuItems.classType,
    where: MenuItems.USER_ID.eq(userid).and(MenuItems.ITEM_ID.eq(id)));
     if(MenuItemss.isNotEmpty){
       await Amplify.DataStore.delete(MenuItemss[0]).whenComplete(() {
       print("deleted from menu");});
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:RefreshIndicator(onRefresh: ()async{
        setState((){doc= Amplify.DataStore.query(Expanse.classType,
          where:Expanse.USER_ID.eq(userid),
        );});
      },
          child:expanselist.isNotEmpty?Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child:/*FutureBuilder<List<Expanse>>(
          future:  doc,
          builder: (context, napshot) {
            if (napshot.hasError) {
              return Text('Something went wrong');
            } else if (napshot.hasData || napshot.data!= null) {
              return*/ ToggleList(
                divider: const SizedBox(height: 10),
                toggleAnimationDuration: const Duration(milliseconds: 400),
                scrollPosition: AutoScrollPosition.begin,
                trailing: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.expand_more),
                ),
                children: List.generate(expanselist.length, (index) => ToggleListItem(//parent list
                  title: Padding(
                    padding: const EdgeInsets.only(left:10, right: 10, top:5, bottom: 5),
                    child:ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title:Text("Expanse:  ₹"+ expanselist[index]['expanse'].toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 15),
                      ),
                      trailing:  Container(
                        child: Text(expanselist[index]['date'].toString(),
                          style: Theme.of(context)
                              .textTheme.headline6!
                              .copyWith(fontSize: 15),),),),
                  ),
                  content: Container(
                          child: FutureBuilder<List>(
                            future: expanserecordlist(userid, expanselist[index]['date']),
                            builder: (context, snapshot) {totalexpanse=0;
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            else if (snapshot.hasData || snapshot.data != null) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (BuildContext context, int indx) {
                                    var st= snapshot.data![indx]['status'].toString();
                                    if(st==status){visible=true; print("object------$st");
                                    dd=TextDecoration.none;}
                                    else if(st==removed){visible=false;
                                    dd=TextDecoration.lineThrough;
                                    print("object---$st");}
                                    return  Card(
                                      elevation: 4,
                                      child: ListTile(
                                        // leading: documentSnapshot![index],
                                          title: Row(children: [Container(width: 180,
                                            child: Text(snapshot.data![indx]['expanse_name'].toString(),
                                              style: TextStyle(decoration: snapshot.data![indx]['status'].toString()==removed?TextDecoration.lineThrough:TextDecoration.none),),),
                                           ],),
                                          subtitle:  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text( "Investment :  ₹"+snapshot.data![indx]['investment'].toString()),
                                              ]),
                             trailing:  Container(
                                 child:Text(snapshot.data![indx]["time"].toString(), style: TextStyle(fontSize: 15),)),
                    /* trailing:snapshot.data![indx].status!=removed?
                              IconButton(onPressed: () async {CheckUserConnection();
                              String expn =  snapshot.data![indx].investment.toString();
                              String exdate=  snapshot.data![indx].date.toString();
                              String expanseid= snapshot.data![indx].expanse_record_id.toString();
                              String stname= snapshot.data![indx].expanse_name.toString();
                              print("notobject");
                              final updatedItem = snapshot.data![indx].copyWith(
                                  user_id: snapshot.data![indx].user_id,
                                  expanse_id: snapshot.data![indx].expanse_id,
                                  expanse_record_id: snapshot.data![indx].expanse_record_id,
                                  expanse_name: snapshot.data![indx].expanse_name,
                                  description: snapshot.data![indx].description,
                                  investment: snapshot.data![indx].investment,
                                  date: snapshot.data![indx].date,
                                  time: snapshot.data![indx].time,
                                  status: removed);
                              await Amplify.DataStore.save(updatedItem)
                                  .whenComplete(() async { print("success");
                                   await doesexpanseexist(snapshot.data![indx].investment.toString(),
                                       snapshot.data![indx].expanse_id.toString());
                              doesmonthlyprofitexist(expn, exdate);
                              doesProfitExist(expn, stname, expanseid, exdate);
                                  setdocument();});}, icon: Icon(Icons.delete_outline)):null*/
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
                  headerDecoration: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  expandedHeaderDecoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    )),/* ),
    ),
                ),);
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.red,
                ),
              ),
            );
          },
        ),*/
      )))):
          Center(child:
          Column(children:[
            SizedBox(height: 15,),
            Lottie.asset("assets/animations/expanse.json", height: 250, width: 300),
            SizedBox(height: 10,),
            Text("You haven't added any expanse yet.",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            TextButton(onPressed: (){
             openexpansedialog(context);
            }, child: Container(
                decoration: BoxDecoration(
                    color:Colors.blue,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(15),
                child:Text("ADD EXPANSE", style:TextStyle(color:Colors.white))))
          ])),),
      floatingActionButton:TextButton(
        onPressed: () async {
          await FirebaseAnalytics.instance.logEvent(
            name: "select_to_add_expanse",
          );
          showDialog(
              context: context,
              builder: (BuildContext context){
                return  StatefulBuilder(builder:  (BuildContext context, setState){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Expanse"),
                  content: Container(
                    width: 400,
                    margin: EdgeInsets.only(top: 15, bottom: 16),
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                    height:300,
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: SearchChoices.single(
                          isExpanded: true,
                          hint: "Select Items",
                          searchHint: "Select Items",
                          items: items,
                          value: selectedValueSingleMenu,
                          onChanged: (value) {
                            setState(() {
                              selectedValueSingleMenu = value;
                              // if(selectedValueSingleMenu)
                            });
                          },
                        )),
                        const SizedBox(
                          height:10,
                        ),
                        Container(
                          child: TextField(decoration: InputDecoration(hintText: "Description",prefixIcon: Icon(Icons.keyboard),
                            // fillColor: Colors.blueGrey.withOpacity(0.5),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),),
                            style: TextStyle(),
                            onChanged: (String value) {
                              description = value.trim();
                            }, keyboardType: TextInputType.text,

                          ),),
                        const SizedBox(
                          height:10,
                        ),
                        Container(
                          child: TextField(decoration: InputDecoration(
                            hintText: "Enter amount",prefixIcon: Icon(Icons.currency_rupee),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),),
                            style: TextStyle(),
                            onChanged: (String value) {
                              investment = value.trim();
                            }, keyboardType: TextInputType.number,

                          ),),
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
                      visible: addexpanse,
                      child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      ),width: 30,
                          margin: EdgeInsets.only(bottom: 12),
                          child: CircularProgressIndicator()),
                    ),
                    Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: addexpansebtn,
                        child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),width: double.maxFinite,
                      height: 40,
                    child:TextButton(
                      onPressed: () async {setState((){
                        addexpanse= true;
                      addexpansebtn=false;});
                        CheckUserConnection();
                      if(selectedValueSingleMenu==null || investment.isEmpty  || investment.startsWith("0",0)){
                        Fluttertoast.showToast(msg: "Fields cannot be empty or start with 0.");
                        setState(() {
                        addexpanse= false;
                        addexpansebtn= true;
                        });
                        }
                      else {
                        expanse_id =
                            DateFormat("yyMMddHHmmss").format(DateTime.now());
                        String date = DateFormat("yyyyMMdd").format(
                            DateTime.now());
                        createExpanse(selectedValueSingleMenu.toString(), description, investment);
                        await FirebaseAnalytics.instance.logEvent(
                          name: "add_expanse",
                        );
                          setdocument();
                          setState(() {
                          addexpanse = false;
                          addexpansebtn = true;
                        });
                           Navigator.pop(context);
                      }
                      },
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add,color: Colors.white,),
                          SizedBox(width: 20,),
                          Text('ADD EXPANSE',style: TextStyle(color: Colors.white, fontSize: 20),textAlign: TextAlign.center,),
                        ],
                      ),)
                          ,),)]),
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
            ),SizedBox(width:4),Text("ADD EXPANSE", style: TextStyle(color:Colors.white),)],) /*],) ,*/
          // backgroundColor: Colors.blue,
        ),

      ),
    );
  }
  createExpanse(selected, description, investment)async{
    var murl = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord',);
    var response = await http.post(murl,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id":userid+DateFormat("yyyyMMddHHmmss")
            .format(DateTime.now()),
        "user_id": userid,
        "expanse_id": DateFormat("yyyyMMdd").format(
            DateTime.now()),
        "expanse_record_id": DateFormat("yyyyMMddHHmmss")
            .format(DateTime.now()),
        "expanse_name": selectedValueSingleMenu.toString(),
        "description": description,
        "investment": investment,
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
        "time": DateFormat("HH:mm:ss").format(DateTime.now()),
        "status": "Paid"}),);
    print(response.body );
    print(response.statusCode);
    if(response.statusCode==200){
      await doesexpanseexistifdothenupdate(investment);

    }else{
      Fluttertoast.showToast(msg: "Something went wrong, please try again.");
    }
  }


  openexpansedialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return  StatefulBuilder(builder:  (BuildContext context, setState){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: const Text("Add Expanse"),
              content: Container(
                width: 400,
                margin: EdgeInsets.only(top: 15, bottom: 16),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                height:300,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: SearchChoices.single(
                          isExpanded: true,
                          hint: "Select Items",
                          searchHint: "Select Items",
                          items: items,
                          value: selectedValueSingleMenu,
                          onChanged: (value) {
                            setState(() {
                              selectedValueSingleMenu = value;
                              // if(selectedValueSingleMenu)
                            });
                          },
                        )),
                    const SizedBox(
                      height:10,
                    ),
                    Container(
                      child: TextField(decoration: InputDecoration(hintText: "Description",prefixIcon: Icon(Icons.keyboard),
                        // fillColor: Colors.blueGrey.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),),
                        style: TextStyle(),
                        onChanged: (String value) {
                          description = value.trim();
                        }, keyboardType: TextInputType.text,

                      ),),
                    const SizedBox(
                      height:10,
                    ),
                    Container(
                      child: TextField(decoration: InputDecoration(
                        hintText: "Enter amount",prefixIcon: Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),),
                        style: TextStyle(),
                        onChanged: (String value) {
                          investment = value.trim();
                        }, keyboardType: TextInputType.number,

                      ),),
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
                        visible: addexpanse,
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                        ),width: 30,
                            margin: EdgeInsets.only(bottom: 12),
                            child: CircularProgressIndicator()),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: addexpansebtn,
                        child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                          color: Colors.blue,
                        ),width: double.maxFinite,
                          height: 40,
                          child:TextButton(
                            onPressed: () async {setState((){
                              addexpanse= true;
                              addexpansebtn=false;});
                            CheckUserConnection();
                            if(selectedValueSingleMenu==null || investment.isEmpty  || investment.startsWith("0",0)){
                              Fluttertoast.showToast(msg: "Fields cannot be empty or start with 0.");
                              setState(() {
                                addexpanse= false;
                                addexpansebtn= true;
                              });
                            }
                            else {
                              expanse_id =
                                  DateFormat("yyMMddHHmmss").format(DateTime.now());
                              String date = DateFormat("yyyyMMdd").format(
                                  DateTime.now());
                                  createExpanse(selectedValueSingleMenu.toString(), description, investment);
                                  await FirebaseAnalytics.instance.logEvent(
                                  name: "add_expanse",
                                  );
                                setdocument();
                                setState(() {
                                  addexpanse = false;
                                  addexpansebtn = true;
                                });
                                Navigator.pop(context);
                            }
                            },
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment:MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text('ADD EXPANSE',style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.center,),
                              ],
                            ),)
                          ,),)]),
              ],
            );
          });
        });
  }
  setdocument()async{
    expanselist=[];
    await getexpanselist(userid);
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
  doesexpanseexistifdothenupdate(String investment) async {
    var url =
    Uri.https(expanseapi, 'Expanse/expanse', {'id': userid+'${DateFormat("yyyyMMdd").format(DateTime.now())}'});
    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['totalItems'];
      print('Number of books about http: $itemCount.');

      var reonse = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":jsonResponse['id'],
          "user_id": jsonResponse['user_id'],
          "expanse_id": jsonResponse['expanse_id'],
          "expanse": (double.parse(jsonResponse['expanse'].toString())+double.parse(investment)).toString(),
          "status": "Paid",
          "date": jsonResponse['date']}),);
      if(reonse.statusCode==200){
        await doesProfitAlreadyExist(investment);
      }
    } else {
      var murl =
      Uri.https(expanseapi, 'Expanse/expanse');
      var response = await http.post(murl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":userid+DateFormat("yyyyMMdd").format(DateTime.now()),
          "user_id": userid,
          "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
          "expanse": investment,
          "status": "Paid",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now())}),);
      if(response.statusCode==200){
        await doesProfitAlreadyExist(investment);
      }
    }

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

  // getnotificationscount(String userid) {
  //   Future<void> docu = FirebaseFirestore.instance.collection(userid+"_Supplier_request").where("date", isEqualTo:DateFormat("yyyy-MM-dd").format(DateTime.now())
  //   ).get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((result) {
  //       setState((){
  //         reqcount=reqcount+1;
  //       });
  //     });
  //   });
  // }

}
