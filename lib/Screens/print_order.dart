
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'Notifications.dart';
import 'login/Login.dart';

class Printorder extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  Printorder(this.orderid,this.title,this.orderdate, this.time, this.itemlist, this.itemprice, this.itemquantity, this.itemtotal, this.total, this.mode, this.additional, this.discount ,{Key? key}) : super(key: key);
  final  total, orderid, additional, discount;
  final String title, orderdate, time, mode;
  List<String> itemlist=[];
  List<String> itemprice=[] ;
  List<String> itemquantity=[]  ;
  List<String> itemtotal=[];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            // Remove the debug banner
            debugShowCheckedModeBanner: false,
            title: 'The Billing Coach',
            theme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.black,
                brightness: Brightness.light,
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData(//primarySwatch: Color(25, 25, 25),
                primaryColor: Colors.white,
                brightness: Brightness.dark,
                primaryColorDark:Colors.black ),
            themeMode: ThemeMode.system,
            home:  PrintOrderPage(orderid,title,orderdate, time, itemlist, itemprice, itemquantity, itemtotal, total, mode ,additional, discount),
          );
        });
  }
}
class PrintOrderPage extends StatefulWidget {
  PrintOrderPage(this.orderid, this.title,this.orderdate, this.time, this.itemlist, this.itemprice, this.itemquantity, this.itemtotal, this.total, this.mode , this.additional, this.discount,{Key? key}) : super(key: key);
  final  total, orderid, additional, discount;
  final String title, orderdate, time, mode;
  List<String> itemlist=[];
  List<String> itemprice=[] ;
  List<String> itemquantity=[]  ;
  List<String> itemtotal=[];
  @override
  State<PrintOrderPage> createState() =>  _PrintReportState(orderid,title,orderdate, time, itemlist, itemprice, itemquantity, itemtotal, total, mode ,additional, discount);
}


class _PrintReportState extends  State<PrintOrderPage> {
  _PrintReportState(this.orderid,this.title,this.orderdate, this.time, this.itemlist, this.itemprice, this.itemquantity,
      this.itemtotal, this.total, this.mode, this.additional, this.discount );
  final  total, orderid, additional, discount;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  final String title, orderdate, time, mode;
  List<String> itemlist=[];
  List<String> itemprice=[] ;
  List<String> itemquantity=[]  ;
  List<String> itemtotal=[];

  String userid="", restroname="";

  Future<void> getuserdetails() async  {
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
        });}
    }


    }
    else{runApp(LoginScreen());}
  }

   @override
   void initState() {
     getuserdetails();
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: BackButton(color:Theme.of(context).primaryColor,),
          title: Text('Print '+title, style: TextStyle(color:Theme.of(context).primaryColor,),),
          backgroundColor:Theme.of(context).primaryColorDark,
          actions: [
            Container(margin: EdgeInsets.only(top: 20, right: 10),
            child: Text("The Billing Coach", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic,color:Theme.of(context).primaryColor, ),),)
        ],),
        body: PdfPreview(
          build: (format) => _generatePdf(format, title),
        ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    print("nnnn------------"+itemlist.toString()) ;
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final logoImage= pw.MemoryImage((await rootBundle.load('assets/logofront.png')).buffer.asUint8List(),);
    Image.asset('assets/logofront.png', height: 60,width: 60,);

    const imageProvider = const AssetImage('assets/logofront.png');
    var listlength=0.0;
    print(itemlist.length   )    ;
    var len = itemlist.length / 10;
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
          return pw.Container(
            child: pw.Column(
            children: [
              pw.Row(children: [pw.Image(logoImage, height:60, ),]),
              pw.Row(children: [pw.Text(restroname,style: pw.TextStyle(fontSize: 17) ),]),
              pw.Divider(height: 5),
              pw.Table(defaultColumnWidth: pw.FixedColumnWidth(150),
                  children: [
              pw.TableRow(children: [pw.Column(mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [title!=""?pw.Text("Invoice no: "+ title, style: pw.TextStyle(fontSize: 17), ):pw.Text("Invoice no: 1", style: pw.TextStyle(fontSize: 17), ),]),
             pw.Column(mainAxisAlignment: pw.MainAxisAlignment.end,
                        crossAxisAlignment:  pw.CrossAxisAlignment.end,
                        children:[pw.Text("Date:-$orderdate", style: pw.TextStyle( fontSize: 15)),
                          mode!=""? pw.Text("Payment mode:-$mode", style: pw.TextStyle( fontSize: 15), ):pw.Container(),]),])]),

              pw.SizedBox(height: 5),
              pw.Divider(height: 2),
              pw.SizedBox(height: 10),
              pw.Row(children: [pw.Text("Bill to ", ),]),
              pw.SizedBox(height: 10),
              pw.Divider(height: 2),
              pw.Padding(
                padding: pw.EdgeInsets.all(10),
                  child:pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(120),
                    children: [
                      pw.TableRow(
                          children: [
                            pw.Column(children:[pw.Text('Sno.', style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold))]),
                            pw.Column(children:[pw.Text('Item name', style: pw.TextStyle(fontSize: 16.0, fontWeight: pw.FontWeight.bold))]),
                            pw.Column(children:[pw.Text('price', style: pw.TextStyle(fontSize:16.0, fontWeight: pw.FontWeight.bold))]),
                            pw.Column(children:[pw.Text('qty/ \nduration', style: pw.TextStyle(fontSize:16.0, fontWeight: pw.FontWeight.bold))]),
                            pw.Column(children:[pw.Text('Total', style: pw.TextStyle(fontSize:16.0, fontWeight: pw.FontWeight.bold))]),
                          ]),
                    ],
                  )
              ),
              pw.Divider(height: 2),
              pw.ListView.builder(

          // the number of items in the list
          itemCount:((listlength.toInt()*10)),
          // display each item of the product list
          itemBuilder: (context, index) {
            var indises=0;
            if(i==0){indises=index;}
            else{indises= index+10*i;
            print(index+10-1);}
          return pw. Padding(
          padding: const pw.EdgeInsets.all(10),
          child:pw.Table(
          defaultColumnWidth: pw.FixedColumnWidth(100),
            children: [
            pw.TableRow(
            children: [
              indises<itemlist.length? pw.Column(children:[pw.Text((indises+1).toString(), style: pw.TextStyle(fontSize: 16.0))]):pw.Container(),
              indises<itemlist.length? pw.Column(children:[pw.Text(itemlist[indises], style: pw.TextStyle(fontSize: 16.0))])    :pw.Container(),
              indises<itemlist.length? pw.Column(children:[pw.Text(itemprice[indises], style: pw.TextStyle(fontSize:16.0))])    :pw.Container(),
              indises<itemlist.length? pw.Column(children:[pw.Text(itemquantity[indises], style: pw.TextStyle(fontSize:16.0))]) :pw.Container(),
              indises<itemlist.length? pw.Column(children:[pw.Text(itemtotal[indises], style: pw.TextStyle(fontSize:16.0))])    :pw.Container(),
            ]),
            ],
            ));
          }),
              pw.Divider(height: 2),
                     pw.Container(width: double.maxFinite,
                     child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                         mainAxisAlignment: pw.MainAxisAlignment.end,
                         children: [
                          additional.isNotEmpty? pw.Container(padding: pw.EdgeInsets.only(right:10, top:8),child:pw.Text('Additional amount $additional', style: pw.TextStyle(fontSize:16.0))):pw.Container(),
                          discount.isNotEmpty?   pw.Container(padding: pw.EdgeInsets.only(right:10, top:8),child:pw.Text('Discount $discount', style: pw.TextStyle(fontSize:16.0))):pw.Container(),
                           pw.Container(padding: pw.EdgeInsets.only(right:10, top:8),child:pw.Text('Total $total', style: pw.TextStyle(fontSize:16.0))),
                           pw.SizedBox(height: 10)
                         ]),),

              pw.Divider(height: 2),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children:[pw.Text("The Billing Coach", style: pw.TextStyle(fontSize: 20))])

            ],
          ),
          );
        },
      ),

    );}
    return pdf.save();
  }

}



/*
import 'package:flutter/material.dart';
import 'package:testcloudstorage/pdfapi.dart';
import 'package:testcloudstorage/pdfparagraphapi.dart';

import '../reusable_widgets/btn.dart';
class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(""),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           TextButton(
              child:Text('Simple PDF') ,
              onPressed: () async {
                final pdfFile =
                await PdfApi.generateCenteredText('Sample Text');

                PdfApi.openFile(pdfFile);
              },
            ),
            const SizedBox(height: 24),
            ButtonWidget(
              text: 'Paragraphs PDF',
              onClicked: () async {
                final pdfFile = await PdfParagraphApi.generate();

                PdfApi.openFile(pdfFile);
              },
            ),
          ],
        ),
      ),
    ),
  );


}
*/
