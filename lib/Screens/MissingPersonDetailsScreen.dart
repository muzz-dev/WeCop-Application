import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MissingPersonDetailsScreen extends StatefulWidget
{
  @override
  MissingPersonDetailsScreenState createState()=> MissingPersonDetailsScreenState();

}

class MissingPersonDetailsScreenState extends State<MissingPersonDetailsScreen>
{

  String pid,age,gender,mname,cname,contact,lastaddress,missingdate,moredetails,mimage;
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
    var url = Uri.parse(Config.GET_MISSSINGPERSONDETAILS);
    var response = await http.post(url,body: {"pid":id});
    if(response.statusCode==200)
      {
        var data = jsonDecode(response.body);
        print(data);
        setState(() {
          pid=data[0]["pid"].toString();
          age=data[0]["age"].toString();
          gender=data[0]["gender"].toString();
          mname=data[0]["mname"].toString();
          cname=data[0]["contactname"].toString();
          contact=data[0]["contactmobilenumber"].toString();
          lastaddress=data[0]["lastaddress1"].toString();
          missingdate=data[0]["missingdate"].toString();
          moredetails=data[0]["moredetails"].toString();
          mimage=data[0]["mphoto"].toString();
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
        title: Text(mname),
      ),
      body: (loading)?Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 10.0,
                  child: Padding
                    (padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.network(Config.MISSINGPERSON_PATH+mimage,width: 300,),
                        Text(mname),
                        Text("Age:"+age+" | "+gender,style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
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
                                    title: Text(cname,style: TextStyle(fontSize: 18.0)),
                                    subtitle: Text("Contact Person",style: TextStyle(fontSize: 12.0)),
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
                                    subtitle: Text("Mobile Number",style: TextStyle(fontSize: 12.0)),
                                    trailing: Icon(Icons.call,color: Colors.blue,size: 30),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    title: Text(lastaddress,style: TextStyle(fontSize: 18.0)),
                                    subtitle: Text("Last Address",style: TextStyle(fontSize: 12.0)),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    title: Text(missingdate,style: TextStyle(fontSize: 18.0)),
                                    subtitle: Text("Missing Date",style: TextStyle(fontSize: 12.0)),
                                  ),
                                  Divider(height: 1),
                                  ListTile(
                                    title: Text(moredetails,style: TextStyle(fontSize: 18.0)),
                                    subtitle: Text("More Details",style: TextStyle(fontSize: 12.0)),
                                  ),
                                  Divider(height: 1),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: (){
                                        Share.share(mname+", A " + age+"-years old has been missing from "+ lastaddress +", Since " +missingdate+". Kindly contact "+contact, subject: 'Person Missing');
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
                          ))
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}