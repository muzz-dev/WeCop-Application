import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CovidRegistration extends StatefulWidget{
  @override
  CovidRegistrationState createState()=> CovidRegistrationState();
}

class CovidRegistrationState extends State<CovidRegistration>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SafeArea(
       child: WebView(
         initialUrl: "https://selfregistration.cowin.gov.in/",
         javascriptMode: JavascriptMode.unrestricted,
       ),
     ),
   );
  }
}