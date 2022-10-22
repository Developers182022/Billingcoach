import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/AppFeature.dart';
import '../models/AppSubscription.dart';
import '../models/Appfaqs.dart';
import '../models/ModelProvider.dart';
import '../models/Rzorkey.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'HomePage.dart';
import 'login/Login.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class SubscriptionModule extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SubscriptionModule({Key? key, this.ccid}) : super(key: key);
  final ccid;
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
            home:   SubscriptionModulePage(clid: ccid),
          );
        });
  }
}
class SubscriptionModulePage extends StatefulWidget {
  const SubscriptionModulePage({Key? key,this.clid}) : super(key: key);
  final clid;
  @override
  State<SubscriptionModulePage> createState() => _SubscriptionModuleState(clientid: clid);
}
class _SubscriptionModuleState extends State<SubscriptionModulePage> {
  _SubscriptionModuleState({this.clientid});
  final clientid;
  bool ActiveConnection = false;
  String T = "";
  String pending= "Pending", delivered= "Delivered", cancelled= "Cancelled", sent="Sent", received="Received";
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
  var timeout= false;
  bool additem=false, additembtn=true, edititem=false, edititembtn= true;
  var pla1descrpt="",pla2descrpt= "", pla3descrpt="", pla4descrpt= "";
  var pl1valid= "", pl2valid="", pl3valid= "", pl4valid="";
  var pl1chrg= "", pl2chrg="", pl3chrg= "", pl4chrg="";
  var total=0;
  String expired= "Expired";
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  var featuredoc;
  String price="";
  String userid= "";
  String restroname="", phoneno="", address="", areacode="", profileimg="", paymode= "", deliverymode="";
  var difference=0;
  String itemimage="", subscriptionstatus="";
  String? selectedValueSingleMenu;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  List<DropdownMenuItem> items = [];
  bool addorder= false, addorderbtn=true;
  String? selectedValueSingleDialog;
  String planid= "";
  String ?_paymentMethodId;
  String? _errorMessage = "";
  var _isNativePayAvailable = false;
  Razorpay? razorpay;
  var date, eda;
  var faewwsd;
  TextEditingController textEditingController = new TextEditingController();
  String k="";
  String status="", exdate="", email="";


  @override
  void initState() {
    CheckUserConnection();
    getplansdetails();
    print(faewwsd);
    getkey();
    getuserdetails();
    razorpay = new Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
    var now = new DateTime.now();
    var noww= DateFormat("yy-MM-dd").format(DateTime.now());
    var det= DateFormat("yy-MM-dd").parse(noww);
    print(det);
    print(difference);
    super.initState();
  }
  Future<void> getuserdetails() async {
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      setState((){userid=counter;});
      await getsubscription(counter);
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



      /* List<Rzorkey> RzorKeys = await Amplify.DataStore.query(Rzorkey.classType);
     if(RzorKeys.isNotEmpty){
       setState((){link=RzorKeys[0].link.toString(); });
     }
     List<UserToken> UserTokens = await Amplify.DataStore.query(UserToken.classType,
         where: UserToken.USER_ID.eq(userid));
     if(UserTokens.isEmpty){
       await FirebaseMessaging.instance.getToken().then(
               (token) async {
             print(user.userId);
             final item = UserToken(
                 user_id: user.userId,
                 token: token);
             await Amplify.DataStore.save(item);});}*/
    }
    else{runApp(LoginScreen());}
  }
  /*{
    try{
      AuthUser user= await Amplify.Auth.getCurrentUser();
      if(user==null){runApp(LoginScreen());}
      setState((){userid= user.userId;
      featuredoc= Amplify.DataStore.query(AppFeature.classType);
      email= user.username;});
      await getsubscription( user.userId);
      if(plans.isEmpty){
        Future.delayed(Duration(seconds: 15), () {
          setState(() {
            timeout=true;
          });
        });
      }
      await getplansdetails();
      List<Suppliers> Userdetailss = await Amplify.DataStore.query(Suppliers.classType,
          where: Suppliers.SUPPLIER_ID.eq(user.userId));
      if(Userdetailss.isNotEmpty){
        setState(() {
          restroname = Userdetailss[0].shop_name.toString();
          phoneno = Userdetailss[0].username.toString();
          address = Userdetailss[0].supplier_name.toString();
          areacode = Userdetailss[0].pincode.toString();
        });}
    }catch(e){
      runApp(LoginScreen());
    }
  }*/
  Future<void> handlerPaymentSuccess(PaymentSuccessResponse response) async {
    print("Pament success--------------- ${response.paymentId}========== ${response.signature}---------------- ${response.paymentId}");
    var kyurl= Uri.https(plansapi, 'AppPlan/appplan',{'id':planid});
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty) {   var noww= DateFormat("yy-MM-dd").format(DateTime.now());
    var det= DateFormat("yy-MM-dd").parse(noww);
      var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
      var kurl= Uri.https(subscript, 'AppSubscription/appsubscriptions',{'id':userid} );
      var resp=  await http.get(kurl );
      if(resp.body.isNotEmpty){print("object");
          var jResponse = convert.jsonDecode(resp.body) as Map<String, dynamic>;
          var response = await http.post(kurl,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id": jResponse['id'],
            'user_id': jResponse['user_id'],
            'plan_id':jsonResponse['plan_id'],
            'transaction_id': jResponse['transaction_id'],
            'plan':jsonResponse['plan'],
            'issue_date': jResponse['issue_date'],
            'expiry_date': (DateFormat("yy-MM-dd").parse(jResponse['expiry_date'].toString()).add(Duration(days:int.parse(jsonResponse['plan_validfor'].toString())))).toString(),
            'plan_charges': jsonResponse['plan_offer_charges'],
            'status': "Active",
            "valid_till": (DateFormat("yy-MM-dd").parse(jResponse['expiry_date'].toString()).add(Duration(days:int.parse(jsonResponse['plan_validfor'].toString())))).toString(),//DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(savedDateString);
          }),);
      print("object   ${response.statusCode}");
      }
      else{
        var resse = await http.post(kurl,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":userid,
            'user_id': userid,
            'plan_id':planid,
            'transaction_id': response.paymentId.toString(),
            'plan':jsonResponse['plan'],
            'issue_date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
            'expiry_date':DateFormat("yy-MM-dd").format(DateTime.now().add(
                Duration(days: int.parse(jsonResponse['plan_validfor'].toString()),)) ),
            'plan_charges': jsonResponse['plan_offer_charges'],
            'status': "Active",
            "valid_till": DateFormat("yy-MM-dd").format(DateTime.now().add(
                Duration(days: int.parse(jsonResponse['plan_validfor'].toString()),)) ) }),);
        print("respoiuytrfdvbjkuyg      ${resse.statusCode}");
        await FirebaseAnalytics.instance.logEvent(
    name: "brought_subscription_page",
    parameters: {
    "user_id":  userid,
    "plan":jsonResponse['plan'].toString()
    },
    );
      }
    }
  }
  void handlerErrorFailure()async{
    await FirebaseAnalytics.instance.logEvent(
      name: "payment_error_subscription_page",
      parameters: {
        "user_id":  userid,
      },
    );
    print("Pament error");
    Fluttertoast.showToast(msg: "Payment error");
  }
  void handlerExternalWallet()async{
    await FirebaseAnalytics.instance.logEvent(
      name: "externalwallet_subscription_page",
      parameters: {
        "user_id":  userid,
      },
    );
    print("External Wallet");
    Fluttertoast.showToast(msg: "External Wallet");
  }
  bool upi=false, cash= false, paylater= false, delivery= false, takeaway= false;
  String inactive= "Inactive", active= "Active";
  String appname="Billing Coach";
  var totalcost=0;
  var plans=[];
  var plan1validity="",plan2validity="",plan3validity="",plan4validity="";
  var plan1offer="",plan2offer="",plan3offer="",plan4offer="";
  var plan1id="",plan2id="",plan3id="",plan4id="";
  var plan1=false, plan2= false, plan3=false, plan4= false;
 Future<List> getfeatures()async {
    var appfeqature=[];
    var turl = Uri.https(appfeaturesapi, 'AppFeatureApi/appfeaturelists',);
    var tresponse = await http.get(turl);
    if(tresponse.body.isNotEmpty){
      var tagObjsJson = jsonDecode(tresponse.body)['products'] as List;
      for (int i = 0; i < tagObjsJson.length; i++) {
        if(this.mounted) {
          setState(() {
            appfeqature.add(tagObjsJson[i]);
          });
        }
      }
    }
    return appfeqature;
  }
  getplansdetails() async {///AppPlan/appplans
    var kyurl= Uri.https(plansapi, 'AppPlan/appplans',);
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(kresponse.body)['products'] as List;
      for(int i=0; i<jsonResponse.length; i++){
        var jnResponse = jsonResponse[i] as Map<String, dynamic>;
        plans.add(jnResponse);
        if(i==0){
          setState((){
            plan1id=       jnResponse['id'].toString();
            pla1descrpt=   jnResponse['plan'].toString();
            pl1valid=      jnResponse['plan_validity'].toString();
            pl1chrg=       jnResponse['plan_offer_charges'].toString();
            plan1validity= jnResponse['plan_validfor'].toString();
            plan1offer=    jnResponse['plan_offer'].toString();
          });  }
        if(i==1){setState((){
          plan2id=        jnResponse['id'].toString();
          pla2descrpt=    jnResponse['plan'].toString();
          pl2valid=       jnResponse['plan_validity'].toString();
          pl2chrg=        jnResponse['plan_offer_charges'].toString();
          plan2validity=  jnResponse['plan_validfor'].toString();
          plan2offer=     jnResponse['plan_offer'].toString();
        });
        }
        if(i==2){
          setState((){
            plan3id=      jnResponse['id'].toString();
            pla3descrpt=  jnResponse['plan'].toString();
            pl3valid=     jnResponse['plan_validity'].toString();
            pl3chrg=      jnResponse['plan_offer_charges'].toString();
            plan3validity=jnResponse['plan_validfor'].toString();
            plan3offer=   jnResponse['plan_offer'].toString();
          }); }
        if(i==3){
          setState((){
            plan4id=          jnResponse['id'].toString();
          pla4descrpt=        jnResponse['plan'].toString();
          pl4valid=           jnResponse['plan_validity'].toString();
          pl4chrg=            jnResponse['plan_offer_charges'].toString();
          plan4validity=      jnResponse['plan_validfor'].toString();
          plan4offer=         jnResponse['plan_offer'].toString();
          }); }
      }
    }
  }
  Future<List> getappfaqs()async{
    var  faqs=[];
    var kyurl= Uri.https(helpapi, 'AppFaqs/appfaqlists',);
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(kresponse.body)['products'] as List;
      for(int i=0; i<jsonResponse.length; i++){
        var jnResponse = jsonResponse[i] as Map<String, dynamic>;
        faqs.add(jnResponse);
      }}
    return faqs;
  }
  Future<void> getsubscription( uid) async {
    var noww= DateFormat("yy-MM-dd").format(DateTime.now());
    var det= DateFormat("yy-MM-dd").parse(noww);
    var kyurl= Uri.https(subscript, 'AppSubscription/appsubscriptions',{'id':uid} );
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
        print("poiuy76t54rewaszdxcfgvbhjkio0987=============   "+jsonResponse['status'].toString());
        setState((){ status = jsonResponse['status'].toString();
        exdate= jsonResponse['expiry_date'].toString();});
        print(jsonResponse['expiry_date'].toString());
        if(exdate.isNotEmpty){
          var date= DateFormat("yy-MM-dd").parse(jsonResponse['expiry_date'].toString());
          setState((){difference= date.difference(det).inDays;
          print(date.difference(det).inDays);});}
        print('dtegdtdg      ${jsonResponse['status'].toString()}');
        if(jsonResponse['status'].toString()!="Inactive"){print("moccccccccccccccccccc");runApp(Home());}
        else{
          var date = DateFormat("yyyy-MM-dd").format(DateTime.now());
          var cdate= DateFormat("yyyy-MM-dd").parse(date);
          var exdate= jsonResponse['expiry_date'].toString();
          var edate= DateFormat("yy-MM-dd").parse(exdate);
          print(edate.difference(cdate).inDays);
          if(edate.difference(cdate).inDays<=0){print("uhbftr");
          var response = await http.post(kyurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id": jsonResponse['id'],
              'user_id': jsonResponse['user_id'],
              'plan_id':jsonResponse['plan_id'],
              'transaction_id': jsonResponse['transaction_id'],
              'plan':jsonResponse['plan'],
              'issue_date': jsonResponse['issue_date'],
              'expiry_date': jsonResponse['expiry_date'],
              'plan_charges': jsonResponse['plan_charges'],
              'status': "Inactive",
              "valid_till": jsonResponse['valid_till']}),);
          }
        }
    }
    else{
      if(timeout==true){Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "Kindly refresh page if you already purchased subscription and subscription validity is not expired, if not please purchase to proceed further.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Do you want to go back?'),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              });
          return false;
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor:Theme.of(context).primaryColorDark,
            title:Text("Subscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color:Theme.of(context).primaryColor,),),
            actions: [
              IconButton(tooltip:"Tap to reload page.",
                  onPressed: ()async{await FirebaseAnalytics.instance.logEvent(
                    name: "refreshed_by_icon_from_subscription",
                    parameters: {
                      "user_id":  userid,
                    },
                  );

                  CheckUserConnection();
                  await getsubscription(userid);
                  await getuserdetails();
                  await getplansdetails();
                  await getkey();
                  }, icon: Icon(Icons.refresh,color:Theme.of(context).primaryColor,)),
              difference<=0?PopupMenuButton(
                icon:Icon(Icons.more_vert, color:Theme.of(context).primaryColor,),
                position: PopupMenuPosition.under,
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      child:     TextButton(onPressed: () async {CheckUserConnection();
                      final UserTokens = await Amplify.DataStore.query(UserToken.classType,
                          where: UserToken.USER_ID.eq(userid));
                      if(UserTokens.isNotEmpty){
                        await FirebaseAnalytics.instance.logEvent(
                          name: "Signed_out_from_subscription",
                          parameters: {
                            "user_id":  userid,
                          },
                        );
                        await Amplify.DataStore.delete(UserTokens[0]);}
                      await Amplify.Auth.signOut().whenComplete(()  {
                        print("Signed Out");
                        runApp(LoginScreen());});
                      }, child: Row(children: [
                        Icon(Icons.logout ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Sign Out".tr(),style: TextStyle()),
                      ],)
                      ),
                    ),
                  ];
                },
              ):Container(),
            ],
          ),
          body: RefreshIndicator( onRefresh: ()async{
            await FirebaseAnalytics.instance.logEvent(
              name: "refreshed_from_subscription",
              parameters: {
                "user_id":  userid,
              },
            );
            CheckUserConnection();
            await getsubscription(userid);
            await getuserdetails();
            await getplansdetails();
          },child: plans.isNotEmpty?
          SingleChildScrollView(//color: Theme.of(context).primaryColorDark,
            scrollDirection: Axis.vertical,
            child: Column(children: [
              status ==inactive?Container(width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                child:Card(child: Container(
                  child: Row(children:[
                    Icon(Icons.details),
                    Text("Your Subscription has expired"),
                    Text("Renew Subscription")]),
                ),),)
                  :status.isNotEmpty?Container(width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                child:Card(elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(children:[
                      Icon(Icons.details),
                      Text("Your Subscription will be expire after "+difference.abs().toString()+"days"),]),
                  ),),):Container(),
              Container(margin:EdgeInsets.only(left:15, right:15, top: 15),child:Row(children: [
                Image.asset('assets/logofront.png', height: 40,width: 40,),
                SizedBox(width:8),
                Text("$appname Subscription", style: TextStyle(fontSize: 18),) ,
              ],)),
              Container(margin:EdgeInsets.all(10),child:Row(children: [ Text("Subscription plans")],)),
              Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(value: this.plan1, onChanged: (bool?value){
                      setState(() {this.plan1=value!;
                      plan2=false;plan3=false;plan4=false;
                      });
                    }),
                    title:Container(child:  Row(children: [
                      Text(pla1descrpt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),],),),
                    // subtitle: Text("validity "+pl1valid),
                    trailing: Text("₹ "+pl1chrg,style: TextStyle(fontSize: 18, ) ,),
                  )

              ),
              Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(value: this.plan2, onChanged: (bool?value){
                      setState(() {this.plan2=value!;
                      plan1= false;
                      plan3= false;plan4= false;
                      });
                    }),
                    title: Row(children: [
                      Text(pla2descrpt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),],),
                    // subtitle: Text("validity "+pl2valid),
                    trailing: Text("₹ "+pl2chrg, style: TextStyle(fontSize: 18),),
                  )

              ),
              Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                  elevation: 4,
                  child: ListTile(
                    leading: Checkbox(value: this.plan3, onChanged: (bool?value){
                      setState(() {this.plan3=value!;
                      plan1= false;
                      plan2= false;
                      plan4= false;
                      });
                    }),
                    title: Row(children: [
                      Text(pla3descrpt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),],),
                    // subtitle: Text("validity "+pl3valid),
                    trailing: Text("₹ "+pl3chrg,  style: TextStyle(fontSize: 18),),
                  )
              ),
              Card(margin: EdgeInsets.only(left: 10, right: 10, top: 8, ),
                  elevation: 2,
                  child: ListTile(
                    leading: Checkbox(value: this.plan4, onChanged: (bool?value){
                      setState(() {this.plan4=value!;
                      plan1=false;plan2=false;plan3=false;
                      });
                    }),
                    title: Row(children: [
                      Text(pla4descrpt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),],),
                    // subtitle: Text("validity "+pl4valid),
                    trailing: Text("₹ "+pl4chrg,  style: TextStyle(fontSize: 18),),
                  )

              ),

              Container(width:double.infinity,
                padding:EdgeInsets.all(15),
                child: Text("Why you should must subscribe $appname", style: TextStyle(fontSize: 16),),),
              Container(
                margin: EdgeInsets.only(left: 8,right: 8),
                height: 250,
                child:  FutureBuilder<List>(
                    future:  getfeatures(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      } else if (snapshot.hasData || snapshot.data != null) {
                        return
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context,index){
                                return Card(child: Container(width: 320,
                                  padding: EdgeInsets.all(15),
                                  child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(height: 25,width: 25,
                                          child:Lottie.network(snapshot.data![index]['feature_id'].toString())),
                                      SizedBox(height: 10,),
                                      Text(snapshot.data![index]['feature_name'].toString()),
                                      SizedBox(height: 8,),
                                      Text(snapshot.data![index]['feature_description'].toString()),
                                    ],),));}); }  return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueGrey,
                          ),
                        ),
                      );}),),
              SizedBox(height: 10,),
              Container(child: Text("FAQs"),),
              Container(margin: EdgeInsets.only(bottom: 15, top: 15),child:
              FutureBuilder<List>(
                future: getappfaqs(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ExpansionTile(
                              title: Text(snapshot.data![index]['faq_question'].toString()),
                              children: [
                                Divider(height: 2,),
                                Container(width:double.infinity,
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.all( 15),
                                  child:Text(snapshot.data![index]['faq_answer'].toString()),)
                              ],
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
            ],),
          ):
          Center(child:
          timeout==true? Column(children:[
            Lottie.asset("assets/animations/timeout.json", height: 250, width: 300),
            Container(padding:EdgeInsets.all(15),
                child:Text("Opps! TimeOut..")),
            TextButton(onPressed: ()async{
              await FirebaseAnalytics.instance.logEvent(
                name: "reloaded_subscription_page",
                parameters: {
                  "user_id":  userid,
                },
              );
              setState((){ featuredoc= Amplify.DataStore.query(AppFeature.classType);
              timeout=false;
              });
              CheckUserConnection();
              await getsubscription(userid);
              await getuserdetails();
              await getplansdetails();
              await getkey();
            }, child: Container(
                decoration: BoxDecoration(
                    color:Colors.blue,
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(15),
                child:Text("Reload", style:TextStyle(color:Colors.white)))),
          ]):
          Column(children:[
            Lottie.asset("assets/animations/loading.json", height: 250, width: 300),
          ]))),
          bottomNavigationBar: SizedBox(
            height: 60,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: double.infinity,
                    height:40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent),
                    child:  TextButton(onPressed: () async {
                   /*   await FirebaseAnalytics.instance.logEvent(
                        name: "selected_to_buy_subscription",
                        parameters: {
                          "user_id":  userid,
                        },
                      );*/
                      await CheckUserConnection();
                       /* getsubscription(userid);
                        await getuserdetails();
                        await getkey();*/
                        if(plan1==true){ planid= plan1id;}
                        if(plan2==true){ planid= plan2id;}
                        if(plan3==true){ planid= plan3id;}
                        if(plan4==true){ planid= plan4id;}
                        print("oiuytfdc $planid");
                        await BuySubscription(planid);/*}else{
                        Fluttertoast.showToast(msg: "No Internet Connection.");
                      }*/
                    }, child: Text("Buy Subscription", style: TextStyle(color: Colors.white),)),)
                ],
              ),
            ),
          ),

        ));
  }
  Future BuySubscription(String panid) async {
    print("$k  -----");
    await getkey();
    var kyurl= Uri.https(plansapi, 'AppPlan/appplan',{'id':panid});
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty) {
      var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
      print(jsonResponse['plan_charges']);
      var options = {
        "key" :k,
        "amount" :int.parse(jsonResponse['plan_offer_charges'].toString())*100,
        "name" : " Billing Coach",
        "description" : "Payment for "+ jsonResponse['plan'].toString() +" Subscription.",
        "prefill" : {
          "contact" : "",
          "email" : userid
        },
        "external" : {
          "wallets" : ["paytm"],
        }
      };
      try{
        razorpay!.open(options);
      }catch(e){
        print(e.toString());
      }
    }
    else{Fluttertoast.showToast(msg: "Kindly select a plan to proceed further.");}
  }
  Future getkey() async {
    var kyurl= Uri.https(rkey, 'Rzorkey/rzorkey',{'id': "1"} );
    var kresponse= await http.get(kyurl );
    if(kresponse.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(kresponse.body) as Map<String, dynamic>;
      setState((){
        k= jsonResponse['key'].toString();});

    }
    }
}
