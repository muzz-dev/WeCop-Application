import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AllocatedHomeDetails extends StatefulWidget {
  @override
  AllocatedHomeDetailsState createState() => AllocatedHomeDetailsState();
}

class AllocatedHomeDetailsState extends State<AllocatedHomeDetails> {
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String pid,
  name,contact,
      remark,
      start_date,
      end_date,
      isapprove,
      homeaddressline1,
      homeaddressline2,
      homelandmark,
      homepincode;
  bool loading = true;

  _getdata(id) async {
    print(id);
    var url = Uri.parse(Config.ALLOCATED_HOME_DETAILS);
    var response = await http.post(url, body: {"home_id": id});
    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      setState(() {
        remark=data[0]["remark"].toString();
        start_date=data[0]["start_date"].toString();
        end_date=data[0]["end_date"].toString();
        homeaddressline1=data[0]["homeaddressline1"].toString();
        homeaddressline2=data[0]["homeaddressline2"].toString();
        homelandmark=data[0]["homelandmark"].toString();
        homepincode=data[0]["homepincode"].toString();
        name =data[0]["uname"].toString();
        contact =data[0]["contact"].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      setState(() {
        pid = arguments["home_id"];
        _getdata(pid);
        loading = false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of Home"),
      ),
      body: (loading)
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title:
                                  Text(remark, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Remark",
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                            Divider(height: 1),
                            ListTile(
                              title:
                              Text(start_date, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Start Date",
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                            Divider(height: 1),
                            ListTile(
                              title:
                              Text(end_date, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("End Date",
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                            Divider(height: 1),
                            ListTile(
                              title:
                              Text(homeaddressline1, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("Home Address",
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                            Divider(height: 1),
                            ListTile(
                              title:
                              Text(name, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("User's Name",
                                  style: TextStyle(fontSize: 12.0)),
                            ),
                            Divider(height: 1),
                            ListTile(
                              title:
                              Text(contact, style: TextStyle(fontSize: 18.0)),
                              subtitle: Text("User's Contact",
                                  style: TextStyle(fontSize: 12.0)),
                              trailing:
                              Icon(Icons.call, color: Colors.blue, size: 30),
                              onTap: (){
                                setState(() {
                                  _launched = _makePhoneCall('tel:$contact');
                                });
                                print(contact);
                              },
                            ),
                            Divider(height: 1),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
    );
  }
}
