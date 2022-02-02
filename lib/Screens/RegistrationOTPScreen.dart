import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class RegistrationOTPScreen extends StatefulWidget {
  @override
  RegistrationOTPScreenState createState() => RegistrationOTPScreenState();
}

class RegistrationOTPScreenState extends State<RegistrationOTPScreen> {
  final formkey = GlobalKey<FormState>();
  String id = "", otp = "";
  TextEditingController _otp = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map arg = ModalRoute.of(context).settings.arguments as Map;

    if (arg != null) {
      setState(() {
        id = arg["userid"];
        otp = arg["mobileotp"];
        print(otp);
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
                        var url = Uri.parse(Config.UPDATE_REGISTER_STATUS);
                        var response = await http.post(url, body: {"id": id});
                        if (response.statusCode == 200) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: "Now you are verified user !",
                              confirmBtnText: "Login",
                              onConfirmBtnTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                // Navigator.of(context).pop();
                                Navigator.of(context).pushNamed("Login");
                              });

                        } else {
                          Fluttertoast.showToast(
                              msg: "Invalid OTP !!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error in API Calling !!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
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
