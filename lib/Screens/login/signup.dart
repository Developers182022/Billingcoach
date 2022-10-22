import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../reusable_widgets/reusable_widget.dart';
import '../HomePage.dart';
import 'login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key,}) : super(key: key);
  @override
  State<RegisterUserPage> createState() => _signupState();
}
class _signupState extends State<RegisterUserPage> {
  bool ActiveConnection = false;
  String T = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationCodeController= TextEditingController();
  bool cofirmcod= false;
  bool enabletyping= true;
  @override
  void initState() {
    getcurrentuser();
    super.initState();
  }
  getcurrentuser()async{
    try{
      AuthUser user = await Amplify.Auth.getCurrentUser();
      if( user != null )
      {
        // runApp(Home());
      }}catch(e){print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 50, bottom: 50),
          margin: EdgeInsets.all(15),
          width: double.maxFinite,
          height: double.maxFinite,
          child: SingleChildScrollView(
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset("assets/animations/loginbg.json", height: 250, width: 300),
                    SizedBox(height:10,),
                    Image.asset('assets/logofront.png' ,height: 60,width: 60,),
                    SizedBox(height: 10,),
                    Text("The Billing Coach", style: TextStyle( fontSize: 28,color: Colors.blue),),
                    SizedBox(height: 15,),
                    TextField(
                  enabled: enabletyping,
                  controller: _emailController,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                    ),
                    labelText: "Enter Email",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none, )),
                  ),
                  keyboardType:  TextInputType.emailAddress,
                ),
                    const SizedBox(
                      height: 20,
                    ),
                TextField(
                  obscureText: true,
                  enableSuggestions: !true,
                  autocorrect: !true,
                  enabled: enabletyping,
                  controller: _passwordController,
                 cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white70,
                    ),
                    labelText: "Enter Password",
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(width: 0, style: BorderStyle.none, )),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                    const SizedBox(
                      height: 20,
                    ),
                    cofirmcod?reusableTextField("Enter Verification Code", Icons.lock_outline, true,
                        _confirmationCodeController):Container(),
                    cofirmcod?TextButton(
                      onPressed: () async {
                            _resendCode(context);
                      } ,
                      child: Container(margin:EdgeInsets.only(left: 70, ),
                        child: Text("Resend code", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),
                    ):Container(),
                     TextButton(
                          onPressed: cofirmcod?() async {
                              await _submitCode(context);
                            }:() async {
                             await _createAccountOnPressed(context);
                          },
                          child: Container(width: double.maxFinite,
                            height: 45,
                            margin: EdgeInsets.only(top:10),
                            decoration: BoxDecoration( borderRadius: BorderRadius.circular(30.0),
                              color: Colors.blue,
                            ),
                            child:Center(child:  Text('Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),)
              ,)),
                    const SizedBox(
                      width: 300,
                    ),
                    SignInOption(),
                  ],
                )
            ),
          ),
        ),
      ),);
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
  errordialog(BuildContext context, String msg) {
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
                  Text(msg),
                  SizedBox(height: 50,),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Container(
                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                      child:Text("Okay", style: TextStyle(color: Colors.white),)))
                ],),
              ),
            );
          });
        });
  }
  Row SignInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        TextButton(
          onPressed: (){Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen())
          );
          },
          child: const Text(
            " Login In",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        )
      ],
    );
  }
  Future<void> _createAccountOnPressed(BuildContext context) async {
    final userPool = CognitoUserPool(
      'ap-south-1_Neys1l0mA',
      '6ec1amnm04b7n0n6u5tb4v2hir',
    );
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
    final userAttributes = [
      AttributeArg(name: 'email', value: email),
    ];
      try{
        var data = await userPool.signUp(
          email,
          password,
          // userAttributes: userAttributes
        );
        print("hgtrdcvbhj  $data");
       if(data.user!=null) {
         print("odiugfdcvb");
         try {
           final cognitoUser = CognitoUser(email, userPool);
           print("ffff      ${cognitoUser.authenticationFlowType}");
           setState(() {cofirmcod = true;
            enabletyping=false;
            });
         } catch (e){
           print("uihgftrgv          $e");
           Fluttertoast.showToast(msg: e.toString());
         }
       }
  }on CognitoClientException  catch(e){
        print(e);
        Fluttertoast.showToast(msg: e.message.toString());
      /* Navigator.pop(context);
        if(e.message.contains('The password given is invalid.')) {
          errordialog(context, 'Password must have uppercase characters, numeric characters and symbol characters');
        } else{
          errordialog(context, e.message.toString());}*/
      }
  }
  void _resendCode(BuildContext context) async {
    try {
      final userPool = CognitoUserPool(
        'ap-south-1_8euTR5YQA',
        '59jiqdmbtdabj6tqrd7ce4u796',
      );
      final email = _emailController.text.trim();
      final cognitoUser = CognitoUser(email, userPool);
      var  status = await cognitoUser.resendConfirmationCode();
      Navigator.pop(context);
      errordialog(context,'Confirmation code resent. Check your email');
    } on CognitoClientException catch (e) {Navigator.pop(context);
    Fluttertoast.showToast(msg: e.message.toString());
    }
  }
  Future<void> _submitCode(BuildContext context) async {
    final confirmationCode = _confirmationCodeController.text;
    String email= _emailController.text;
    final userPool = CognitoUserPool(
      'ap-south-1_8euTR5YQA',
      '59jiqdmbtdabj6tqrd7ce4u796',
    );
    final cognitoUser = CognitoUser(email, userPool);

    bool registrationConfirmed = false;
    try {
      registrationConfirmed = await cognitoUser.confirmRegistration(confirmationCode);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      print(registrationConfirmed);
    } catch (e) {
      print(e);
    }
  /*  try {
      final SignUpResult response = await Amplify.Auth.confirmSignUp(
        username: _emailController.text,
        confirmationCode: confirmationCode,
      );
      if (response.isSignUpComplete) {
        setState(()=>cofirmcod=false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } on AuthException catch (e) {
      errordialog(context,e.message.toString());
    }*/
  }
}