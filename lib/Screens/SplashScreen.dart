import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var t = "";
  _checkSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("islogin")) {
      if (prefs.getBool("islogin") == true) {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("Home");
      }
      else
      {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed("Login");
      }
    }
    else
    {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed("Login");
    }
  }
  void notification() {
    _firebaseMessaging.configure(
      
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if(message["data"]["page"]=="contact") {
          print(message["data"]["pageid"]);
          Navigator.of(context).pushNamed("MissingPersonList");
          }
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
  _storePref(token) async {
    SharedPreferences p = await SharedPreferences.getInstance();
    p.setString("token", token);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notification();
    Future.delayed(const Duration(milliseconds: 3000), () {
      _checkSharedPref();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("images/wecopbg.png"),
      ),
    );
  }

}