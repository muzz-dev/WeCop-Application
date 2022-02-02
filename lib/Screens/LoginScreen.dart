import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
    // _checkSharedPref();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    Text(
                      "WECOP - To Protect & To Serve",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0,),
                    SvgPicture.asset(
                      "images/login.svg",
                      height: size.height * 0.30,
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      controller: _contact,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: "Mobile Number",
                        hintText: "Enter Your Mobile Number",
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Username";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        labelText: "Password",
                        hintText: "Enter Your Password",
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("ForgotPassword");
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    RoundedButton(
                        color: kPrimaryColor,
                        text: "Login",
                        press: () async {
                          if (formkey.currentState.validate()) {
                            var url = Uri.parse(Config.LOGIN_API);
                            var response = await http.post(url, body: {
                              "contact": _contact.text.toString(),
                              "password": _password.text.toString(),
                              "token": t
                            });

                            if (response.statusCode == 200) {
                              var json = jsonDecode(response.body);
                              if (json["status"] == "yes") {
                                var id = json["id"];
                                var name = json["name"];
                                var contact = json["contact"];
                                var email = json["email"];

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool("islogin", true);
                                prefs.setString("usertype","user");
                                prefs.setString("userid", id);
                                prefs.setString("_sfname", name);
                                prefs.setString("_sfemail", email);
                                prefs.setString("_sfcontact", contact);

                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed("Home");
                              } else if (json["status"] == "notverify") {
                                var id = json["id"];
                                var otp = json["otp"];
                                print(otp);
                                Navigator.of(context)
                                    .pushNamed("RegistrationOTP", arguments: {
                                  "userid": id,
                                  "mobileotp": otp
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Invalid Username or Password !!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Error in API Call !!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }
                        }),
                    SizedBox(height: size.height * 0.03),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don’t have an Account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("Register");
                          },
                          child: Text(
                            "Sign Up",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login as a Police Officer ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed("PoliceLogin");
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
