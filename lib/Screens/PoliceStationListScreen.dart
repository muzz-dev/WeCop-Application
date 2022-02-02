import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class PoliceStationListScreen extends StatefulWidget {
  @override
  PoliceStationListScreenState createState() => PoliceStationListScreenState();
}

class PoliceStationListScreenState extends State<PoliceStationListScreen> {
  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_POLICESTATION);
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
          title: Text("Police Stations"),
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
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      "PoliceStationDetails",
                                      arguments: {
                                        "id": snapshot.data[position]
                                                ["policestation_id"]
                                            .toString()
                                      });
                                },
                                child: Card(
                                  elevation: 10,
                                  child: Column(
                                    children: [
                                      Image.network(
                                          Config.POLICESTATION_PATH +
                                              snapshot.data[position]
                                                      ["photo_url"]
                                                  .toString(),
                                          width: 300),
                                      Text(
                                        snapshot.data[position]
                                                ["policestation_name"]
                                            .toString(),
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      Text(
                                        snapshot.data[position]["addressline1"]
                                            .toString(),
                                        style: TextStyle(fontSize: 18.0),
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
