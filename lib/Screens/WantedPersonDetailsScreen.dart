import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class WantedPersonDetailsScreen extends StatefulWidget
{
  @override
  WantedPersonDetailsScreenState createState()=>WantedPersonDetailsScreenState();

}

class WantedPersonDetailsScreenState extends State<WantedPersonDetailsScreen>
{

  String wid,wname,wphoto,isactive,about,addeddatetime;

  _getdata(id) async
  {
    var url = Uri.parse(Config.GET_WANTEDDETAILS);
    var response = await http.post(url,body: {"id":id});
    if(response.statusCode==200)
      {
        var data= jsonDecode(response.body);
        print(data);
        setState(() {
          wid=data[0]["wid"].toString();
          wname=data[0]["wname"].toString();
          wphoto=data[0]["wphoto"].toString();
          isactive=data[0]["isactive"].toString();
          about=data[0]["about"].toString();
          addeddatetime=data[0]["added_datetime"].toString();
        });
      }
  }
  

  @override
  Widget build(BuildContext context) {

    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    if(arguments!=null)
    {
      setState(() {
        wid=arguments["id"];
        _getdata(wid);
      });
    }
    
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text(wname),
      ),
      body: SingleChildScrollView(
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
                            Image.network(Config.WANTED_PATH+wphoto,width: 300,),
                            SizedBox(height: 8.0,),
                            Text(wname,style: TextStyle(fontSize: 18.0),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(about,style: TextStyle(fontSize: 17.0)),
                            subtitle: Text("About",style: TextStyle(fontSize: 12.0,)),
                          ),
                          Divider(height: 1),
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