import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'HomePage.dart';
import 'loadingview.dart';
import 'login/Login.dart';
import 'package:webappbillingcoach/reusable_widgets/apis.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Aboutus extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Aboutus({Key? key}) : super(key: key);
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
            home:  const AboutusPage(user: "userid"),
          );
        });
  }
}

class AboutusPage extends StatefulWidget {
  const AboutusPage({Key? key, required this.user}) : super(key: key);

  final String user;

  @override
  State<AboutusPage> createState() => _itemPageState();
}

class _itemPageState extends State<AboutusPage> {

  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String userid="", contactno="",mailid="" ;
  String restroname="", phoneno="", address="", areacode="", email="";
  var addq=false, addqbtn=true;
  Future<void>? _launched;
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
        appBar: AppBar( backgroundColor: Theme.of(context).primaryColorDark,
          leading:TextButton(onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));},
              child:Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey,width: 1)),
              padding:EdgeInsets.all(4),
              child:Icon(Icons.arrow_back,color:Theme.of(context).primaryColor,))),
          title: Text(
            "About  Us",
            style: TextStyle(color:Theme.of(context).primaryColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [Container(margin: EdgeInsets.only(top: 20, right: 10),
              child: Text("The Billing Coach", style: TextStyle(color:Theme.of(context).primaryColor,fontSize: 12, fontStyle: FontStyle.italic),),)
          ],
          // centerTitle: true,
        ),
        body:  RefreshIndicator(
            onRefresh:()async{
              await getfeatures();},
            child:features.isNotEmpty? Container(decoration: BoxDecoration(color: Colors.transparent),
                      child:SingleChildScrollView(child:
                  Center(child:Container(padding: EdgeInsets.all(20),
                      child:Text(features[0]['about_us'].toString(),
                          style:TextStyle(color:Theme.of(context).primaryColor,
                              fontSize: 18)))))):LoadingView()),
        bottomNavigationBar: Container(child:Row(children: [
          IconButton(
            tooltip: "Contact Us via call",
            icon: const FaIcon(FontAwesomeIcons.phone),
            onPressed: () async { await FirebaseAnalytics.instance.logEvent(
              name: "Tried_to_Contact",
              parameters: {
                "user_id": userid,
              },
            );
              setState(() {
                _launched = _makePhoneCall(contactno);

              },);
            },
          ),
          IconButton( tooltip: "Contact Us via text",
            icon: const FaIcon(FontAwesomeIcons.message),
            onPressed: () async{await FirebaseAnalytics.instance.logEvent(
              name: "Tried_to_Contact",
              parameters: {
                "user_id": userid,
              },
            );
              setState(() {
                _launched = _sendingSMS(contactno);

              },);
            },
          ),
          IconButton(
            tooltip: "Contact Us via mail",
            icon: const Icon(Icons.mail),
            onPressed: ()async {await FirebaseAnalytics.instance.logEvent(
              name: "Tried_to_Contact",
              parameters: {
                "user_id": userid,
              },
            );
                var url = Uri.parse("mailto:"+mailid);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }

            },
          ),
          IconButton(
            tooltip: "Contact Us via whatsApp",
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            onPressed: () async{await FirebaseAnalytics.instance.logEvent(
              name: "Tried_to_Contact",
              parameters: {
                "user_id": userid,
              },
            );
              setState(() {
              _launchWhatsapp(context, contactno);
              },);
            },
          ),],)),
      ),);
  }
  Future<void> _launchInWebViewOrVC(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $url';
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
