import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class VehicleDetailsScreen extends StatefulWidget {
  @override
  VehicleDetailsScreenState createState() => VehicleDetailsScreenState();
}

class VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  String vid, vnumber, policestationname, contactnumber, addeddate, vimage;
  bool loading = true;

  _getdata(id) async {
    var url = Uri.parse(Config.GET_VEHICLESDETAILS);
    var response =
    await http.post(url, body: {"id":id});
    // await http.post(Config.GET_VEHICLESDETAILS, body: {"id": id});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      setState(() {
        vid = data[0]["vid"].toString();
        vnumber = data[0]["vnumber"].toString();
        policestationname = data[0]["policestation_name"].toString();
        contactnumber = data[0]["contactnumber"].toString();
        addeddate = data[0]["added_datetime"].toString();
        vimage = data[0]["vphoto1"].toString();
        loading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) {
      setState(() {
        vid = arguments["id"];
        _getdata(vid);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vnumber),
      ),
      body:(loading)?Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 10.0,
                    child: Column(
                      children: [
                        Image.network(
                          Config.VEHICLES_PATH + vimage,
                          width: 300,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          vnumber,
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(policestationname,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Police Station",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(contactnumber,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Contact Number",
                                style: TextStyle(fontSize: 12.0)),
                            trailing: Icon(
                              Icons.call,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(addeddate,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Added Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                              onTap: (){
                                Share.share(vnumber+' vehicle found at '+policestationname+" kindly contact "+contactnumber, subject: 'Vehicle Found!');
                              },
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.ios_share),
                                    tooltip: 'Share',
                                  ),

                                ],

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
