import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class FIRLogsScreen extends StatefulWidget {
  @override
  FIRLogsScreenState createState() => FIRLogsScreenState();
}

class FIRLogsScreenState extends State<FIRLogsScreen> {
  String id;
  bool loading = true;
  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_FIRLOG);
    var responce = await http.post(url, body: {"fir_id": id});
    if (responce.statusCode == 200) {
      var data = jsonDecode(responce.body.toString().trim());
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        id = arguments["fir_id"];
        print(id);
        data = _getData();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Logs of your FIR"),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.length <= 0){
              return Center(
                child: Text("No Data Found !!!"),
              );
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, position){
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 10,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: "Remarks : ",
                                                style: TextStyle(
                                                    wordSpacing: 2,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            TextSpan(
                                                text: snapshot.data[position]["remark"].toString(),
                                                style: TextStyle(
                                                    fontSize: 20.0, color: Colors.black)),
                                          ])),
                                      subtitle: Text(
                                        "Added Date : "+snapshot.data[position]["logdatetime"].toString(),
                                        style: TextStyle(
                                          wordSpacing: 2,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "Status : ",
                                              style: TextStyle(
                                                  wordSpacing: 2,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          TextSpan(
                                              text: snapshot.data[position]["status"].toString(),
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)),
                                        ])),
                                    Divider(),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
            }
          }else{
            return Center(
              child: SingleChildScrollView(),
            );
          }
        },
      ),
    );
  }
}


