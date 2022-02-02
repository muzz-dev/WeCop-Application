import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class FIRDetailsScreen extends StatefulWidget {
  @override
  FIRDetailsScreenState createState() => FIRDetailsScreenState();
}

class FIRDetailsScreenState extends State<FIRDetailsScreen> {
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String pid,
      cname,
      contact,
      email,
      title,
      description,
      scrimedate,
      scrimetime,
      ecrimedate,
      ecrimetime,
      fir_type,
      firdate,
      firtime,
      address,
      landmark,
      pincode,
      status;
  bool loading=true;

  _getdata(id) async {
    print(id);
    var url = Uri.parse(Config.ALLOCATED_FIR_DETAILS);
    var response = await http.post(url,body: {"pid": id});
    if (response.statusCode == 200) {
      print(response);
      var data = jsonDecode(response.body);
      setState(() {
        cname = data[0]["cname"].toString();
        contact = data[0]["contact"].toString();
        email = data[0]["email"].toString();
        title = data[0]["title"].toString();
        description = data[0]["description"].toString();
        scrimedate = data[0]["scrimedate"].toString();
        scrimetime = data[0]["scrimetime"].toString();
        ecrimedate = data[0]["ecrimedate"].toString();
        ecrimetime = data[0]["ecrimetime"].toString();
        fir_type = data[0]["fir_type"].toString();
        firdate = data[0]["firdate"].toString();
        firtime = data[0]["firtime"].toString();
        address = data[0]["address"].toString();
        landmark = data[0]["landmark"].toString();
        pincode = data[0]["pincode"].toString();
        status = data[0]["status"].toString();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if(arguments!=null)
    {
      setState(() {
        pid=arguments["fir_id"];
        _getdata(pid);
        loading=false;
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Details of FIR"),
      ),
      body: (loading)?CircularProgressIndicator():SingleChildScrollView(
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
                            title: Text(title,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Missing Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(description,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Description",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(scrimedate,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Start Crime Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(scrimetime,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Start Crime Time",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(ecrimedate,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("End Crime Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(ecrimetime,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("End Crime Time",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(firdate,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("FIR Registration Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(firtime,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("FIR Registration Time",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(address+", "+landmark,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Address",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(cname, style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Complainer Name",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            onTap: (){
                              setState(() {
                                _launched = _makePhoneCall('tel:$contact');
                              });
                              print(contact);
                            },
                            title: Text(contact,
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Complainer Mobile Number",
                                style: TextStyle(fontSize: 12.0)),
                            trailing:
                            Icon(Icons.call, color: Colors.blue, size: 30),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(email, style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Email",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text("19-05-2021",
                                style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Missing Date",
                                style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text("XYZ", style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("More Details",
                                style: TextStyle(fontSize: 12.0)),
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
