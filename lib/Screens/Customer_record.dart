import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webappbillingcoach/Screens/printcustomerreport.dart';
import '../models/CustomerLis.dart';
import '../reusable_widgets/apis.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class CustomerScreenRecord extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const CustomerScreenRecord({Key? key, this.ccid, this.iid}) : super(key: key);
  final ccid, iid;
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
            home: CustomerRecordPage(clid: ccid, ccid: iid)//: SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class CustomerRecordPage extends StatefulWidget {
  const CustomerRecordPage({Key? key,this.clid, this.ccid}) : super(key: key);
  final clid, ccid;
  @override
  State<CustomerRecordPage> createState() => _CustomerRecordState(clientid: clid, cid: ccid);
}
class _CustomerRecordState extends State<CustomerRecordPage> {
  _CustomerRecordState({this.clientid, this.cid});
  final clientid, cid;
  var customer= 'Customer', paid= 'Paid';
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
  File? file;
  List<String> itemlist=["item1", "item2"];
  List<String> _list= [];
  String msg="";
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  String date="";
  var customerrecordlist=[];
  String time="";
  String userid= "";
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  String restroname="", phoneno="", username="", areacode="", profileimg="", due="",
      pending="Pending", amount="", cname="", suppliername="", custoemerid='';
  Future<void> getcustomerdetails(useid) async {
    var url= Uri.https(customerlistapi, 'CustomerList/customerlist',{'id':cid});
    var response= await http.get(url );
    var tagObjsJson = jsonDecode(response.body) as Map<String, dynamic>;
      if(tagObjsJson['user_id']==useid && tagObjsJson['customer_id']==clientid ){
      setState((){
        custoemerid= tagObjsJson['id'].toString();
        due=      tagObjsJson['pending_amount'   ].toString();
        cname=    tagObjsJson['customer_name'    ].toString();
        phoneno=  tagObjsJson['customer_phone_no'].toString();
        _list.add(tagObjsJson['customer_phone_no'].toString());
      });
      }

    var curl= Uri.https(customerrecordapi, 'CustomerRecords/customerrecords',);
    var cresponse= await http.get(curl );
    var ctagObjsJson = jsonDecode(cresponse.body)['products'] as List;
    print(ctagObjsJson.length);
    for(int i=0; i<ctagObjsJson.length; i++){
      var jnResponse = ctagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==useid && jnResponse['client_id']==clientid ){
        setState((){
          customerrecordlist.add(jnResponse);
        });
      }
    }
    print("customerrecordlist  $customerrecordlist");
  }
  Future<void> getcurrentuser()async {
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
            phoneno = jsonResponse['username'].toString();
            areacode = jsonResponse['supplier_name'].toString();
          });}
      }
      await getcustomerdetails(counter);}
    else{runApp(LoginScreen());}
  
  }
  @override
  void initState() {
    CheckUserConnection();
    getcurrentuser();
    super.initState();
  }
  setdocument(){
    customerrecordlist=[];
    getcustomerdetails(userid);
    }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body:RefreshIndicator(onRefresh: ()async{setdocument();},
            child: Container(height: double.infinity,
          margin: EdgeInsets.only(bottom: 10, top: 10),
          child:SingleChildScrollView(scrollDirection: Axis.vertical,
            child:Column(children: [
            Card(child:Container(width: double.infinity,
              padding: EdgeInsets.only(left:25, right: 25,),
              child:ListTile(
                  leading:Text("Due amount"),
                trailing:Text("₹"+due)
            )),),
            phoneno==""?Container(width: double.infinity,
                  padding: EdgeInsets.only(left:25, right: 25, ),
                  child: Row(
                  children:[ Text(" Customer contact to send reminder"),
                    TextButton(child: Text("Add"), onPressed: ()async{
                      await FirebaseAnalytics.instance.logEvent(
                        name: "add_customer_no",
                      );
                      showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text("Add "+ cname +" Mob.no."),
                        content:Container(height: 150,
                            width: double.infinity,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Column(children: [
                              Container(
                                child: TextField(decoration: InputDecoration(hintText: "Mobile no.".tr(),
                                    labelText:"Mobile no.",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),prefixIcon: Icon(Icons.phone)),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value){
                                    investment= value.trim();
                                  }, ),
                              ),
                              Container(child: ElevatedButton(child: Text("SAVE"),onPressed: () async {
                                if(investment.isEmpty|| investment.startsWith("0",0)|| investment.length!=10){
                                  Fluttertoast.showToast(msg: "Mobile no. cannot be less then 10 digits or starts with 0");
                                }else{
                                  setState((){ investment= "91"+investment; });
                                  var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',{
                                    'id':custoemerid
                                  });
                                  var res= await http.get(murl);
                                  if(res.body.isNotEmpty){
                                    var tagObjsJson = jsonDecode(res.body) as Map<String, dynamic>;
                                  var response = await http.post(murl,
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, String>{
                                      "id":tagObjsJson['id'],
                                      "user_id": tagObjsJson['user_id'],
                                      "customer_id":tagObjsJson['customer_id'],
                                      "customer_name": tagObjsJson['customer_name'],
                                      "customer_phone_no": investment,
                                      "advance_amount": tagObjsJson['advance_amount'],
                                      "pending_amount": tagObjsJson['pending_amount'],
                                      "date": tagObjsJson['date'],
                                      "time": tagObjsJson['time']}),);
                                  setState(() {additem = false;});
                                  if(response.statusCode==200){  setdocument(); await FirebaseAnalytics.instance.logEvent(
                                    name: "added_customemobile_fromrecord",
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
                                  }}
                                Navigator.pop(context);
                                }
                              },),)],) ),
                      );
                    });},),

                  ])):Container(),
            Card(child:
              Container(margin: EdgeInsets.only(left: 25, right: 25),child:
              Row(
                children: [TextButton(onPressed: () async {
                  await FirebaseAnalytics.instance.logEvent(
                  name: "customer_Report",
                );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrintReport(clid: clientid)));},child: Column(children: [Icon(Icons.picture_as_pdf), Text("Report")],),),
                  TextButton(onPressed: ()async{
                    await FirebaseAnalytics.instance.logEvent(
                      name: "remind_customer_no",
                    );
                    print(phoneno);
                    if(phoneno==""){
                      Fluttertoast.showToast(msg: "Add customer contact to send reminder");
                      }else{
                    showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: Text("Remind"),
                      content: Container(height:100,
                        child:SingleChildScrollView(child: Row(children: [
                          Card(child: TextButton(onPressed: (){_makePhoneCall(phoneno);},child:Column(children: [Icon(Icons.phone), Text("Via Call")],) ,),),
                          Card(child: TextButton(onPressed: (){sending_SMS(msg, _list);},child:Column(children: [Icon(Icons.message), Text("Via Sms")],) ,),),
                          Card(child: TextButton(onPressed: (){_launchWhatsapp(context, phoneno);},child:Column(children: [Icon(FontAwesomeIcons.whatsapp),
                            Center(child: Text("Via\n WhatsApp"),)],),),)
                        ],),),) ,
                    );
                  });}},child: Column(children: [Icon(Icons.details), Text("Remind")],),),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAnalytics.instance.logEvent(
                        name: "you_got_amount",

                      );
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          var note='';
                          return SizedBox(
                            height: 220,
                            child: SingleChildScrollView(scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  <Widget>[
                                  SizedBox(height: 15,),
                                  TextField(decoration: InputDecoration(hintText: "Enter amount".tr(),
                                      labelText:"Enter amount",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),prefixIcon: Icon(Icons.currency_rupee)),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value){
                                      amount= value.trim();
                                    }, ),
                                  SizedBox(height: 15,),
                                  TextField(decoration: InputDecoration(hintText: "Note (Optional)".tr(),
                                      labelText:"Note (Optional)",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),prefixIcon: Icon(Icons.note_alt)),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value){
                                      note= value.trim();
                                    }, ),
                                  TextButton(onPressed: () async {
                                    if(amount.isEmpty || amount.startsWith("0",0)){
                                      Fluttertoast.showToast(msg: "Field cannot be empty or starts with 0.");
                                    }
                                    else{
                                      var url = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
                                      var response = await http.post(url,   headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                        body: jsonEncode(<String, String>{
                                          "id":userid+DateFormat("yyyyMMddHHmmss").format(
                                              DateTime.now()),
                                          'user_id': userid,
                                          'client_id': clientid,
                                          'record_id': DateFormat("yyyyMMddHHmmss").format(
                                              DateTime.now()),
                                          'payment_status': "Paid",
                                          'payment_mode': "",
                                          'transaction_id': "",
                                          'received_amount':amount,
                                          'sent_amount': "0",
                                          'party_name':cname,
                                          'date': DateFormat("yyyy-MM-dd").format(
                                              DateTime.now()),
                                          'time': DateFormat("HH:mm:ss").format(
                                              DateTime.now()),
                                          'party': "Customer",
                                          'description': "You have received "+amount+"rs from "+cname+"(customer).\n Note: $note"
                                        }),);
                                      if(response.statusCode==200){
                                        print("CustomerRecords created");
                                      }
                                      await doesProfitAlreadyExist(amount);
                                      await minuspendingamount(amount);
                                      await gotpaymentrecords(amount);
                                      await amountgotmaintain(amount);
                                      setdocument();
                                    } Navigator.pop(context);
                                  }, child: Container(width: 200,
                                      margin: EdgeInsets.only(top: 8),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:  Colors.blue),
                                      padding: EdgeInsets.all(10),
                                      child:Center(child:Text("Save", style: TextStyle(color: Colors.white),))))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },child: Column(children: [Icon(FontAwesomeIcons.indianRupeeSign), Text("You got")],),),
                  TextButton(
                    onPressed: () async {var note="";
                      await FirebaseAnalytics.instance.logEvent(
                        name: "you_gave_amount",
                      );
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 220,
                            child: SingleChildScrollView(scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  <Widget>[
                                  SizedBox(height: 15,),
                                  TextField(
                                    decoration: InputDecoration(hintText: "Enter amount".tr(),
                                      labelText:"Enter amount",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),prefixIcon: Icon(Icons.currency_rupee)),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value){
                                      amount= value.trim();
                                    }, ),
                                  SizedBox(height: 10,),
                                  TextField(
                                    decoration: InputDecoration(hintText: "Note (Optional)".tr(),
                                        labelText:"Note (Optional)",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(),
                                        ),prefixIcon: Icon(Icons.note_alt)),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value){
                                      note= value.trim();
                                    }, ),
                                  TextButton(onPressed: () async {
                                    if(amount.isEmpty || amount.startsWith("0",0)){
                                      Fluttertoast.showToast(msg: "Field cannot be empty or starts with 0.");
                                    }
                                    else{
                                      var url = Uri.https(customerrecordapi, 'CustomerRecords/customerrecord');
                                      var response = await http.post(url,   headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                        body: jsonEncode(<String, String>{
                                          "id":userid+DateFormat("yyyyMMddHHmmss").format(
                                              DateTime.now()),
                                          'user_id': userid,
                                          'client_id': clientid,
                                          'record_id': DateFormat("yyyyMMddHHmmss").format(
                                              DateTime.now()),
                                          'payment_status': "Paid",
                                          'payment_mode': "",
                                          'transaction_id': "",
                                          'received_amount':"0",
                                          'sent_amount': amount,
                                          'party_name':cname,
                                          'date': DateFormat("yyyy-MM-dd").format(
                                              DateTime.now()),
                                          'time': DateFormat("HH:mm:ss").format(
                                              DateTime.now()),
                                          'party': "Customer",
                                          'description': "You gave ${amount}rs to $cname(customer).\n Note: $note"
                                        }),);
                                      if(response.statusCode==200){
                                        print("CustomerRecords created");
                                      }
                                     await addpendingamount(amount);
                                     await MinusdoesProfitAlreadyExist(amount);
                                     await doesexpanseexist(amount, "You gave ${amount}rs to $cname(customer).");
                                     await gavepaymentrecords(amount);
                                     await amountgavemaintain(amount);
                                      await setdocument();Navigator.pop(context);
                                    }
                                  }, child: Container(width:200,
                                      margin: EdgeInsets.only(top: 8),decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color:  Colors.blue),
                                      padding: EdgeInsets.all(10),
                                      child:Center(child:Text("Save", style: TextStyle(color: Colors.white),))))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },child: Column(children: [Icon(FontAwesomeIcons.indianRupeeSign), Text("You gave")],),),],),),),
            ListTile(
                title:Row(children: [Container(width:100,
                    child:Center(child: Text("Purchase".toString()))),
                  Container(width:100,
                    child:Center(child: Text("Received".toString())))],),
              trailing: Text("Date"),),
            Container(height: phoneno==""?380:435,
                child:/*FutureBuilder<List<CustomerRecord>>(
              future:   getcustomerdetails(userid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.hasData || snapshot.data != null) {
                return*/ ListView.builder(
                    shrinkWrap: true,
                    itemCount: customerrecordlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        // elevation: 4,
                        child: ExpansionTile(
                          title: Row(children: [Column(children: [Container(width:100,
                            child:Center(child: Text("₹"+customerrecordlist[index]['sent_amount'].toString()))),],),
                          Column(children: [Container(width:100,
                                child:Center(child: Text("₹"+customerrecordlist[index]['received_amount'].toString()))),]),
                        ],),
                          trailing: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(customerrecordlist[index]['date'].toString()),
                            Text(customerrecordlist[index]['time'].toString()),
                          ],),
                          children: [Divider(height: 2,),
                          Container(width:double.maxFinite,
                            padding: EdgeInsets.all(8),
                            child: Text(customerrecordlist[index]['description'].toString()),)],
                        ),
                      );
                    })/*;
              }
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blueGrey,
                  ),
                ),
              );
            },
          )*/),],),
            )
        ),
      ),
    )
    );
  }
  void sending_SMS(String msg, List<String> list_receipents) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "send_sms_to_customer",
    );
    String send_result = await sendSMS(message: "Dear Sir/ Madam,"
        " Your payment of ₹$due is pending at My Business($restroname). Kindly visit my shop for payment or make your "
        "payment online.", recipients: list_receipents)
        .catchError((err) {
      print(err);
    });
    print(send_result);
  }
  _launchWhatsapp(context, String mob) async {
    var whatsapp = mob;
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=Dear Sir/ Madam,"
        " Your payment of ₹$due is pending at My Business($restroname). Kindly visit my shop for payment or make your "
        "payment online.\n Thank you. &Image");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.substring(2,phoneNumber.length),
    );
    await launchUrl(launchUri);
  }
 Future doesexpanseexist(investment, description) async  {
    var url = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord');
   var response = await http.post(
       url,
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(<String, String>{
         "id":userid+ DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
         "user_id": userid,
         "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
         "expanse_record_id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
         "expanse_name": cname,
         "description": description,
         "investment": investment,
         "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
         "time": DateFormat("HH:mm:ss").format(DateTime.now()),
         "status": paid}));
   print('expansereportResponse status: ${response.statusCode}');
   if(response.statusCode==200){
     doesexoanseexiste(investment);
   }
  }
  doesexoanseexiste(investment) async{
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
    var exurl= Uri.https(expanseapi, 'Expanse/expanse');
    var exresponse = await http.post(
      exurl,
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
   /*{
    final item = ExpanseRecord(
        user_id: userid,
        expanse_id: DateFormat("yyyyMMdd").format(
            DateTime.now()),
        expanse_record_id: DateFormat("yyyyMMddHHmmss")
            .format(DateTime.now()),
        expanse_name: description,
        description: description,
        investment: investment,
        date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        time: DateFormat("HH:mm:ss").format(DateTime.now()),
        status: "Paid");
    await Amplify.DataStore.save(item)
        .whenComplete(() async {String id= DateFormat("yyyyMMdd").format(DateTime.now());
        final Expanses = await Amplify.DataStore.query(Expanse.classType,
            where: Expanse.USER_ID.eq(userid).and(Expanse.EXPANSE_ID.eq(DateFormat("yyyyMMdd").format(DateTime.now()))));
        if(Expanses.isNotEmpty){
          final updatedItem = Expanses[0].copyWith(
              user_id: Expanses[0].user_id,
              expanse_id: Expanses[0].expanse_id,
              expanse: (double.parse(Expanses[0].expanse.toString())+double.parse(investment)).toString(),
              status: Expanses[0].status,
              date: Expanses[0].date);
          await Amplify.DataStore.save(updatedItem).whenComplete(() async {
            print("expanseupdated");
          });
        }
        else{
      final item = Expanse(
          user_id: userid,
          expanse_id: DateFormat("yyyyMMdd").format(DateTime.now()),
          expanse: investment,
          status: "Paid",
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()));
      await Amplify.DataStore.save(item)
          .whenComplete(() async {
        print("expanserecord created");
      });

    }
      });

  }*/
   Future minuspendingamount(amount)async{//https://eai56xqcdf.execute-api.ap-south-1.amazonaws.com/Pendingpayment/pendingpayments
     String monthid= DateFormat("yMMMM").format(DateTime.now());
     var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': userid+clientid});
     var resonse= await http.get(url );
     if(resonse.body!=''){
       print("object${resonse.body}");
       var jsonResponse =
       convert.jsonDecode(resonse.body) as Map<String, dynamic>;
       var esponse = await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id": userid+clientid,
             "user_id": userid,
             "client_id": clientid,
             "record_id": userid+clientid,
             "party": customer,
             "party_name": cname,
             "Pending_amount":( double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount)).toString()
           }));
       if(esponse.statusCode==200){
       }
     }
   }
   Future addpendingamount(amount)async{
     String monthid= DateFormat("yMMMM").format(DateTime.now());
     var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': userid+clientid});
     var response= await http.get(url );
     if(response.body.isNotEmpty){
       var jsonResponse =
       convert.jsonDecode(response.body) as Map<String, dynamic>;
       var esponse = await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id": jsonResponse['id'],
             "user_id": jsonResponse['user_id'],
             "client_id": jsonResponse['client_id'],
             "record_id": jsonResponse['record_id'],
             "party": jsonResponse['party'],
             "party_name": cname,
             "Pending_amount":( double.parse(jsonResponse['Pending_amount'].toString())+ double.parse(amount)).toString()
           }));
       if(esponse.statusCode==200){
       }
     }
     else{
       var esponse = await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id": userid+clientid,
             "user_id": userid,
             "client_id": clientid,
             "record_id": userid+clientid,
             "party": customer,
             "party_name": cname,
             "Pending_amount":(double.parse(amount)).toString()
           }));
       if(esponse.statusCode==200){
       }
     }
   }
   Future doesmonthlyprofitrecordexist(String amount, String exdate,) async {
     String monthid= DateFormat("yMMMM").format(DateTime.now());
     var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id': userid+monthid});
     var response= await http.get(url );
     if(response.body.isNotEmpty){
       var jsonResponse =
       convert.jsonDecode(response.body) as Map<String, dynamic>;
       var esponse = await http.post(
           url,
           headers: <String, String>{
             'Content-Type': 'application/json; charset=UTF-8',
           },
           body: jsonEncode(<String, String>{
             "id": jsonResponse['id'],
             "user_id": jsonResponse['user_id'],
             "monthly_profit_id": jsonResponse['monthly_profit_id'],
             "monthly_profit": (double.parse(jsonResponse['monthly_profit'])+double.parse(amount)).toString(),
             "Earned_amount": (double.parse(jsonResponse['Earned_amount'])+double.parse(amount) ).toString(),
             "Expanse_amount":jsonResponse['Expanse_amount'] ,
             "month": jsonResponse['month'],
             "year": jsonResponse['year']
           }));

       print("profitmnthly update response ${esponse.statusCode}");

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
             "monthly_profit": (double.parse(amount)).toString(),
             "Earned_amount": amount,
             "Expanse_amount": "0",
             "month": DateFormat("MMMM").format(DateTime.now()),
             "year": DateFormat("yyyy").format(DateTime.now())
           }));       print("profitmnthly add response ${response.statusCode}");
     }
   }
  gavepaymentrecords(amount)async{
    var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": userid,
          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "token_no": "",
          "order_id": "",
          "client_id": clientid,
          "received_amount": "0",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": amount,
          "description":"You have gave ₹"+amount+" to "+cname+"(Customer)."
        }));
    print("${response.statusCode} paymentrecord");
  }
  amountgavemaintain(amount)async{

    var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',{
      'id':userid+clientid});
    var response= await http.get(murl );
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("dues is notemtyhbsx");
      if(jsonResponse['pending_amount']!="0"){
        var remain= double.parse(jsonResponse['pending_amount'].toString())+double.parse(amount);
        print("object  $remain");
        if(remain>0){
          var response = await http.post(murl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "customer_id":jsonResponse['customer_id'],
              "customer_name": jsonResponse['customer_name'],
              "customer_phone_no": jsonResponse['customer_phone_no'],
              "advance_amount": '0',
              "pending_amount": remain.toString(),
              "date": jsonResponse['date'],
              "time": jsonResponse['time']}),);
          if(response.statusCode==200){}}
        else{
          var response = await http.post(murl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "customer_id":jsonResponse['customer_id'],
              "customer_name": jsonResponse['customer_name'],
              "customer_phone_no": jsonResponse['customer_phone_no'],
              "advance_amount": (-remain).toString(),
              "pending_amount": '0',
              "date": jsonResponse['date'],
              "time": jsonResponse['time']}),);
          if(response.statusCode==200){}
        }
      }
      else{
        var remain= double.parse(jsonResponse['advance_amount'].toString())-double.parse(amount);
        print("objhdhfgect  $remain");
        if(remain>0){
          var response = await http.post(murl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "customer_id":jsonResponse['customer_id'],
              "customer_name": jsonResponse['customer_name'],
              "customer_phone_no": jsonResponse['customer_phone_no'],
              "advance_amount": remain.toString(),
              "pending_amount": '0',
              "date": jsonResponse['date'],
              "time": jsonResponse['time']}),);
          if(response.statusCode==200){}}
        else{
          var response = await http.post(murl,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              "id":jsonResponse['id'],
              "user_id": jsonResponse['user_id'],
              "customer_id":jsonResponse['customer_id'],
              "customer_name": jsonResponse['customer_name'],
              "customer_phone_no": jsonResponse['customer_phone_no'],
              "advance_amount": '0',
              "pending_amount": (-remain).toString(),
              "date": jsonResponse['date'],
              "time": jsonResponse['time']}),);
          if(response.statusCode==200){}
        }
      }
    }
  }
   gotpaymentrecords(amount)async{
     var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
     var response = await http.post(
         url,
         headers: <String, String>{
           'Content-Type': 'application/json; charset=UTF-8',
         },
         body: jsonEncode(<String, String>{
           "id": userid+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
           "user_id": userid,
           "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
           "token_no": "",
           "order_id": "",
           "client_id": clientid,
           "received_amount": amount,
           "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
           "time": DateFormat("HH:mm:ss").format(DateTime.now()),
           "payment_mod": "",
           "sent_amount": "0",
           "description":"You have received ₹"+amount+" from"+cname+"(customer)."
         }));
     print("${response.statusCode} paymentrecord");
   }
   amountgotmaintain(amount)async{
     var murl = Uri.https(customerlistapi, 'CustomerList/customerlist',{
       'id':userid+clientid});
     var response= await http.get(murl );
     if(response.body.isNotEmpty){
       var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
       print("dues is notemtyhbsx");
       if(jsonResponse['pending_amount']!="0"){
         var remain= double.parse(jsonResponse['pending_amount'].toString())-double.parse(amount);
         print("object  $remain");
         if(remain>0){
           var response = await http.post(murl,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":jsonResponse['id'],
               "user_id": jsonResponse['user_id'],
               "customer_id":jsonResponse['customer_id'],
               "customer_name": jsonResponse['customer_name'],
               "customer_phone_no": jsonResponse['customer_phone_no'],
               "advance_amount": '0',
               "pending_amount": remain.toString(),
               "date": jsonResponse['date'],
               "time": jsonResponse['time']}),);
           if(response.statusCode==200){}}
         else{
           var response = await http.post(murl,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":jsonResponse['id'],
               "user_id": jsonResponse['user_id'],
               "customer_id":jsonResponse['customer_id'],
               "customer_name": jsonResponse['customer_name'],
               "customer_phone_no": jsonResponse['customer_phone_no'],
               "advance_amount": (-remain).toString(),
               "pending_amount": '0',
               "date": jsonResponse['date'],
               "time": jsonResponse['time']}),);
           if(response.statusCode==200){}
         }
       }
       else{
         var remain= double.parse(jsonResponse['advance_amount'].toString())+double.parse(amount);
         print("objhdhfgect  $remain");
         if(remain>0){
           var response = await http.post(murl,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":jsonResponse['id'],
               "user_id": jsonResponse['user_id'],
               "customer_id":jsonResponse['customer_id'],
               "customer_name": jsonResponse['customer_name'],
               "customer_phone_no": jsonResponse['customer_phone_no'],
               "advance_amount": remain.toString(),
               "pending_amount": '0',
               "date": jsonResponse['date'],
               "time": jsonResponse['time']}),);
           if(response.statusCode==200){}}
         else{
           var response = await http.post(murl,
             headers: <String, String>{
               'Content-Type': 'application/json; charset=UTF-8',
             },
             body: jsonEncode(<String, String>{
               "id":jsonResponse['id'],
               "user_id": jsonResponse['user_id'],
               "customer_id":jsonResponse['customer_id'],
               "customer_name": jsonResponse['customer_name'],
               "customer_phone_no": jsonResponse['customer_phone_no'],
               "advance_amount": '0',
               "pending_amount": (-remain).toString(),
               "date": jsonResponse['date'],
               "time": jsonResponse['time']}),);
           if(response.statusCode==200){}
         }
       }
     }
   }
   Future<void> doesProfitAlreadyExist(String amount) async{
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
             "profit": amount,
             "earned": amount,
             "expanse": "0",
             "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
             "month": DateFormat("MMMM").format(DateTime.now()) ,
             "year": DateFormat("yyyy").format(DateTime.now())
           }));
       print("profit add response ${response.statusCode}");

       if(response.statusCode==200){
         doesmonthlyprofitrecordexist(amount, DateFormat("yyyyMMdd").format(DateTime.now()), );
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
             "profit": (double.parse(jsonResponse['profit'])+double.parse(amount)).toString(),
             "earned": (double.parse(jsonResponse['earned'])+double.parse(amount)).toString(),
             "expanse": jsonResponse['expanse'],
             "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
             "month": DateFormat("MMMM").format(DateTime.now()) ,
             "year": DateFormat("yyyy").format(DateTime.now())
           }));
       print("profit update response ${esponse.statusCode}");
       if(esponse.statusCode==200){
         doesmonthlyprofitrecordexist(amount, DateFormat("yyyyMMdd").format(DateTime.now()), );
       }
     }
   }
   Future minusdoesmonthlyprofitrecordexist(String amount, String exdate,) async
   {
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
             "Earned_amount":jsonResponse['Earned_amount'],
             "Expanse_amount":  (double.parse(jsonResponse['Expanse_amount'])+double.parse(amount) ).toString(),
             "month": jsonResponse['month'],
             "year": jsonResponse['year']
           }));

       print("profitmnthly update response ${esponse.statusCode}");

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
             "monthly_profit": (-double.parse(amount)).toString(),
             "Earned_amount": "0",
             "Expanse_amount": amount,
             "month": DateFormat("MMMM").format(DateTime.now()),
             "year": DateFormat("yyyy").format(DateTime.now())
           }));       print("profitmnthly add response ${response.statusCode}");
     }
   }
   Future<void> MinusdoesProfitAlreadyExist(String amount) async {
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
             "profit": amount,
             "earned": '0',
             "expanse": amount,
             "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
             "month": DateFormat("MMMM").format(DateTime.now()) ,
             "year": DateFormat("yyyy").format(DateTime.now())
           }));
       print("profit add response ${response.statusCode}");
       if(response.statusCode==200){minusdoesmonthlyprofitrecordexist(amount, DateFormat("yyyyMMdd").format(DateTime.now()), );}
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
       if(esponse.statusCode==200){ minusdoesmonthlyprofitrecordexist(amount, DateFormat("yyyyMMdd").format(DateTime.now()), );
       }
     }
   }
 }


