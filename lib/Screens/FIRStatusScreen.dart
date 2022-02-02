import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FIRStatusScreen extends StatefulWidget {
  @override
  FIRStatusScreenState createState() => FIRStatusScreenState();
}

class FIRStatusScreenState extends State<FIRStatusScreen> {
  Future<List> data;

  Future<List> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("userid").toString();
    var url = Uri.parse(Config.GET_FIRLIST);
    var responce = await http.post(url,body:{"userid":id});
    if (responce.statusCode == 200) {
      var res = jsonDecode(responce.body.toString().trim());
      return res;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your FIR(s) List"),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length <= 0) {
              return Center(
                child: Text("No Data Found !!!"),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, position) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 130,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("FIRLogs",arguments: {
                                  "fir_id": snapshot.data[position]["fir_id"].toString()
                                });
                              },
                              child: Card(
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                                elevation: 10.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data[position]["title"].toString(), style: TextStyle(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,),
                                      SizedBox(height: 10.0,),
                                      Text("FIR Registation Date : "+snapshot.data[position]["firdate"].toString(),
                                          style: TextStyle(fontSize: 18.0,)),
                                      Text("Last Updated On : "+snapshot.data[position]["firdate"].toString(),
                                          style: TextStyle(fontSize: 18.0)),
                                      Text("Police Station : "+snapshot.data[position]["policestation_name"].toString(),
                                          style: TextStyle(fontSize: 18.0)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
