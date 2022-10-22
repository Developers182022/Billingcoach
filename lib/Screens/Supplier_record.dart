import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_sms/flutter_sms.dart';
import 'dart:convert';
import 'dart:io';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webappbillingcoach/Screens/printcustomerreport.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/ChatMessage.dart';
import '../models/CustomerRecord.dart';
import '../models/Expanse.dart';
import '../models/ExpanseRecord.dart';
import '../models/PaymentRecords.dart';
import '../models/PendingPayments.dart';
import '../models/Profit.dart';
import '../models/ProfitMonthlyRecord.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'login/Login.dart';
class SupplierRecord extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const SupplierRecord({Key? key, this.ccid}) : super(key: key);
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
            theme: ThemeData(primarySwatch: Colors.blue,
                primaryColor: Colors.black87,
                primaryColorDark:Colors.white,
                fontFamily: 'RobotoMono'),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home: SupplierRecordPage(clid: ccid,)//:SubscriptionModule(ccid: FirebaseAuth.instance.currentUser!.uid),
          );
        });
  }
}
class SupplierRecordPage extends StatefulWidget {
  const SupplierRecordPage({Key? key,this.clid}) : super(key: key);
  final clid;
  @override
  State<SupplierRecordPage> createState() => _SupplierRecordState(clientid: clid);
}
class _SupplierRecordState extends State<SupplierRecordPage> {
  _SupplierRecordState({this.clientid});
  final clientid;
  var doc;
  bool ActiveConnection = false;
  String T = "";
  var customerrecordlist=[];
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
  Future<void> getcustomerdetails(useid) async {
    var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':useid+clientid});
    var response= await http.get(url );
      var jnResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState((){
        areacode= jnResponse['Pending_amount'   ].toString();
        advnc=    jnResponse['Advance_amount'    ].toString();
        cname=  jnResponse['supplier_name'].toString();
        cshop=  jnResponse['shop_name'].toString();
        cusername= jnResponse['username'].toString();
      });
    print(clientid);
    var curl= Uri.https(customerrecordapi, 'CustomerRecords/customerrecords',);
    var cresponse= await http.get(curl );
    var ctagObjsJson = jsonDecode(cresponse.body)['products'] as List;
    print(ctagObjsJson.length);
    for(int i=0; i<ctagObjsJson.length; i++){
      var jnResponse = ctagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==useid && jnResponse['client_id']==clientid ){print("outgj-- $jnResponse");
      setState((){
        customerrecordlist.add(jnResponse);
      });
      }
    }
    print("customerrecordlist  $customerrecordlist");

  }
  bool additem=false, additembtn=true, edititem=false, edititembtn= true;
  String imgurl= "https://dominionmartialarts.com/wp-content/uploads/2017/04/default-image-620x600.jpg";
  File? file;
  List<String> itemlist=["item1", "item2"];
  List<String> _list= [];
  var categoryname;
  DateTime currentDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List todos = List.empty();
  String title = "";
  String price="";
  String description = "";
  String investment = "";
  String date="";
  String time="";
  String userid= "";
  final getkey= GlobalKey();
final paymentkey= GlobalKey();
final reportkey= GlobalKey();
final remindkey= GlobalKey();  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  final duekey= GlobalKey();
  final pendingkey= GlobalKey();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2021, 11, 5),
    end: DateTime(2022, 12, 10),
  );
  String restroname="", username="",phoneno="", address="", areacode="0", profileimg="", advnc="0", suppliername="",
  cshop="", cname="", cupi="", caddrss="", cusername="";
  String itemimage="", msg="";
  @override
  void initState() {
    CheckUserConnection();
    print("PL--- $clientid");
    getuserdetails();

    super.initState();
  }
  getuserdetails() async{
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
            suppliername = jsonResponse['supplier_name'].toString();
          });}
      }
      await getcustomerdetails(counter);}
    else{runApp(LoginScreen());}

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: RefreshIndicator(onRefresh: ()async {getcustomerdetails(userid);},
            child: Container(
          child:SingleChildScrollView(child:Column(children: [
            Card(child:Container(width: double.maxFinite,
              padding: EdgeInsets.only(left:25, right: 25, ),
              child: ListTile(leading:Container(width:120,child: Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 Text("₹"+areacode, style: TextStyle(fontSize: 16.0)),
               /* Center(
                  child:*/ Text("You will get", style: TextStyle(fontSize: 16.0)//),
                )])),),

               trailing: Container(width:120, child:Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child:   Text("₹"+advnc, style: TextStyle(fontSize: 16.0))),
                    Center(
                      child: Text("You will give", style: TextStyle(fontSize: 16.0)),
                    )],)),)
            ),
           ),
            phoneno.isEmpty?Container(width: double.infinity,
                padding: EdgeInsets.only(left:25, right: 25, ),
                child: Row(
                    children:[ Text("Add customer contact to send reminder"),
                      TextButton(child: Text("Add"), onPressed: (){showDialog(context: context, builder: (BuildContext context){
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
                                      List<AcceptedSuppliers> AcceptedSupplierss = await Amplify.DataStore.query(AcceptedSuppliers.classType,
                                      where: AcceptedSuppliers.USER_ID.eq(userid).and(AcceptedSuppliers.SUPPLIER_ID.eq((clientid))));
                                   if(AcceptedSupplierss.isNotEmpty){
                                    final updatedItem = AcceptedSupplierss[0].copyWith(
                                        user_id: AcceptedSupplierss[0].user_id,
                                        supplier_id: AcceptedSupplierss[0].supplier_id,
                                        supplier_name: AcceptedSupplierss[0].supplier_name,
                                        shop_name: AcceptedSupplierss[0].shop_name,
                                        username:AcceptedSupplierss[0].username,
                                        Advance_amount: AcceptedSupplierss[0].Advance_amount,
                                        Pending_amount: AcceptedSupplierss[0].Pending_amount,
                                        supplier_phone_no: investment);
                                    await Amplify.DataStore.save(updatedItem)
                                        .whenComplete((){
                                    setdocument();
                                  });}
                                  }  Navigator.pop(context);
                                },),)],) ),
                        );
                      });},),

                    ])):Container(),
            Card(child:
            Column(children: [
              Container(margin: EdgeInsets.only(left: 25, right: 25),child: Row(
                children: [TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrintReport(clid: clientid)));
                },child: Column(children: [Icon(Icons.picture_as_pdf), Text("Report")],),),
                    TextButton(onPressed: (){showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Remind"),
                  content: Container(height:100,
                    child:SingleChildScrollView(scrollDirection: Axis.horizontal,
                      child: Row(children: [
                      Card(child: TextButton(onPressed: ()async{await sendchatmessage("Dear sir/madam,\n Your payment of $areacode is pending at My Business ($restroname)"
                          "Kindly visit the application Billing coach to view details and make payment.");
                        Fluttertoast.showToast(msg: "Message sent");},child:Column(children: [ImageIcon(AssetImage("assets/logofront.png")), Text("Via Chat")],) ,),),
                      Card(child: TextButton(onPressed: (){if(phoneno.isNotEmpty){_makePhoneCall(phoneno);}else{Fluttertoast.showToast(msg:"Kindly ask supplier for contact details or remind them through chat.");}},child:Column(children: [Icon(Icons.phone), Text("Via Call")],) ,),),
                      Card(child: TextButton(onPressed: (){if(  _list.isNotEmpty){sending_SMS(msg, _list);}else{Fluttertoast.showToast(msg:"Kindly ask supplier for contact details or remind them through chat.");}},child:Column(children: [Icon(Icons.message), Text("Via Sms")],) ,),),
                      Card(child: TextButton(onPressed: (){if(phoneno.isNotEmpty){_launchWhatsapp(context, phoneno, areacode);}else{Fluttertoast.showToast(msg:"Kindly ask supplier for contact details or remind them through chat.");}},child:Column(children: [Icon(FontAwesomeIcons.whatsapp),
                        Center(child: Text("Via\n WhatsApp"),)],),),)
                    ],),),) ,
                );
              });},child: Column(children: [Icon(Icons.details), Text("Remind")],),),
            TextButton(onPressed: ()async{
                    var amount="";
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: SingleChildScrollView(scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  <Widget>[
                                SizedBox(height: 8,),
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
                                SizedBox(height: 8,),
                                TextButton(onPressed: () async {
                                  if(amount.isEmpty || amount.startsWith("0",0)){
                                    Fluttertoast.showToast(msg: "Field cannot be empty or starts with 0.");
                                  }
                                  else{
                                    final item = CustomerRecord(
                                      user_id: userid,
                                      client_id: clientid,
                                      record_id: DateFormat("yyyyMMddHHmmss").format(
                                          DateTime.now()),
                                      payment_status: "Paid",
                                      payment_mode: "",
                                      transaction_id: "",
                                      received_amount:amount,
                                      sent_amount: "0",
                                      party_name:cshop,
                                      date: DateFormat("yyyy-MM-dd").format(
                                          DateTime.now()),
                                      time: DateFormat("HH:mm:ss").format(
                                          DateTime.now()),
                                      party: "Supplier",
                                      description: "You have received ₹"+amount+"rs from supplier "+cname+" from shop name -"+cshop+".");
                                  await Amplify.DataStore.save(item).whenComplete(() async {
                                    final clitem = CustomerRecord(
                                        user_id: clientid,
                                        client_id: userid,
                                        record_id: DateFormat("yyyyMMddHHmmss").format(
                                            DateTime.now()),
                                        payment_status: "Paid",
                                        payment_mode: "",
                                        transaction_id: "",
                                        received_amount:"0",
                                        sent_amount: amount,
                                        party_name:restroname,
                                        date: DateFormat("yyyy-MM-dd").format(
                                            DateTime.now()),
                                        time: DateFormat("HH:mm:ss").format(
                                            DateTime.now()),
                                        party: "Supplier",
                                        description: "You have sent ₹"+amount+"rs to supplier "+cname+" from shop name -"+cshop+".");
                                    await Amplify.DataStore.save(clitem);
                                    await amountgavebyclient(amount);
                                    await addpaymentrecord(amount, clientid, userid);
                                   await checkinpendings(amount);
                                   await doesProfitAlreadyExist(amount);
                                   await  Minusprofitatclient(amount);
                                   await addexpanseatclient(amount);
                                  await setdocument();
                                    });
                                 } Navigator.pop(context);
                                },  child:Container(height:40,
                                    width:100,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                    child:Center(child:Text("Save", style:TextStyle(color:Colors.white)))))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                    child: Column(children: [Icon(FontAwesomeIcons.indianRupeeSign), Text("You got")],),),
            TextButton(onPressed: ()async{
                    var amount="";
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        var note="";
                        return SizedBox(
                          height: 220,
                          child: SingleChildScrollView(scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  <Widget>[
                                SizedBox(height: 8,),
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
                                SizedBox(height: 8,),
                                TextField(
                                  decoration: InputDecoration(hintText: "Note(Optional)".tr(),
                                      labelText:"Note(Optional)",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),prefixIcon: Icon(Icons.note_alt)),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value){
                                    note= value.trim();
                                  }, ),
                                SizedBox(height: 8,),
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
                                      print("userCustomerRecords created");
                                    }
                                    var clresponse = await http.post(url,   headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                      body: jsonEncode(<String, String>{
                                        "id":clientid+DateFormat("yyyyMMddHHmmss").format(
                                            DateTime.now()),
                                        'user_id': clientid,
                                        'client_id': userid,
                                        'record_id': DateFormat("yyyyMMddHHmmss").format(
                                            DateTime.now()),
                                        'payment_status': "Paid",
                                        'payment_mode': "",
                                        'transaction_id': "",
                                        'received_amount':amount,
                                        'sent_amount': '0',
                                        'party_name':restroname,
                                        'date': DateFormat("yyyy-MM-dd").format(
                                            DateTime.now()),
                                        'time': DateFormat("HH:mm:ss").format(
                                            DateTime.now()),
                                        'party': "Customer",
                                        'description': "You got ${amount}rs from $restroname(Supplier).\n Note: $note"
                                      }),);
                                    if(clresponse.statusCode==200){
                                      print("userCustomerRecords created");
                                    }
                                      await amountgavebyuser(amount);
                                      // await updatepending(amount);
                                      await useraddpaymentrecord(amount, userid, clientid);
                                      await checkinpendingclients(amount);
                                      await addprofitatclient(amount);
                                      await  Minusprofitatuser(amount);
                                      await doesexpanseexist(amount,"You gave ${amount}rs to $cname(customer)." );
                                      await setdocument();
                                  }
                              Navigator.pop(context);
                                }, child:Container(height:40,
                                    width:100,
                                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
                                    child:Center(child:Text("Save", style: TextStyle(color:Colors.white),))))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                    child: Column(children: [Icon(FontAwesomeIcons.indianRupeeSign), Text("You gave")],),),],),),
              ],),),
            Row(children:[
               Container(width: 140,height: 30,
                 child: Center(child:Text("Entries")),),
              Container(width: 160,child:Center(child: Text("Sent", style: TextStyle(fontSize: 15),)),),
             Container(child: /*Center(child: */Text("Received"),)]),
            Container(height: 400,
              child:ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: customerrecordlist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 4,
                          child: ExpansionTile(
                            leading: Container(width:100,child:Center(child:Column(children: [
                              Text( customerrecordlist[index]['time'].toString()),
                              Text( customerrecordlist[index]['date'].toString()),
                            ],) )),
                            title: Container(width:150,
                              child:Center(
                                  child:
                                    Text("₹"+ customerrecordlist[index]['sent_amount'].toString()),),),
                            trailing:    Container(
                              child: Text("₹"+ customerrecordlist[index]['received_amount'].toString(),
                                style: TextStyle(fontSize: 18),),
                            ),
                            children: [Container(width:double.maxFinite,
                                padding: EdgeInsets.all(8),
                          child:Text(customerrecordlist[index]['description'].toString()))],
                          ),
                        );
                      })),],), )),)
      ),
    );
  }
  setdocument()async{
    await getuserdetails();
  }
  checkinpendingclients(String amount)async{
    var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': clientid+userid});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var pend=0.0;
      if(double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount)<=0) {}
      else{ setState((){pend=double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount); });}
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
            "Pending_amount": pend.toString()
          }));
      if(esponse.statusCode==200){
      }
    }
  }
  checkinpendings(String amount)async{
    var url= Uri.https(pendingpaymentapi, 'Pendingpayment/pendingpayment',{'id': userid+clientid});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      var pend=0.0;
      if(double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount)<=0) {}
      else{ setState((){pend=double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount); });}
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
            "Pending_amount": pend.toString()
          }));
      if(esponse.statusCode==200){
      }
    }
  }

  amountgavebyuser(String amount)async{
    var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':userid+clientid});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
    var jnResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (double.parse(jnResponse['Advance_amount'])>=0) {
      var remain = double.parse(
          jnResponse['Advance_amount'].toString()) -
          double.parse(amount);
      if (remain > 0) {
        var response = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
            "id":jnResponse['id'],
            'user_id': jnResponse['user_id'],
            'supplier_id': jnResponse['supplier_id'],
            'Advance_amount': remain.toString(),
            'Pending_amount': jnResponse['Pending_amount'],
            'shop_name': jnResponse['shop_name'],
            'supplier_name': jnResponse['supplier_name'],
            'username': jnResponse['username'],
            'supplier_phone_no': jnResponse['supplier_phone_no']
          }),);
      }
      else {
        var response = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
          "id":jnResponse['id'],
          'user_id': jnResponse['user_id'],
          'supplier_id': jnResponse['supplier_id'],
          'Advance_amount': '0',
          'Pending_amount': (- remain).toString(),
          'shop_name': jnResponse['shop_name'],
          'supplier_name': jnResponse['supplier_name'],
          'username': jnResponse['username'],
          'supplier_phone_no': jnResponse['supplier_phone_no']
          }),);
      }
    }
    else {
      var remain = double.parse(jnResponse['Pending_amount'].toString()) + double.parse(amount);
      print("0987654567890=-0988-==============  $remain");
      if (remain > 0) {
        var response = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
          "id":jnResponse['id'],
          'user_id': jnResponse['user_id'],
          'supplier_id': jnResponse['supplier_id'],
          'Advance_amount': jnResponse['Advance_amount'],
          'Pending_amount': remain.toString(),
          'shop_name': jnResponse['shop_name'],
          'supplier_name': jnResponse['supplier_name'],
          'username': jnResponse['username'],
          'supplier_phone_no': jnResponse['supplier_phone_no']
          }),);
      }
      else {
        var response = await http.post(url,   headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
          body: jsonEncode(<String, String>{
          "id":jnResponse['id'],
          'user_id': jnResponse['user_id'],
          'supplier_id': jnResponse['supplier_id'],
          'Advance_amount':(-remain).toString() ,
          'Pending_amount': jnResponse['Pending_amount'],
          'shop_name': jnResponse['shop_name'],
          'supplier_name': jnResponse['supplier_name'],
          'username': jnResponse['username'],
          'supplier_phone_no': jnResponse['supplier_phone_no']
          }),);

      }
    }
  }
    var clurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':clientid+userid});
    var clresponse= await http.get(clurl );
    if(clresponse.body.isNotEmpty){
      var jnResponse = convert.jsonDecode(clresponse.body) as Map<String, dynamic>;
      if (jnResponse['Pending_amount'] != "0") {
        var remain = double.parse(
            jnResponse['Pending_amount'].toString()) -
            double.parse(amount);
        if (remain > 0) {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
            "Advance_amount":jnResponse['Advance_amount'],
            "Pending_amount": remain.toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
        else {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount": (-remain).toString(),
              "Pending_amount": "0",
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
      }
      else {
        var remain = double.parse(
            jnResponse['Advance_amount'].toString()) +
            double.parse(amount);
        if (remain > 0) {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":  remain.toString(),
              "Pending_amount":  jnResponse['Pending_amount'],
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
        else {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":  "0",
              "Pending_amount": (- remain).toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
      }
    }
  }
  amountgavebyclient(String amount)async{
    var url= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':userid+clientid});
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jnResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jnResponse['Advance_amount'] != "0") {
        var remain = double.parse(
            jnResponse['Advance_amount'].toString()) +
            double.parse(amount);
        if (remain > 0) {
          var response = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              'Advance_amount': remain.toString(),
              'Pending_amount': jnResponse['Pending_amount'],
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
        else {
          var response = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              'Advance_amount': '0',
              'Pending_amount': (- remain).toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
      }
      else {
        var remain = double.parse(jnResponse['Pending_amount'].toString())-
            double.parse(amount);
        print("0987654567890=-0988-==============  $remain");
        if (remain > 0) {
          var response = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              'Advance_amount': jnResponse['Advance_amount'],
              'Pending_amount': remain.toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
        else {
          var response = await http.post(url,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              'Advance_amount':(-remain).toString() ,
              'Pending_amount': jnResponse['Pending_amount'],
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
      }
    }
    var clurl= Uri.https(acceptedsupplierapi, 'AcceptedSuppliers/acceptedsupplier', {'id':clientid+userid});
    var clresponse= await http.get(clurl );
    if(clresponse.body.isNotEmpty){
      var jnResponse = convert.jsonDecode(clresponse.body) as Map<String, dynamic>;
      if (jnResponse['Pending_amount'] != "0") {
        var remain = double.parse(
            jnResponse['Pending_amount'].toString()) +
            double.parse(amount);
        if (remain > 0) {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":jnResponse['Advance_amount'],
              "Pending_amount": remain.toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);
        }
        else {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":(- remain).toString(),
              "Pending_amount": "0",
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
      }
      else {
        var remain = double.parse(
            jnResponse['Advance_amount'].toString()) -
            double.parse(amount);
        if (remain > 0) {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":  remain.toString(),
              "Pending_amount":  jnResponse['Pending_amount'],
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
        else {
          var response = await http.post(clurl,   headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
            body: jsonEncode(<String, String>{
              "id":jnResponse['id'],
              'user_id': jnResponse['user_id'],
              'supplier_id': jnResponse['supplier_id'],
              "Advance_amount":  "0",
              "Pending_amount": (- remain).toString(),
              'shop_name': jnResponse['shop_name'],
              'supplier_name': jnResponse['supplier_name'],
              'username': jnResponse['username'],
              'supplier_phone_no': jnResponse['supplier_phone_no']
            }),);

        }
      }
    }
  }
  sendchatmessage(String message)async{
    var id= DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    final item = ChatMessage(
        user_id: userid,
        client_id: clientid,
        message_id: id,
        Chat_status: "Sent",
        payment_status: "",
        payment_mode: "",
        transaction_id: "",
        delivery_mode: "",
        total: "",
        status: "",
        date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        time: DateFormat("HH:mm:ss").format(DateTime.now()),
        Message: message);
    await Amplify.DataStore.save(item).whenComplete(() async{
      final clitem = ChatMessage(
          user_id: clientid,
          client_id: userid,
          message_id: id,
          Chat_status: "Received",
          payment_status: "",
          payment_mode: "",
          transaction_id: "",
          delivery_mode: "",
          total: "",
          status: "",
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          time: DateFormat("HH:mm:ss").format(DateTime.now()),
          Message: message);
      await Amplify.DataStore.save(clitem);
       List<Suppliers> Supplierss = await Amplify.DataStore.query(Suppliers.classType,
          where: Suppliers.SUPPLIER_ID.eq(userid));
      List<UserToken> Tokens = await Amplify.DataStore.query(UserToken.classType,
          where: UserToken.USER_ID.eq(clientid));
      if(Tokens.isNotEmpty){
        sendPushMessage(Tokens[0].token.toString(), Supplierss[0].shop_name.toString()+ " has sent you a message.", "");
        print("_Supplier_request_fmeron client approved");
      }
    });
  }
  useraddpaymentrecord(String amount, String user, String client,)async{
    var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": user+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": user,
          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "token_no": "",
          "order_id": "",
          "client_id": client,
          "received_amount": "0",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": amount,
          "description":"You gave ₹"+amount+" to "+cname+"(Supplier) from $cshop."
        }));
    var clresponse = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": client+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": client,
          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "token_no": "",
          "order_id": "",
          "client_id": user,
          "received_amount": amount,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": "0",
          "description":"You got ₹"+amount+" from supplier name "+suppliername+" from $restroname."
        }));
  }

  addpaymentrecord(String amount, String user, String client,)async{
    var url = Uri.https(paymentrecapi, 'Paymeentrecord/paymentrecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": user+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": user,
          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "token_no": "",
          "order_id": "",
          "client_id": client,
          "received_amount": "0",
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": amount,
          "description":"You gave ₹"+amount+" to "+cname+"(Supplier) from $cshop."
        }));
    var clresponse = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id": client+DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": client,
          "record_id": DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "token_no": "",
          "order_id": "",
          "client_id": user,
          "received_amount": amount,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "payment_mod": "",
          "sent_amount": "0",
          "description":"You got ₹"+amount+" from supplier name "+suppliername+" from $restroname."
        }));
  }
  _launchWhatsapp(context, String mob, String due) async {
    var whatsapp = mob;
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text&image=Dear sir/madam,\n Your payment of $due is pending at My Business ($mob)"
        "Kindly visit the application Billing coach to view details and make payment."
        "&Image");
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
  void sending_SMS(String msg, List<String> list_receipents) async {
    String send_result = await sendSMS(message: "Dear Sir/ Madam,"
        " Your payment of ₹$price is pending at My Business($restroname). Kindly visit my shop for payment or make your "
        "payment online.", recipients: list_receipents)
        .catchError((err) {
      print(err);
    });
    print(send_result);
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  Future doesmonthlyprofitrecordexist(String expn, String exdate,) async {

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
            "monthly_profit": (double.parse(jsonResponse['monthly_profit'])+double.parse(expn)).toString(),
            "Earned_amount": (double.parse(jsonResponse['Earned_amount'])+double.parse(expn) ).toString(),
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
            "monthly_profit": (double.parse(expn)).toString(),
            "Earned_amount": expn,
            "Expanse_amount": "0",
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year": DateFormat("yyyy").format(DateTime.now())
          }));       print("profitmnthly add response ${response.statusCode}");
    }
  }
  Future<void> doesProfitAlreadyExist(String name) async {
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
            "profit": name,
            "earned": name,
            "expanse": "0",
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit add response ${response.statusCode}");

      if(response.statusCode==200){
        doesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), );}
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
            "profit": (double.parse(jsonResponse['profit'])+double.parse(name)).toString(),
            "earned": (double.parse(jsonResponse['earned'])+double.parse(name)).toString(),
            "expanse": jsonResponse['expanse'],
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit update response ${esponse.statusCode}");
      if(esponse.statusCode==200){
        doesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), );
  }
    }
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
          "expanse_name": description,
          "description": description,
          "investment": investment,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "status": "Paid"}));
    print('expansereportResponse status: ${response.statusCode}');
    if(response.statusCode==200){
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
            "status": 'Paid',
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
          "status": jsonResponse['status'],
          "date":jsonResponse['date']
        }),);
      print("exresponse update  ${exresponse.statusCode}");
      }
    }
  }
  Future minuspendingamount(amount)async{
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
            "party": jsonResponse['party'],
            "party_name": cname,
            "Pending_amount":( double.parse(jsonResponse['Pending_amount'].toString())- double.parse(amount)).toString()
          }));
      if(esponse.statusCode==200){
      }
    }

  }
  Future addpendingamount(amount)async{
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
            "party": jsonResponse['party'],
            "party_name": cname,
            "Pending_amount":( double.parse(jsonResponse['Pending_amount'].toString())+ double.parse(amount)).toString()
          }));
      if(esponse.statusCode==200){
      }
    }
  }
  Future addprofitatclient(amount) async{

    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url= Uri.https(profitapi, 'Profit/profit',{'id': clientid+proid});
    var response= await http.get(url );
    if(response.body.isEmpty){
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":clientid+proid,
            "user_i": clientid,
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
        addmonthlyprofitclient(amount);}
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
            "id":clientid+proid,
            "user_i": clientid,
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
        addmonthlyprofitclient(amount);   }
    }
  }
  Future Minusprofitatuser   (amount)async{

    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url= Uri.https(profitapi, 'Profit/profit',{'id': userid+proid});
    var response= await http.get(url );
    if(response.body.isEmpty){
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+proid,
            "user_i": userid,
            "profit_id": proid,
            "profit": amount,
            "earned": "0",
            "expanse": amount,
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit add response ${response.statusCode}");
      if(response.statusCode==200){await minusmonthlyprofituser(amount);        }
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
            "earned":  jsonResponse['earned'],
            "expanse":(double.parse(jsonResponse['expanse'])+double.parse(amount)).toString(),
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit update response ${esponse.statusCode}");
      if(esponse.statusCode==200){
        await minusmonthlyprofituser(amount); }
    }

  }
  Future Minusprofitatclient(amount) async{
    String proid=DateFormat("yyyyMMdd").format(DateTime.now()) ;
    var url= Uri.https(profitapi, 'Profit/profit',{'id': clientid+proid});
    var response= await http.get(url );
    if(response.body.isEmpty){
      var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":clientid+proid,
            "user_i": clientid,
            "profit_id": proid,
            "profit": amount,
            "earned": "0",
            "expanse": amount,
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit add response ${response.statusCode}");
      if(response.statusCode==200){await minusmonthlyprofitclient(amount);        }
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
            "id":clientid+proid,
            "user_i": clientid,
            "profit_id": proid,
            "profit": (double.parse(jsonResponse['profit'])-double.parse(amount)).toString(),
            "earned":  jsonResponse['earned'],
            "expanse":(double.parse(jsonResponse['expanse'])+double.parse(amount)).toString(),
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit update response ${esponse.statusCode}");
      if(esponse.statusCode==200){minusmonthlyprofitclient(amount); }
    }
  }
  Future addmonthlyprofitclient  (amount)async{

    String monthid= DateFormat("yMMMM").format(DateTime.now());
    var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id': clientid+monthid});
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
     var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":clientid+monthid,
            "user_id": clientid,
            "monthly_profit_id":monthid,
            "monthly_profit": (double.parse(amount)).toString(),
            "Earned_amount": amount,
            "Expanse_amount": "0",
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year": DateFormat("yyyy").format(DateTime.now())
          }));       print("profitmnthly add response ${response.statusCode}");
    }
  }
  Future minusmonthlyprofituser  (amount)async{
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
            "monthly_profit": (double.parse(jsonResponse['monthly_profit'])-double.parse(amount)).toString(),
            "Earned_amount": (double.parse(jsonResponse['Earned_amount'])).toString(),
            "Expanse_amount":( double.parse(jsonResponse['Expanse_amount'].toString())+double.parse(amount)).toString(),
            "month": jsonResponse['month'],
            "year": jsonResponse['year']
          }));
      print("profitmnthly update response ${esponse.statusCode}");
    }
    else{
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+monthid,
            "user_id": userid,
            "monthly_profit_id":monthid,
            "monthly_profit": (-double.parse(amount)).toString(),
            "Earned_amount": '0',
            "Expanse_amount": amount,
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year": DateFormat("yyyy").format(DateTime.now())
          }));       print("profitmnthly add response ${response.statusCode}");
    }
  }
  Future minusmonthlyprofitclient(amount)async{

    String monthid= DateFormat("yMMMM").format(DateTime.now());
    var url= Uri.https(monthlyprofitapi, 'Monthlyprofit/monthltprofitrecord',{'id': clientid+monthid});
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
            "monthly_profit": (double.parse(jsonResponse['monthly_profit'])-double.parse(amount)).toString(),
            "Earned_amount": (double.parse(jsonResponse['Earned_amount']) ).toString(),
            "Expanse_amount":(double.parse(jsonResponse['Expanse_amount'])+double.parse(amount) ).toString(),
            "month": jsonResponse['month'],
            "year": jsonResponse['year']
          }));
      print("profitmnthly update response ${esponse.statusCode}");
    }
    else{
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":clientid+monthid,
            "user_id": clientid,
            "monthly_profit_id":monthid,
            "monthly_profit": (-double.parse(amount)).toString(),
            "Earned_amount":'0',
            "Expanse_amount": amount,
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year": DateFormat("yyyy").format(DateTime.now())
          }));       print("profitmnthly add response ${response.statusCode}");
    }
  }

  Future addexpanseatclient(amount)async{

    var url = Uri.https(expanserecapi, 'ExpanseRecord/expanserecord');
    var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "id":clientid+ DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "user_id": clientid,
          "expanse_id": DateFormat("yyyyMMdd").format(DateTime.now()),
          "expanse_record_id":DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
          "expanse_name": "Paid to $restroname",
          "description": "Paid to $restroname",
          "investment": investment,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "time": DateFormat("HH:mm:ss").format(DateTime.now()),
          "status": "Paid"}));
    print('expansereportResponse status: ${response.statusCode}');
    if(response.statusCode==200){
      String id= DateFormat("yyyyMMdd").format(DateTime.now());
      var url= Uri.https(expanseapi, 'Expanse/expanse',{'id': clientid+id});
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
            "id":clientid+id,
            "user_id": clientid,
            "expanse_id": id,
            "expanse": investment,
            "status": 'Paid',
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
          "status": jsonResponse['status'],
          "date":jsonResponse['date']
        }),);
      print("exresponse update  ${exresponse.statusCode}");
      }
    }
  }
  Future minusdoesmonthlyprofitrecordexist(String expn, String exdate,) async {

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
            "monthly_profit": (double.parse(jsonResponse['monthly_profit'])-double.parse(expn)).toString(),
            "Earned_amount": (double.parse(jsonResponse['Earned_amount']) ).toString(),
            "Expanse_amount":(double.parse(jsonResponse['Expanse_amount'])+double.parse(expn) ).toString(),
            "month": jsonResponse['month'],
            "year": jsonResponse['year']
          }));
      print("profitmnthly update response ${esponse.statusCode}");
    }
    else{
      var esponse = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "id":userid+monthid,
            "user_id": userid,
            "monthly_profit_id":monthid,
            "monthly_profit": (-double.parse(expn)).toString(),
            "Earned_amount":'0',
            "Expanse_amount": expn,
            "month": DateFormat("MMMM").format(DateTime.now()),
            "year": DateFormat("yyyy").format(DateTime.now())
          }));       print("profitmnthly add response ${response.statusCode}");
    }
  }
  Future<void> MinusdoesProfitAlreadyExist(String name) async {

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
            "profit": "-$name",
            "earned": "0",
            "expanse": name,
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit add response ${response.statusCode}");
      if(response.statusCode==200){
        minusdoesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), );}
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
            "profit": (double.parse(jsonResponse['profit'])-double.parse(name)).toString(),
            "earned": (double.parse(jsonResponse['earned'])).toString(),
            "expanse":  (double.parse(jsonResponse['expanse'])+double.parse(name)).toString(),
            "date": DateFormat("yMMMMdd").format(DateTime.now()) ,
            "month": DateFormat("MMMM").format(DateTime.now()) ,
            "year": DateFormat("yyyy").format(DateTime.now())
          }));
      print("profit update response ${esponse.statusCode}");
      if(esponse.statusCode==200){
        minusdoesmonthlyprofitrecordexist(name, DateFormat("yyyyMMdd").format(DateTime.now()), );
      }
    }
  }
  void sendPushMessage(String token, String body, String title) async {
    print(token);
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAJar-Hqk:APA91bFIJP21yCDov5m95sLLjgi298b7-2N2Qjdy-VMmCjZvXFZC1dMVMoIzVUlpPc4YYezuAu7JqYaWftXNMRT40Ttlhtw5n0RixcQjy4pqzIu0BNuhUiKGc4g9rfes5heRSiJBB8ki'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

}

