import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordOTPScreen extends StatefulWidget {
  @override
  ForgotPasswordOTPScreenState createState() => ForgotPasswordOTPScreenState();
}

class ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
  final formkey = GlobalKey<FormState>();
  String otp = "", id = "";
  TextEditingController _otp = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map arg = ModalRoute.of(context).settings.arguments as Map;

    if (arg != null) {
      setState(() {
        id = arg["userid"];
        otp = arg["otp"];
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Authentication"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image.asset(
                  "images/otp.png",
                  height: size.height * 0.35,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _otp,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "OTP",
                      hintText: "Enter Your OTP Here"),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please Enter OTP Here";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  color: kPrimaryColor,
                  text: "Verify",
                  press: () async {
                    if (formkey.currentState.validate()) {
                      if (otp == _otp.text.toString()) {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Now you can change your password !",
                            confirmBtnText: "Change Password",
                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("ChangePassword",
                                  arguments: {"userid": id});
                            });
                      } else {
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          text: "The OTP entered is incorrect.",
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
