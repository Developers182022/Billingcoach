import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Appfaqs.dart';
import '../models/Privacypolicy.dart';
import '../models/Suppliers.dart';
import '../reusable_widgets/apis.dart';
import 'HomePage.dart';
import 'Notifications.dart';
import 'login/Login.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Supplierdetails extends StatelessWidget {
  // Using "static" so that we can easily access it later
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  const Supplierdetails({Key? key}) : super(key: key);
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
            home:  const SupplierdetailsPage(),
          );
        });
  }
}
class SupplierdetailsPage extends StatefulWidget {
  const SupplierdetailsPage({Key? key,}) : super(key: key);


  @override
  State<SupplierdetailsPage> createState() => _itemPageState();
}
class _itemPageState extends State<SupplierdetailsPage> {
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
  var doc;
  var suplieridexist;
  String userid="", contactno="", mailid="";
  var Supplierss;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  String restroname="",link="" ,phoneno="", address="",delchrge="",delstts="", areacode="", profileimg="", email="";
  bool addetails=false, updatepasswrd=false, adddetailsbtn= true, updatepasswordbtn= true;
  String month="Month", day="Day", hour= "Hour", minute= "Minute", year="Year";
  bool onvalue = false, offvalue= false;
  var mode="", storename="", storeownername="", storemobno="", delivery="", storeaddress="",username="",
      deliverycharge="", upi="";
  var pageIndex=2;
  String appname= "The Billing Coach", deliverd= "Delivered" ;
  int _page=0;
  String fetchlocation='Fetch your restaurant location'.tr();
  final geolocator =
  Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? _currentPosition;
  String currentAddress = "";
  var first;
  var userlatitude, userlongitude, postaladdress, pincode;
  @override
  void didChangeDependencies(){
    if(1==1){
      // Theme.of(context).primaryColorLight;
    }
    super.didChangeDependencies();
  }
  void getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = p[0];

      setState(() {
        currentAddress =
        "${place.thoroughfare},${place.subThoroughfare},${place.name}, ${place.subLocality}";
        print("currentAddress------ $currentAddress");
      });
    } catch (e) {
      print(e);
    }
  }
  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    debugPrint('location: ${position.latitude}');
    List<Placemark> addresses = await
    placemarkFromCoordinates(position.latitude,position.longitude);
    userlatitude  = position.latitude;
    userlongitude = position.longitude;
    first = addresses.first;
    print(first);
    postaladdress=first.name +" "+ first.subLocality +" "+ first.locality +" "+ first.administrativeArea +" "+ first.country +" "+first.postalCode ;
    pincode= first.postalCode;
    print(first.subAdministrativeArea);
    print(first.subLocality);
    print(first.locality);
    print("${first.name} : ${first..administrativeArea} ");
    return first;
  }
  @override
  void initState() {
    getcurrentuser();
    super.initState();
  }
  Future<void> getcurrentuser()async{

       final SharedPreferences prefs = await preferences;
      var counter = prefs.getString('user_Id');
      if(counter!=null){
        await FirebaseAnalytics.instance.logEvent(
        name: "selected_to_register_As_supplier",
        parameters: {
          "user_id": counter,
        },
      );
        setState((){userid=counter;});
        var url= Uri.https(supplierapi, 'Suppliers/supplier',{'id': counter} );
        var response= await http.get(url );
        print(response.body);
        if(response.body.isNotEmpty){
          var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
          print("devvvvvvvvvvvvv--  ${jsonDecode(response.body)}");
          // if (this.mounted) {
            setState(() {
              suplieridexist=true;
              restroname = jsonResponse['shop_name'].toString();
              phoneno = jsonResponse['username'].toString();
              delstts= jsonResponse['delivery_status'].toString();
              delchrge = jsonResponse['delivery_charges'].toString();
              areacode = jsonResponse['supplier_name'].toString();
              username=   jsonResponse['username'].toString();
              storename= jsonResponse['shop_name'].toString();
              storeownername=  jsonResponse['supplier_name'].toString();
              storemobno=  jsonResponse['supplier_phone_no'].toString();
              storeaddress= jsonResponse['shop_address'].toString();
              deliverycharge= jsonResponse['delivery_charges'].toString();
              delivery= jsonResponse['delivery_status'].toString();
            });//}
        }
      }
      else{runApp(LoginScreen());}
  }
  var mobile;
  var count= 'IN';
  @override
  Widget build(BuildContext context) {
    if(delstts=="Yes"){
      offvalue=true;
    }
    if(delstts=="No"){
      onvalue=true;
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(  backgroundColor: Theme.of(context).primaryColorDark,
          leading: TextButton(child:Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey,width: 1)),
            child:Icon(Icons.arrow_back,
              color:Theme.of(context).primaryColor,)),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));}, ),
          title: Text(
            "Register as an Supplier",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            color:Theme.of(context).primaryColor,),
          ),
          // centerTitle: true,
        ),
        body: RefreshIndicator(
            onRefresh:()async{
           await getcurrentuser();},
            child: Container(
              width: 400,
              margin: EdgeInsets.only(top:10, bottom: 10),
              padding: EdgeInsets.all(15),
              height:double.infinity,
              child:SingleChildScrollView(child:
              Column(
                children: [
                  const SizedBox(
                    height:5,
                  ),
                  Container(
                    child: TextField(decoration: InputDecoration(
                      labelText: "Shop name.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "Shop name.".tr(),
                      prefixIcon: Icon(
                          Icons.storage),),
                      keyboardType: TextInputType.text,
                      controller: TextEditingController(text:storename),
                      onChanged: (value){
                        storename= value;
                      },),),
                  const SizedBox(
                    height:15,
                  ),
                  Container(
                    child: TextField(decoration: InputDecoration(
                      labelText: "Shop's owner name.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "Shop's owner name.".tr(),
                      prefixIcon: Icon(
                          Icons.storage),),
                      /*     style: TextStyle(color: Colors.white), */
                      controller: TextEditingController(text:storeownername ),
                      keyboardType: TextInputType.text,
                      onChanged: (value){ storeownername= value;
                      },),),
                  const SizedBox(
                    height:15,
                  ),
                  Container(
                    child: TextFormField(decoration: InputDecoration(
                      labelText: "Username.",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintText: "User name.".tr(),
                      prefixIcon: Icon(
                          Icons.person),),
                      controller:TextEditingController(text:username),
                      keyboardType: TextInputType.text,
                      onChanged: (value) {

                        username = value;
                      },),),
            /*      Container(
                      child:IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        controller: TextEditingController(text:storemobno),
                        countries: ['IN'],
                        flagsButtonPadding: EdgeInsets.only(left: 10),
                        showCountryFlag: false,
                        // controller: TextEditingController(text: storemobno),
                        initialCountryCode: count,
                        dropdownIconPosition: IconPosition.trailing,
                        onChanged: (phone) {
                         storemobno= phone.number;
                        },
                      )
                  ),
                  const SizedBox(
                    height:15,
                  ),
                  Container(
                      child: TextField(decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Address".tr(),
                        prefixIcon: Icon(
                            Icons.currency_rupee_rounded),),
                        controller: TextEditingController(text: storeaddress),
                        onChanged: (value) {
                            storeaddress = value;
                        },)
                  ),*/
                  const SizedBox(
                    height:15,
                  ),
                  Text("Do you provide delivery to your customer"),
                Row(crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                   Checkbox(
                     value: onvalue,
                     onChanged: (value) {
                       if(value==true) {
                         setState(() {
                           onvalue = true;
                           offvalue = false;
                         });
                       }else{ setState(() {
                         onvalue = false;
                       });}
                     },
                   ),
                   Text(
                     'No',
                     style: TextStyle(
                         fontSize: 17.0),
                   ), //Text
                   SizedBox(width: 20),
                   Checkbox(
                     value:offvalue,
                     onChanged: ( value) {
                       if(value==true){setState(() {
                         print(value);
                         offvalue =true;
                         onvalue = false;
                       });}else{ setState(() {
                         print(value);
                         offvalue =false;
                       });}
                     },
                   ),
                   Text(
                     'Yes',
                     style: TextStyle(
                         fontSize: 17.0),
                   ), //Text
                 ]),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      child: TextField(decoration: InputDecoration(
                        labelText: "Delivery charge.",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Delivery charge.".tr(),
                        prefixIcon: Icon(
                            Icons.currency_rupee_rounded),),
                        controller: TextEditingController(text: deliverycharge),
                        onChanged: (value) {
                            deliverycharge = value;
                        },)
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                    //   color: Colors.black54,),
                      width:300,
                      padding: EdgeInsets.only(right: 20, left: 10, top: 12 , bottom: 12),
                      child: Text("Note: Your menu items will be shown to your customer as supply items.")),

                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: addetails,
                    child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                    ),width: 30,
                        margin: EdgeInsets.only(bottom: 8),
                        child: CircularProgressIndicator()),
                  ),
                  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),width: double.maxFinite,
                      height:40,
                      child: TextButton(
                          onPressed: () async {
                            final num =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.[a-zA-Z]+");
                            if(onvalue== true){setState((){delivery= "No"; });}
                            if(offvalue==true){setState((){delivery= "Yes";});}
                            setState((){addetails=true;});
                            CheckUserConnection();
                            if(storename.isEmpty|| storeownername.isEmpty ||username.isEmpty){
                              setState((){addetails=false;});
                              Fluttertoast.showToast(msg: "Kindly fill all required fields.".tr());}
                            else if(username.contains(RegExp('^[0-9]'))==true||username.contains(RegExp('^[a-z]'))==true)
                            {
                              var url= Uri.https(supplierapi, 'Suppliers/suppliers', );
                              var response= await http.get(url );
                              print(response.body);
                              if(response.body.isNotEmpty){
                                var tagObjsJson = convert.jsonDecode(response.body)['products'] as List;
                                print(tagObjsJson.length);
                                for(int i=0; i<tagObjsJson.length; i++) {
                                  var jnResponse = tagObjsJson[i] as Map<String, dynamic>;
                                  if(jnResponse['username']== username && jnResponse['user_id']!= userid){
                                    Fluttertoast.showToast(msg: "Username already exist. please try again with another one.");
                                    setState((){addetails=false;});
                                  }else{
                                    var url= Uri.https(supplierapi, 'Suppliers/supplier', );
                                    var response = await http.post(url, headers: <String, String>{
                                        'Content-Type': 'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode(<String, String>{
                                        "id":userid,
                                        "supplier_id": userid,
                                        "supplier_name": storeownername,
                                        "shop_name": storename,
                                        "username": username,
                                        "supplier_phone_no": storemobno,
                                        "shop_address": storeaddress,
                                        "latitude_coordinate": userlatitude.toString(),
                                        "longitude_coordinate": userlongitude.toString(),
                                        "pincode": pincode.toString(),
                                        "delivery_status": delivery,
                                        "delivery_charges": deliverycharge,}),);
                                    if(response.statusCode==200){
                                      print(response.body);
                                      setState((){addetails=false;});
                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "registered_As_supplier",
                                        parameters: {
                                          "user_id": userid,
                                        },
                                      );
                                      await getcurrentuser();
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                                    }
                              else{Fluttertoast.showToast(msg: "Something went wrong! please try again..");}
                                  }
                                }
                              }
                               setState((){addetails=false;});
                            }
                            else{  setState((){addetails=false;});Fluttertoast.showToast(msg: "Username should be alphanumeric.");} },
                          child: Text(suplieridexist==null?"Register as supplier".tr():"Update", style: TextStyle(fontSize: 20, color: Colors.white),))),
                ],
              ),
              ),),
        ),

      ),);
  }
}
