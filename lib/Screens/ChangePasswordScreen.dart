import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formkey = GlobalKey<FormState>();
  String id = "";
  var _sfusertype;
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmpassword = new TextEditingController();

  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _sfusertype = prefs.getString("usertype");
      print(_sfusertype);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final Map arg = ModalRoute.of(context).settings.arguments as Map;

    if (arg != null) {
      setState(() {
        id = arg["userid"];
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image.asset(
                  "images/changepassword.png",
                  height: size.height * 0.35,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "New Password",
                      hintText: "Enter New Password"),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please Enter Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _confirmpassword,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      labelText: "Confirm Password",
                      hintText: "Re-Enter Password"),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Please Re-Enter Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                (_sfusertype=="user")?RoundedButton(
                  color: kPrimaryColor,
                  text: "Reset Password",
                  press: () async {
                    if(formkey.currentState.validate()){
                      var url = Uri.parse(Config.CHANGEPASSWORD_API);
                      var response = await http.post(url, body: {
                        "userid": id,
                        "password": _confirmpassword.text.toString()
                      });
                      if (response.statusCode == 200) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setBool("islogin", false);
                        prefs.setString("userid", "");
                        prefs.setString("username", "");
                        var json = jsonDecode(response.body);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Successfully Password Changed, Now Login To Continue !",

                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("Login");
                            });
                      } else {
                        print("API Error");
                      }
                    }
                  },
                ):RoundedButton(
                  color: kPrimaryColor,
                  text: "Reset Password",
                  press: () async {
                    if(formkey.currentState.validate()){
                      var url = Uri.parse(Config.CHANGEPASSWORD_POLICE_API);
                      var response = await http.post(url, body: {
                        "userid": id,
                        "password": _confirmpassword.text.toString()
                      });
                      if (response.statusCode == 200) {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        prefs.setBool("islogin", false);
                        prefs.setString("userid", "");
                        prefs.setString("username", "");
                        var json = jsonDecode(response.body);
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Successfully Password Changed, Now Login To Continue !",

                            onConfirmBtnTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("Login");
                            });
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
