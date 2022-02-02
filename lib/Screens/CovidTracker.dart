import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CovidTracker extends StatefulWidget{
  @override
  CovidTrackerState createState()=> CovidTrackerState();
}

class CovidTrackerState extends State<CovidTracker>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: SafeArea(
       child: WebView(
         initialUrl: "https://news.google.com/covid19/map?hl=en-US&gl=US&ceid=US%3Aen",
         javascriptMode: JavascriptMode.unrestricted,
       ),
     ),
   );
  }

}