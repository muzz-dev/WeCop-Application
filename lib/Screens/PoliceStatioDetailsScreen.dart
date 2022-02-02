import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class PoliceStatioDetailsScreen extends StatefulWidget
{
  @override
  PoliceStatioDetailsScreenState createState()=>PoliceStatioDetailsScreenState();
}

class PoliceStatioDetailsScreenState extends State<PoliceStatioDetailsScreen>
{
  String pid;
  String pname="";
  String address="";
  String landmark="";
  String phone="";
  String isactive="";
  String policename="";
  String contact="";
  String emailid="";
  String pimage="";
  bool loading=true;

  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _getdata(id) async
  {
    var url = Uri.parse(Config.GET_POLICESTATION_DETAILS);
    var response= await http.post(url,body: {"pid":id});
    if(response.statusCode==200)
      {
        var data = jsonDecode(response.body);
        print(data);
        setState(() {
          pname=data[0]["policestation_name"].toString();
          address=data[0]["addressline1"].toString();
          landmark=data[0]["landmark"].toString();
          phone=data[0]["contactnumber"].toString();
          isactive=data[0]["isactive"].toString();
          policename=data[0]["policename"].toString();
          contact=data[0]["contact"].toString();
          emailid=data[0]["emailid"].toString();
          pimage=data[0]["photo_url"].toString();
          loading=false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if(arguments!=null)
      {
        setState(() {
          pid=arguments["id"];
          _getdata(pid);
        });
      }


    return Scaffold(
      appBar: AppBar(
        title: Text(pname),
      ),
      body: (loading)?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10.0,
                      child: Padding
                        (padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Image.network(Config.POLICESTATION_PATH+pimage,width: 300,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Expanded(
                    child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(address,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Address",style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(landmark,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Landmark",style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            onTap: (){
                              setState(() {
                                _launched = _makePhoneCall('tel:$phone');
                              });
                              print(phone);
                            },
                            title: Text(phone,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Phone",style: TextStyle(fontSize: 12.0)),
                            trailing: Icon(Icons.call,color: Colors.blue,size: 30,),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(isactive,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Is Active",style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(policename,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Head Of Police Station",style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            onTap: (){
                              setState(() {
                                _launched = _makePhoneCall('tel:$contact');
                              });
                              print(contact);
                            },
                            title: Text(contact,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Contact",style: TextStyle(fontSize: 12.0)),
                            trailing: Icon(Icons.call,color: Colors.blue,size: 30,),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text(emailid,style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Email",style: TextStyle(fontSize: 12.0)),
                            trailing: Icon(Icons.mail,size: 30,),
                          ),
                          Divider(height: 1),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                              onTap: (){
                                Share.share(pname+' :  '+phone+" Inspector : "+ policename + " : " + contact, subject: 'Police Station Contact(s)');
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
                  ),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}