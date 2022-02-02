import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formkey = GlobalKey<FormState>();
  TextEditingController _contact = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Authentication"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image.asset(
                  "images/forgotpassword.png",
                  height: size.height * 0.35,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _contact,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "Contact Number",
                      hintText: "Enter Your Contact Number"),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please Enter Contact Number";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  color: kPrimaryColor,
                  text: "Send OTP",
                  press: () async {
                    if (formkey.currentState.validate()) {
                      var url = Uri.parse(Config.FORGOTPASSWORD_API);
                      var response = await http.post(url, body: {
                        "contact": _contact.text.toString(),
                      });
                      if (response.statusCode == 200) {
                        var json = jsonDecode(response.body);
                        if (json["status"] == "yes") {
                          var id = json["userid"];
                          var otp = json["otp"];
                          var fetchmail = json["email"];
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: "Mail Successfully send on " + fetchmail,
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamed(
                                    "ForgotPasswordOTP",
                                    arguments: {"userid": id, "otp": otp});
                              });
                          print(otp);
                        } else {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              text: "Invalid Contact Number",
                              confirmBtnText:"Try Again"
                              );
                        }
                      } else {
                        print("API Error");
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
