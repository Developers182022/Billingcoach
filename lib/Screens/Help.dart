import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Appfaqs.dart';
import '../models/Privacypolicy.dart';
import '../models/Queries.dart';
import '../reusable_widgets/apis.dart';
import 'HomePage.dart';
import 'Notifications.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Help extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Help({Key? key}) : super(key: key);
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
            home:   HelpPage(),
          );
        });
  }
}
class HelpPage extends StatefulWidget {
  @override
  _SearchListExampleState createState() => new _SearchListExampleState();
}
class _SearchListExampleState extends State<HelpPage> {
  List<dynamic> _list=[], _listphone=[];
  bool _isSearching= false;
  String _searchText = "";
  List searchresult = [], searchname=[];
  var doc;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
var features= [];
  final TextEditingController _controller = new TextEditingController();
  String userid="", contactno="",mailid="";
  String restroname="", phoneno="", address="", areacode="", email="";
  var addq=false, addqbtn=true;
  final globalKey = new GlobalKey<ScaffoldState>();

  Future<void>? _launched;
  @override
  void initState() {
   getcurrentuser();
   _isSearching = false;
   values();
    super.initState();
  }
  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }

  Future<void> getcurrentuser()async{
    await FirebaseAnalytics.instance.logEvent(
      name: "show_about_us",
    );
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){getfeatures();
    setState((){userid=counter;});
    }
    else{runApp(LoginScreen());}
  }
  Future<void> getfeatures() async {
    var url= Uri.https(privacypolicyapi, 'Privacypolicy/privacypolicy',{'id': "1"} );
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      setState(() {
        contactno= jsonResponse['contact_no'].toString();
        mailid=jsonResponse['contact_mail'].toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    List<int> selectedItemsMultiMenu = [];
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      key: globalKey,
      child: new Scaffold(
        appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor, )),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));}, ),
          title: Text(
            "Help",
            style: TextStyle(color:Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: Tab(child:Container(
            padding: EdgeInsets.only(left: 15, right:15, bottom: 8),
              child:TextField(
            controller: _controller,
            style: new TextStyle(
              color:Theme.of(context).primaryColor,
            ),
            decoration: new InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                prefixIcon: new Icon(Icons.search, color:Theme.of(context).primaryColor,),
                hintText: "Search...",
                contentPadding: EdgeInsets.zero,
                hintStyle: new TextStyle(color: Colors.grey)),
            keyboardType: TextInputType.text,
            onChanged: searchOperation,
          ))),
        ),
        body: RefreshIndicator(
    onRefresh:()async{values();},
    child:   new Container(
        child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Flexible(
                child: searchresult.length != 0 || _controller.text.isNotEmpty
                    ? new ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchresult.length,
                  itemBuilder: (BuildContext context, int index) {
                    String listData = searchresult[index];
                    String listname= searchname[index];
                    return new ExpansionTile(title:Container(padding:EdgeInsets.all(8),child:Text(listData)) ,
                        children: [ Divider( height: 2,
                          thickness: 2,),Container(padding:EdgeInsets.all(8),child:Text("Answer: "+listname))],);
                  },
                )
                    : ListView.builder(
                          shrinkWrap: true,
                          itemCount: features.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 4,
                              child: ExpansionTile(
                                title: Text(features[index]['faq_question'].toString()),

                                children: [
                                  Divider( height: 2,
                                    thickness: 2,),
                                  Container(width:double.infinity,
                                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 8),
                                    child:Text("Answer: "+features[index]['faq_answer'].toString()),)
                                ],
                              ),
                            );
                          }),

            )
          ],
        ),
      )),
        floatingActionButton:Container(width:150,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
            child:TextButton(onPressed: () async{
              await FirebaseAnalytics.instance.logEvent(
                name: "selected_toask_query",
                parameters: {
                  "user_id":  userid,
                },
              );
          String itemimage="", itemname="", itemprice="", quantity="";
          showDialog(
              context: context,
              builder: (BuildContext context)
              {
                return StatefulBuilder(builder: (BuildContext context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text("ASK QUERY".tr(),style: TextStyle(color: Colors.white, fontSize: 15),),
                    content:   Container(
                      width: 400,
                      height:250,
                      margin: EdgeInsets.only(top: 15, bottom: 16),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                            children:[
                              Container(
                                  child: TextField(decoration: InputDecoration(
                                      hintText: "Question".tr(),
                                      labelText: "Question",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      prefixIcon: Icon(
                                          Icons.production_quantity_limits)),
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      quantity = value;
                                    },)
                              ),
                              SizedBox(height: 10,),
                            ]
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      Column(children: [
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: addq,
                            child: Container(
                                margin: EdgeInsets.only(top: 50, bottom: 30),
                                child: CircularProgressIndicator()
                            )
                        ),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: addqbtn,
                          child: Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius
                                  .circular(15),
                                color: Colors.blue,
                              ), width: double.maxFinite,
                              height: 45,
                              child:  TextButton(onPressed: ()async{setState((){addq=true; addqbtn= false;});
                              String orderid= DateFormat("yyMMddHHmmss").format(DateTime.now());
                              var sum=0;
                              if(quantity.isEmpty){
                                setState((){addq=false; addqbtn= true;});
                                Fluttertoast.showToast(msg: "Kindly enter quantity.");
                              }
                              else{
                                final item = Queries(
                                    user_id:userid,
                                    question: quantity,
                                    answer: "",
                                    time: DateFormat("HH:mm:ss").format(DateTime.now()),
                                    date: DateFormat("yyyy-MM-dd").format(DateTime.now()),);
                                await Amplify.DataStore.save(item)
                                    .whenComplete(()async{print("faq finished");
                                await FirebaseAnalytics.instance.logEvent(
                                  name: "added_query",
                                  parameters: {
                                    "user_id":  userid,
                                  },
                                );
                                      Fluttertoast.showToast(msg: "Thank you for your response,"
                                          " we'll get back to you soon.");
                                setState((){addq=false; addqbtn= true;});});}
                              Navigator.pop(context);
                              setState((){ doc= Amplify.DataStore.query(Appfaqs.classType,where:Appfaqs.TOPIC_ID.ne("1"));});
                              }, child: Container(height:35, child:Text("POST QUERY", textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.white),)))),
                        ),]),
                    ],
                  );
                });
              });
        },
          child:Center(child:Text("ASK QUERIES", style: TextStyle(color: Colors.white, fontSize: 15),) ,))
        ),
        bottomNavigationBar: Container(child:Row(children: [
          IconButton(
          icon: const FaIcon(FontAwesomeIcons.phone),
          onPressed: () {
            setState(() {
              _launched = _makePhoneCall(contactno);
              },);
          },
        ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.message),
            onPressed: () {
              setState(() {
                _launched = _sendingSMS(contactno);
              },);
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              _sendingMails(mailid);
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () {
              setState(() {   _launchWhatsapp(context, contactno);
              //  _launched = _launchInWebViewOrVC(Uri.parse("https://mail.google.com/mail/u/0/#inbox?compose=CllgCJNxNdfZKVLBgGpTbSnQTcxZqRDwPtLqRDCLmMwZHzXhVSxrSHvPRtzjWqShNGjqrxqpGjB"));
              },);
            },
          ),],)
        ),
     ),);
  }
  Future<void> values() async {
    _list = [];
    _listphone=[];
    var url= Uri.https(helpapi, 'AppFaqs/appfaqlists',);
    var response= await http.get(url );
    if(response.body.isNotEmpty){
      var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
      print(tagObjsJson.length);
      for(int i=0; i<tagObjsJson.length; i++) {
        var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
        features.add(jnResponse);
          _list.add(jnResponse['faq_answer'].toString());
          _listphone.add(jnResponse['faq_question'].toString());
      }
    }
    print("lidsxcvhjjfdx   $_list");
  }
  Future<void> searchOperation(String searchText) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "searched_for_help",
      parameters: {
        "user_id":  userid,
      },
    );
    searchresult.clear();
    searchname.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _listphone.length; i++) {
        print(_listphone[i]);
          print("not exist");
          String data = _listphone[i];
          String name = _list[i];
          if (data.toLowerCase().contains(searchText.toLowerCase())) {
            searchresult.add(data);
            searchname.add(name);
          }
      }
    }
  }
  _launchWhatsapp(context, String mob) async {
    var whatsapp = mob;
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=Hello,\nI would like to learn about Billing Coach.&Image");
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
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
  _sendingSMS(String phoneNumber) async {
    var url = Uri.parse("sms:"+phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _sendingMails(String mail) async {
    var url = Uri.parse("mailto:"+mail);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

