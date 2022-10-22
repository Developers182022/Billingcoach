import 'package:fluttertoast/fluttertoast.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HomePage.dart';
import 'login.dart';
class ConfirmResetScreen extends StatefulWidget {
  ConfirmResetScreen({ this.email, this.password});
  final email, password;

  @override
  _ConfirmResetScreenState createState() => _ConfirmResetScreenState(emailid:email, pass:password);
}

class _ConfirmResetScreenState extends State<ConfirmResetScreen> {
  _ConfirmResetScreenState({ this.emailid, this.pass});
  final emailid, pass;
  final _controller = TextEditingController();
  // final _emailcontroller = TxteEditingController();
  final _newPasswordController = TextEditingController();
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  bool _isEnabled = false;
  bool reqrest= false;
  bool _obscureText = true;
  String email="";
  @override
  void initState() {
    super.initState();
    getcurrentuser();
    setState((){
      email= emailid.toString();});
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
    _newPasswordController.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }
  getcurrentuser()async{
    final SharedPreferences prefs = await preferences;
    var counter = prefs.getString('user_Id');
    if(counter!=null){
      runApp(Home());
    }
    else{runApp(LoginScreen());}}
  void _resetPassword(BuildContext context,email , String code,
      String password) async {

    final userPool = CognitoUserPool(
      'ap-south-1_8euTR5YQA',
      '59jiqdmbtdabj6tqrd7ce4u796',
    );
    final cognitoUser = CognitoUser(email, userPool);
    try {
      var passwordConfirmed = await cognitoUser.confirmPassword(
          code, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black54,
          content: Text(
            'Password changed successfully. Please log in',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      );
      setState(()=>reqrest=false);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on CognitoClientException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
      _showError(context, '${e.message} ');
    }
  }
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          message,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
                    children: [
                      SizedBox(height:55,),
                      Image.asset('assets/logofront.png', height: 60,width: 60,),
                      SizedBox(height: 10,),
                      Text("The Billing Coach", style: TextStyle( fontSize: 28,color: Colors.blue),),
                      SizedBox(height: 25,),
                      TextField(
                      controller: TextEditingController(text: email),
                      onChanged: (value){
                        email= value;},
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 4.0),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                      ),
                    ),
                      SizedBox(height: 10),
                      Visibility(
                        child:  TextField(
                          controller: _newPasswordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'Enter new password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        ),
                        visible: reqrest,
                      ),
                      SizedBox(height: 10),
                      Visibility(
                        child:  TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: true,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                            prefixIcon: Icon(Icons.lock),
                            labelText: 'New password code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                            ),
                          ),
                        ),
                        visible: reqrest,
                      ),
                      SizedBox(height: 10),
                     TextButton(
                        onPressed:/* reqrest
                            ? () {
                          _onRecoverPassword(context, email);
                        }
                            :*/_isEnabled? () {
                          _resetPassword(
                            context,
                            email,
                            _controller.text,
                            _newPasswordController.text,
                          );
                        }:() {
                          _onRecoverPassword(context, email);
                        },
                       
                        child: Container(
                          height: 45,
                          width: double.maxFinite,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                          color: Colors.blue),
                          child: Center(child: Text(
                          'Reset',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),),),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
  Future _onRecoverPassword(BuildContext context, String email) async {
    try {
      final userPool = CognitoUserPool(
        'ap-south-1_8euTR5YQA',
        '59jiqdmbtdabj6tqrd7ce4u796',
      );
      final cognitoUser = CognitoUser(email, userPool);
      bool passwordChanged = false;
      try {
        var data = await cognitoUser.forgotPassword();
      } catch (e) {
        print(e);
      }
      /*final res = await Amplify.Auth.resetPassword(username: email);
      print("object------   "+res.nextStep.updateStep);
      if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
        setState((){_isEnabled=true;
        reqrest= true;});
         return res.nextStep.updateStep;
      }*/
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black54,
          content: Text(e.message.toString(),
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      );
      return '${e.message} - ${e.recoverySuggestion}';
    }
  }
}