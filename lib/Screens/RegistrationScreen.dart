import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Registration"),
      //   backgroundColor: Colors.blue.shade900,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 15.0),
              child: new Form(
                key: formkey,
                child: Column(
                  children: [
                    Text(
                      "WECOP-TO PROTECT AND TO SERVE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SvgPicture.asset(
                      "images/signup.svg",
                      height: size.height * 0.35,
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFormField(
                      controller: _name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Name",
                          hintText: "Enter Your Name"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _contact,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Contact",
                          hintText: "Enter Your Contact"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Contact";
                        } else if (val.length != 10) {
                          return "Mobile number Invalid";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Email",
                          hintText: "Enter Your Email"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _password,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Password",
                          hintText: "Enter Your Password"),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RoundedButton(
                        color: kPrimaryColor,
                        text: "Sign Up",
                        press: () async {
                          if (formkey.currentState.validate()) {
                            var url = Uri.parse(Config.REGISTER_API);
                            var response = await http.post(url, body: {
                              "name": _name.text.toString(),
                              "contact": _contact.text.toString(),
                              "email": _email.text.toString(),
                              "password": _password.text.toString(),
                            });

                            if (response.statusCode == 200) {
                              print(response.body);
                              var json = jsonDecode(response.body);
                              if (json["status"] == "yes") {
                                var id = json["userid"];
                                var otp = json["otp"];

                                Navigator.of(context).pushNamed("RegistrationOTP",
                                    arguments: {"userid": id, "mobileotp": otp});
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: "This number is already registered.",
                                    confirmBtnText: 'Ok',
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed("Login");
                                    });
                              }
                            } else {
                              print("Error in API call");
                            }
                          }
                        }),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Already have an Account ? ",
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("Login");
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
