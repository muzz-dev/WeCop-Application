import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';

import 'package:http/http.dart' as http;

class NewsListScreen extends StatefulWidget
{
  @override
  NewsListScreenState createState()=>NewsListScreenState();

}

class NewsListScreenState extends State<NewsListScreen>
{

  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_NEWS);
    var responce = await http.post(url);
    if (responce.statusCode == 200) {
      var res = jsonDecode(responce.body.toString().trim());
      return res;
    }
  }

  @override
  void initState() {
    super.initState();
    data = _getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length <= 0) {
              return Center(
                child: Text("Data Not Found !!!"),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, position) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).pushNamed("PoliceStationDetails",arguments: {"id":snapshot.data[position]["newsid"].toString()});
                              },
                              child: Card(
                                elevation: 10,
                                child: Column(
                                  children: [
                                    Image.network(Config.POLICESTATION_PATH+snapshot.data[position]
                                    ["newsimage"]
                                        .toString(),width: 300),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data[position]
                                        ["title"]
                                            .toString(),
                                        style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
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