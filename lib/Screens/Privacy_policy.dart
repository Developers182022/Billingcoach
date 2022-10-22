import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Privacypolicy.dart';
import 'HomePage.dart';
import 'loadingview.dart';
import 'login/Login.dart';
import 'package:webappbillingcoach/reusable_widgets/apis.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Policy extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Policy({Key? key}) : super(key: key);
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
            home:  const PolicyPage(),
          );
        });
  }
}
class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key,}) : super(key: key);


  @override
  State<PolicyPage> createState() => _itemPageState();
}
class _itemPageState extends State<PolicyPage> {
  var doc;
  String userid="", contactno="", mailid="";
  Future<void>? _launched;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  var features=[];
  @override
  void initState() {
    getcurrentuser();
    super.initState();
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
        features.add(jsonResponse);
        contactno= jsonResponse['contact_no'].toString();
        mailid=jsonResponse['contact_mail'].toString();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(  backgroundColor: Theme.of(context).primaryColorDark,
          leading:TextButton(child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey,width: 1)),
            padding:EdgeInsets.all(4),
            child:Icon(Icons.arrow_back,
            color:Theme.of(context).primaryColor,)),onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},),
          title: Text(
            "Privacy Policy",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color:Theme.of(context).primaryColor,),
          ),
          actions: [Container(margin: EdgeInsets.only(top: 20, right: 10),
              child: Text("The Billing Coach", style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic,
                color:Theme.of(context).primaryColor,),))
          ],
          // centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh:()async{
              await getfeatures();},
            child:features.isNotEmpty? Container(decoration: BoxDecoration(color: Colors.transparent),
                child:SingleChildScrollView(child:
                Center(child:Container(padding: EdgeInsets.all(20),
                    child:Text(features[0]['policy'].toString(),
                        style:TextStyle(color:Theme.of(context).primaryColor,
                            fontSize: 18)))))):LoadingView()),
      ),);
  }
}
