import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webappbillingcoach/Screens/login/signup.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../reusable_widgets/apis.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../HomePage.dart';
import '../Orders.dart';
import '../Stock.dart';
import '../menu.dart';
import 'Resetpassword.dart';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class LoginScreen extends StatelessWidget
{
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  const LoginScreen({Key? key}) : super(key: key);
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
                primaryColorDark:Colors.white ),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            home:   LoginPage(),
          );
        });
  }
}
class LoginPage extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationCodeController= TextEditingController();
  String emailid= "", newpassword="", confirmationcode="";
  bool cofirmcod=false;
  int currentIndex = 0;
  var appfeqature=[];
  final PageController controller = PageController();

  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  @override
  void initState() {
    getfeatures();
    getcurrentuser();
    super.initState();
  }
  getfeatures()async {
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
  }
  getcurrentuser()async{
    final SharedPreferences prefs = await preferences;
    final counter = prefs.getString('user_Id');
     if( counter != null ) {runApp(Home());}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
          padding: EdgeInsets.all(50),
          width: double.maxFinite,
          height: double.maxFinite,
          decoration: BoxDecoration(
          ),
          child: SingleChildScrollView(
            child:/*Table(
              defaultColumnWidth: FixedColumnWidth(250),
              children:[
                TableRow(
                  children: [
                    Column(children:[Container(padding: EdgeInsets.all(50),child:Card(child:SizedBox(
                      // height: 300,
                      width: double.infinity,
                      child: PageView.builder(
                        controller: controller,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index % appfeqature.length;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              height: double.maxFinite,
                                width: double.infinity,
                                child: Column(children: [
                                  Lottie.network(
                                    appfeqature[index % appfeqature.length]['feature_id'],
                                    height: 120,  fit: BoxFit.cover,
                                  ),
                                  Container(padding:EdgeInsets.all(25),
                                      child:Center(
                                      child:Text(appfeqature[index % appfeqature.length]['feature_name'])
                                  )),
                                  Center(
                                      child:Text(appfeqature[index % appfeqature.length]['feature_description'])
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            controller.jumpToPage(currentIndex - 1);
                                          },
                                          icon: Icon(Icons.arrow_back, color:Theme.of(context).primaryColor,),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            controller.jumpToPage(currentIndex + 1);
                                          },
                                          icon: Icon(Icons.arrow_forward,color:Theme.of(context).primaryColor,),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],)
                            ),
                          );
                        },
                      ),
                    ))) ,]),
                   Column(children: [Container(child:Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Lottie.asset("assets/animations/loginbg.json", height: 250, width: 300),
                       SizedBox(height:5,),
                       Image.asset('assets/logofront.png', height: 60,width: 60,),
                       SizedBox(height: 10,),
                       Text("The Billing Coach", style: TextStyle( fontSize: 28,color: Colors.blue),),
                       SizedBox(height: 25,),
                       reusableTextField("Enter Email", Icons.person_outline, false,
                           _emailController),
                       SizedBox(height: 10,),
                       reusableTextField("Enter Password", Icons.lock_outline, true,
                           _passwordController),
                       TextButton(onPressed:(){//runApp(Loginpage());
                         // Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmResetScreen(email: _emailController.text, password: '')));

                       }, child: Center(//margin: EdgeInsets.only(left: 150),
                         child: Text("Forget password?",
                           style: TextStyle( fontSize: 14),) ,)
                       ),
                       cofirmcod?reusableTextField("Enter Verification Code", Icons.lock_outline, true,
                           _confirmationCodeController):Container(),
                       cofirmcod?TextButton(
                         onPressed: () => _resendCode(context),
                         child: Center(//margin:EdgeInsets.only(left: 150, ),
                           child: Text("Resend code", style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),),),
                       ):Container(),
                       TextButton(
                         child:  Container(width:double.maxFinite,
                             height: 50,
                             // padding: EdgeInsets.all(10),
                             decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),
                                 color: Colors.blue),
                             child:Center(child:Text("Login", style: TextStyle(color: Colors.white, fontSize: 16),),) ),
                         onPressed:cofirmcod? (){_submitCode(context);}:() async {
                           _loginButtonOnPressed(context);
                         },
                         // color: Theme.of(context).primaryColor,
                       ),
                       SizedBox(
                         height: 5,
                       ),
                       TextButton(
                         child: Container(width:double.maxFinite,
                             height: 50,
                             // padding: EdgeInsets.all(10),
                             decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),
                                 color: Colors.blue),
                             child:Center(child:Text("Create New Account", style: TextStyle(color: Colors.white, fontSize: 16),),) ),
                         onPressed: () => _gotoSignUpScreen(context),
                         // color: Theme.of(context).primaryColor,
                       ),
                       SizedBox(height:50)
                     ],
                   ))],),
                  ]
                )
              ]
            )*/
            Container(margin: EdgeInsets.all(15),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/animations/loginbg.json", height: 250, width: 300),
                  SizedBox(height:5,),
                  Image.asset('assets/logofront.png', height: 60,width: 60,),
                  SizedBox(height: 10,),
                  Text("The Billing Coach", style: TextStyle( fontSize: 28,color: Colors.blue),),
                  SizedBox(height: 25,),
                  reusableTextField("Enter Email", Icons.person_outline, false,
                      _emailController),
                  SizedBox(height: 10,),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      _passwordController),
                  TextButton(onPressed:(){//runApp(Loginpage());
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmResetScreen(email: _emailController.text, password: '')));

                  }, child: Center(//margin: EdgeInsets.only(left: 150),
                    child: Text("Forget password?",
                      style: TextStyle( fontSize: 14),) ,)
                  ),
                  cofirmcod?reusableTextField("Enter Verification Code", Icons.lock_outline, true,
                      _confirmationCodeController):Container(),
                  cofirmcod?TextButton(
                    onPressed: () => _resendCode(context),
                    child: Center(//margin:EdgeInsets.only(left: 150, ),
                      child: Text("Resend code", style: TextStyle(fontWeight: FontWeight.bold),),),
                  ):Container(),
                  TextButton(
                    child:  Container(width:double.maxFinite,
                        height: 50,
                        // padding: EdgeInsets.all(10),
                        decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child:Center(child:Text("Login", style: TextStyle(color: Colors.white, fontSize: 16),),) ),
                    onPressed:cofirmcod? (){_submitCode(context);}:() async {
                          _loginButtonOnPressed(context);
                    },
                    // color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    child: Container(width:double.maxFinite,
                        height: 50,
                        // padding: EdgeInsets.all(10),
                        decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child:Center(child:Text("Create New Account", style: TextStyle(color: Colors.white, fontSize: 16),),) ),
                    onPressed: () => _gotoSignUpScreen(context),
                    // color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),)
      ),
    );
  }
  Future<void> _submitCode(BuildContext context) async {
    opendialog(context);
    final email= _emailController.text;
    final confirmationCode = _confirmationCodeController.text;
    final userPool = CognitoUserPool(
      'ap-south-1_Neys1l0mA',
      '6ec1amnm04b7n0n6u5tb4v2hir',
    );
    final cognitoUser = CognitoUser(email, userPool);

    try {
      print("object");
     var  registrationConfirmed = await cognitoUser.confirmRegistration(confirmationCode);
    print(registrationConfirmed);
    if(registrationConfirmed==true){
      Fluttertoast.showToast(msg: "Verification success, Kindly login.");
    }

    } on CognitoClientException catch (e) {
      Navigator.of(context, rootNavigator: true).pop(context);
      Fluttertoast.showToast(msg: e.message.toString());
      print(e.message);
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(e.message.toString(),
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      );
    }
  }
  Future _onRecoverPassword(BuildContext context, String email) async {
    try {
      final res = await Amplify.Auth.resetPassword(username: email);
      print("object------   "+res.nextStep.updateStep);
      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmResetScreen(email: email, password: '')));
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmResetScreen(email: email, password: '')));
        return res.nextStep.updateStep;
      }
    } on AuthException catch (e) {
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }
  Future<void> _loginButtonOnPressed(BuildContext context) async {
    final email= _emailController.text;
    final password= _passwordController.text;
    final userPool = CognitoUserPool(
      'ap-south-1_Neys1l0mA',
      '6ec1amnm04b7n0n6u5tb4v2hir',
    );
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );
    try{
    final session = await cognitoUser.authenticateUser(authDetails);
      var ses= await cognitoUser.getSignInUserSession();
      var url = Uri.https(tokenapi, 'UsertokenList/usertokens', {'id':email});
      await FirebaseMessaging.instance.getToken().then(
              (token) async {
            print(email);
            await saveToken(token.toString(), email);
          });
      print("object$ses  jhgf  ${cognitoUser.getSession()}");
      final SharedPreferences prefs = await preferences;
     prefs.setString('user_Id',email );
      runApp(Home());
      print("Logging");
    print(session);
    }on CognitoClientException catch(E){
      print(E);
      Fluttertoast.showToast(msg: E.message.toString());
    }on CognitoUserException catch (e) {
      print("object   $e");
      try {
        var status = await cognitoUser.resendConfirmationCode();
        print("ffff      ${cognitoUser.authenticationFlowType}");
        setState(() {cofirmcod = true;});
        Fluttertoast.showToast(msg: '$e Confirmation code resent. Check your email');
      }  catch (e) {      print("objectclient   $e");
      Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
  void _resetPassword(BuildContext context, email,  String code,
      String password) async {
    try {
      final res = await Amplify.Auth.confirmResetPassword(
        username:email,
        newPassword: password,
        confirmationCode: code,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Password changed successfully. Please log in',
            style: TextStyle(fontSize: 15),
          ),
        ),
      );

      // Navigator.of(context).pushReplacementNamed('/');
    } on AuthException catch (e) {
      // Fluttertoast.showToast(msg: '${e.message} - ${e.underlyingException}');
    }
  }
  void _resendCode(BuildContext context) async {
    final email= _emailController.text;
    final userPool = CognitoUserPool(
      'ap-south-1_Neys1l0mA',
      '6ec1amnm04b7n0n6u5tb4v2hir',
    );
    final cognitoUser = CognitoUser(email, userPool);
    try {
      var status = await cognitoUser.resendConfirmationCode();
      setState(()=>cofirmcod=true) ;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text('Confirmation code resent. Check your email',
              style: TextStyle(fontSize: 15)),
        ),
      );
    } on AuthException catch (e) {
      Fluttertoast.showToast(msg:e.message);
    }
  }
  void _gotoSignUpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterUserPage(),
      ),
    );
  }

  opendialog(BuildContext context) {
    showDialog(
        context: context,
        builder:  (BuildContext context)
        {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              content: Container(
                width: 400,
                height: 200,
                padding: EdgeInsets.all(30),
                child:Column(children: [
                  SizedBox(height: 15,),
                  CircularProgressIndicator(),
                  SizedBox(height: 50,),
                  Text(cofirmcod?"Verifing...":"Logging In..."),
                ],),
              ),
            );
          });
        });
  }

  saveToken(String token, String userId) async {
    var url= Uri.https(tokenapi, 'UsertokenList/usertokens', );
    var response = await http.post(url,   headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, String>{
        "id": userId,
        "user_id": userId,
        "token": token}),);

  }
}

