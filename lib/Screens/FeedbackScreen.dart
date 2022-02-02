import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {

  TextEditingController _name=TextEditingController();
  TextEditingController _email=TextEditingController();
  TextEditingController _feedback=TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("Feedback")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Image.asset(
                  "images/feedback.png",
                  height: size.height * 0.35,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: "Name",
                      hintText: "Please Enter Your Name"),
                  validator: (val){
                    if(val.isEmpty){
                      return "Please Enter Name";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: "Email",
                      hintText: "Please Enter Your Email"),
                  validator: (val){
                    if(val.isEmpty){
                      return "Please Enter Email";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _feedback,
                  maxLines: 5,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: "Feedback",
                      hintText: "Please Enter Your Feedback"),
                  validator: (val){
                    if(val.isEmpty){
                      return "Please Enter Feedback";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  color: kPrimaryColor,
                  text: "Send Feedback",
                  press: ()async{
                    if(formkey.currentState.validate()){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("userid").toString();

                      var url = Uri.parse(Config.ADD_FEEDBACK);
                      var response = await http.post(url,body: {
                        "name": _name.text.toString(),
                        "email": _email.text.toString(),
                        "feedback": _feedback.text.toString(),
                        "userid" : id.toString(),
                      });
                      if(response.statusCode==200){
                        var json = jsonDecode(response.body);
                        if(json["status"]=="yes"){
                          print("yes");
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.success,
                              text: "Your feedback added successfully!",
                              onConfirmBtnTap: (){
                                Navigator.of(context).pushNamed("Home");
                              }
                          );
                        }
                        else if(json["status"]=="no"){
                          print("no");
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
