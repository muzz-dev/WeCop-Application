import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class EmergencyNumber extends StatefulWidget {
  @override
  EmergencyNumberState createState() => EmergencyNumberState();
}

class EmergencyNumberState extends State<EmergencyNumber> {
  Future<List> data;
  Future<void> _launched;
  String _phone = '';

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_NUMBERS);
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body.toString().trim());
      return res;
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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
          title: Text("Emergency Numbers"),
        ),
        body: FutureBuilder(
          future: data,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length <= 0) {
                return Center(
                  child: Text("No Data Found!"),
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
                              ListTile(
                                onTap: (){
                                  setState(() {
                                    _phone = snapshot.data[position]["em_number"]
                                        .toString();
                                    _launched = _makePhoneCall('tel:$_phone');
                                  });
                                  print(_phone);
                                },
                                title: Text(
                                    snapshot.data[position]["em_number"]
                                        .toString(),
                                    style: TextStyle(fontSize: 18.0)),
                                subtitle: Text(
                                    snapshot.data[position]["em_title"]
                                        .toString(),
                                    style: TextStyle(fontSize: 15.0)),
                                trailing: Icon(Icons.call,
                                    color: Colors.blue, size: 30),
                              ),
                              Divider()
                            ],
                          )),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
