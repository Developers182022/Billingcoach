import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../models/AcceptedSuppliers.dart';
import '../models/Notifications.dart';
import '../models/ReceivedRequests.dart';
import '../models/SentRequest.dart';
import '../models/Suppliers.dart';
import '../models/UserToken.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'package:http/http.dart' as http;

import 'Pending_payments.dart';
import 'login/Login.dart';
import 'sentRequest.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'Notifications.dart';
class PrintReport extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const PrintReport({Key? key, this.clid}) : super(key: key);
  final clid;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'The Billing Coach',
            theme: ThemeData(primarySwatch: Colors.blue,
                primaryColor: Colors.black87,
                primaryColorDark:Colors.white,
                fontFamily: 'RobotoMono'),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home:  PrintReportPage(clird:clid),
          );
        });
  }
}
class PrintReportPage extends StatefulWidget {
  const PrintReportPage({Key? key,this.clird}) : super(key: key);
  final clird;
  @override
  State<PrintReportPage> createState() => _PrintReportState(clientid: clird);
}
class _PrintReportState extends State<PrintReportPage> {
  _PrintReportState({this.clientid});
  final clientid;
  bool ActiveConnection = false;
  String T = "";
  var doc;
  String userid= "";
  var hm;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String restroname="", phoneno="", address="", areacode="", profileimg="";
  String cshop="", cuserame="", cphone="";
  String itemimage="";var customerrecordlist=[];
  List<String> datelist=[],
      timelist=[]    , sentlist=[]  , receivedlist=[], descriptionlist=[];
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
  getuserdetails() async {
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
      await getcustomerrecord(counter);}
    else{runApp(LoginScreen());}
  }
  @override
  void initState() {
    CheckUserConnection();
    getuserdetails();
    super.initState();
  }
  getcustomerrecord(String uid)async {
    var url= Uri.https(customerlistapi, 'CustomerList/customerlists',);
    var response= await http.get(url );
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    print("stocklosy--  ${jsonDecode(response.body)}");
    var tagObjsJson = jsonDecode(response.body)['products'] as List;
    print(tagObjsJson.length);
    for(int i=0; i<tagObjsJson.length; i++){
      var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==uid && jnResponse['customer_id']==clientid ){print("outgj-- $jnResponse");
      setState((){
        cuserame=    jnResponse['customer_name'    ].toString();
        cphone=  jnResponse['customer_phone_no'].toString();
      });
      }
    }
    print(clientid);

    var curl= Uri.https(customerrecordapi, 'CustomerRecords/customerrecords',);
    var cresponse= await http.get(curl );
    var ctagObjsJson = jsonDecode(cresponse.body)['products'] as List;
    print(ctagObjsJson.length);
    for(int i=0; i<ctagObjsJson.length; i++){
      var jnResponse = ctagObjsJson[i] as Map<String, dynamic>;
      if(jnResponse['user_id']==uid && jnResponse['client_id']==clientid ){print("outgj-- $jnResponse");
      setState((){
        customerrecordlist.add(jnResponse);
      });
      }
    }
    print("customerrecordlist  $customerrecordlist");

  }/*{
    try {
      List<CustomerRecord> CustomerRecords = await Amplify.DataStore.query(CustomerRecord.classType,
      where: CustomerRecord.USER_ID.eq(uid).and(CustomerRecord.CLIENT_ID.eq(clientid)));
      for(int i=0; i<CustomerRecords.length; i++){
        print(CustomerRecords[i]);
        datelist.add(CustomerRecords[i].date.toString());
        timelist.add(CustomerRecords[i].time.toString());
        sentlist.add(CustomerRecords[i].sent_amount.toString());
        receivedlist.add(CustomerRecords[i].received_amount.toString());
        descriptionlist.add(CustomerRecords[i].description.toString());

    }
    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }
  }*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
              body: PdfPreview(
                build: (format) => _generatePdf(format, clientid),
              ),
          ),);
  }
  Future<Uint8List> _generatePdf(PdfPageFormat format,
      String title) async {
    print(timelist.length);
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoImage= pw.MemoryImage((await rootBundle.load('assets/logofront.png')).buffer.asUint8List(),);
    final backImage= pw.MemoryImage((await rootBundle.load('assets/logofront.png')).buffer.asUint8List(),);

    Image.asset('assets/logofront.png', height: 60,width: 60,);
    const imageProvider =  AssetImage('assets/logofront.png');
    var listlength=0.0;
    print(timelist.length   )    ;
    var len = timelist.length / 8;
    for (int i = 0; i < len; i++) {
      if(len>i||len<i+1){
        print(len-i);
        double inDouble = double.parse((len-i).toStringAsFixed(2));
        print(inDouble);
        listlength=inDouble+1;
      }else{
        listlength=(i+1).toDouble();
      }
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Container(decoration: ( pw.BoxDecoration(
              image: pw.DecorationImage(
                image: backImage,
                fit: pw.BoxFit.cover,
              ))),

            child: pw.Column(
              children: [
                pw.Row(children: [pw.Image(logoImage, height:60, ),]),
                pw.Row(children: [pw.Text(restroname,style: pw.TextStyle(fontSize: 17) ),]),
                pw.Row(children: [pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // title!=""?pw.Text("Invoice no :-$title", style: pw.TextStyle( fontSize: 17)):pw.Container(),
                      pw.Text("Invoice to:- $cuserame", style: pw.TextStyle( fontSize: 17))]),
                  pw.Container(margin :pw.EdgeInsets.only(right: 40, left: 135)     ,
                      child:pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end,
                          children:[pw.Text("Date:-${DateFormat("yyyy-MM-dd").format(DateTime.now())}", style: pw.TextStyle( fontSize: 15)),
                            pw.Text("Time:-${DateFormat("HH:mm:ss").format(DateTime.now())}", style: pw.TextStyle( fontSize: 15), ),])),]),

                // pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Divider(height: 2),
               pw.Padding(
                    padding: pw.EdgeInsets.all(10),
                    child: pw.Table(
                      defaultColumnWidth: pw.IntrinsicColumnWidth(),
                      children: [
                        pw.TableRow(
                            children: [
                              pw.Column(children: [pw.Container(width:40,
                                  child:pw.Center(child:pw.Text('Sno.',
                                      style: pw.TextStyle(fontSize: 16.0))))
                              ]),
                              pw.Column(children: [pw.Container(width:100,
                                  child:pw.Center(child: pw.Text('Entries',
                                  style: pw.TextStyle(fontSize: 16.0))))
                              ]),
                              pw.Column(children: [pw.Container(width:100,
                                  child:pw.Center(child:pw.Text(
                                  'You gave', style: pw.TextStyle(fontSize: 16.0))))
                              ]),
                              pw.Column(children: [pw.Container(width:100,
                                  child:pw.Center(child: pw.Text('You got',
                                  style: pw.TextStyle(fontSize: 16.0))))
                              ]),
                            ]),
                      ],
                    )
                ),
                pw.Divider(height: 2),
                pw.ListView.builder(
                  // the number of items in the list
                    itemCount:((listlength.toInt()*8)),
                    // display each item of the product list
                    itemBuilder: (context, index) {
                      var indises=0;
                      if(i==0){indises=index;}
                      else{indises= index+8*i;
                      print(index+10*i-1);}
                       return pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Table(
                            defaultColumnWidth: pw.IntrinsicColumnWidth(),
                          /*  border: pw.TableBorder.all(
                              // color: Colors.black,
                              style: pw.BorderStyle.solid,
                              width: 2,),*/
                            children: [
                              pw.TableRow(
                                  children: [
                                    pw.Column(children: [
                                      indises<datelist.length? pw.Container(width:40,child:pw.Center(child: pw.Text((indises+1).toString(),
                                          style: pw.TextStyle(fontSize: 16.0)))):pw.Container()
                                    ]),
                                    indises<datelist.length? pw.Container(width: 100, child:pw.Center(child: pw.Column(children: [
                                     pw.Text(datelist[indises],
                                         style: pw.TextStyle(fontSize: 14.0)),
                                     pw.Text(timelist[indises],
                                         style: pw.TextStyle(fontSize: 16.0))
                                   ]),)):pw.Container(),
                                    pw.Column(children: [
                                      indises<datelist.length? pw.Container(width:100,
                                         child:pw.Center(child: pw.Text(sentlist[indises],
                                         style: pw.TextStyle(fontSize: 16.0)))):pw.Container()
                                    ]),
                                    pw.Column(children: [
                                      indises<datelist.length?  pw.Container(width:100,
                                          child:pw.Center(child:pw.Text(receivedlist[indises],
                                          style: pw.TextStyle(fontSize: 16.0)))):pw.Container()
                                    ]),

                                  ]),
                            ],
                          ));
                    }),
                    pw.Divider(height: 2),
                pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children:[pw.Text("The Billing Coach", style: pw.TextStyle(fontSize: 20))])
                  ],
                )
          );
        },
      ),
    );
  }
    return pdf.save();
  }
}

