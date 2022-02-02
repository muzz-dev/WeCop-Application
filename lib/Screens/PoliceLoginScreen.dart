import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PoliceLoginScreen extends StatefulWidget {
  @override
  PoliceLoginScreenState createState() => PoliceLoginScreenState();
}

class PoliceLoginScreenState extends State<PoliceLoginScreen> {
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final formkey = GlobalKey<FormState>();
  var t = "";

  // _checkSharedPref() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   if (prefs.containsKey("islogin")) {
  //     if (prefs.getBool("islogin") == true) {
  //       Navigator.of(context).pop();
  //       Navigator.of(context).pushNamed("Home");
  //     }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  _checkSharedPref();
    notification();
  }

  _storePref(token) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("token", token);
  }

  void notification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        t = token;
        _storePref(token);
        print("Push Messaging token: $token");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: new Form(
                  key: formkey,
                  child: Column(
                    children: [
                      Text(
                        "WECOP - To Protect & To Serve",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),
                      ),
                      SizedBox(height: 10.0,),
                      Image.asset(
                        "images/policelogin.png",
                        height: size.height * 0.30,
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _contact,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Phone Number",
                          hintText: "Enter Phone Number",
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please Enter Name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _password,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Password",
                          hintText: "Enter Password",
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Please Enter Name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).pushNamed("ForgotPassword");
                      //   },
                      //   child: Align(
                      //     alignment: Alignment.topRight,
                      //     child: Text(
                      //       "Forgot Password ?",
                      //       style: TextStyle(
                      //         decoration: TextDecoration.underline,
                      //         color: Colors.red,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: size.height * 0.01),
                      RoundedButton(
                        text: "Login",
                        color: kPrimaryColor,
                        press: ()async {
                          var url = Uri.parse(Config.POLICE_LOGIN_API);
                          var response = await http.post(url, body: {
                            "contact": _contact.text.toString(),
                            "password": _password.text.toString(),
                            "token": t
                          });

                          if (response.statusCode == 200) {
                            var json = jsonDecode(response.body);
                            if (json["status"] == "yes") {
                              var id = json["id"];
                              var _sfcontact = json["contact"];
                              var _sfemail = json["email"];
                              var _sfname = json["name"];
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.setBool("islogin", true);
                              prefs.setString("usertype", "police");
                              prefs.setString("userid", id);
                              prefs.setString("_sfcontact", _sfcontact);
                              prefs.setString("_sfemail", _sfemail);
                              prefs.setString("_sfname", _sfname);


                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("Home");
                            } else if (json["status"] == "notverify") {
                              print("not verify");
                              var id = json["id"];
                              var otp = json["otp"];
                              print(otp);
                              Navigator.of(context).pushNamed("RegistrationOTP",
                                  arguments: {"userid": id, "mobileotp": otp});
                            }else{
                              Fluttertoast.showToast(
                                  msg: "Invalid Username and Password !!!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          }else{
                            Fluttertoast.showToast(
                                msg: "Error in API",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Login as an User ? ",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("Login");
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                          prefs.setBool("islogin", false);
                          prefs.setString("usertype","visitor");
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("Home");
                        },
                        child: Text(
                          "SKIP NOW",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
