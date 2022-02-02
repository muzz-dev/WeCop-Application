import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class WantedPersonScreen extends StatefulWidget {
  @override
  WantedPersonScreenState createState() => WantedPersonScreenState();
}

class WantedPersonScreenState extends State<WantedPersonScreen> {
  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_WANTEDPERSON);
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body.toString().trim());
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
          title: Text("Wanted Person List"),
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
                return GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      "WantedPersonDetails",
                                      arguments: {
                                        "id": snapshot.data[position]["wid"]
                                            .toString()
                                      });
                                },
                                child: Card(
                                  elevation: 8.0,
                                  child: Column(
                                    children: [
                                      Image.network(Config.WANTED_PATH +
                                          snapshot.data[position]["wphoto"]
                                              .toString(),height:170,width:350,fit: BoxFit.contain,),
                                      Text(
                                        snapshot.data[position]["wname"]
                                            .toString(),
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
