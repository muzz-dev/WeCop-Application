import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class VehicleScreen extends StatefulWidget {
  @override
  VehicleScreenState createState() => VehicleScreenState();
}

class VehicleScreenState extends State<VehicleScreen> {
  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_VEHICLES);
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
          title: Text("Vehicle List"),
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
                                        "VehicleDetails",
                                        arguments: {
                                          "id": snapshot.data[position]["vid"]
                                              .toString()
                                        });
                                  },
                                  child: Card(
                                    elevation: 10.0,
                                    child: Column(
                                      children: [
                                        Image.network(Config.VEHICLES_PATH +
                                            snapshot.data[position]["vphoto1"]
                                                .toString(),width: 300,),
                                        Text(
                                          snapshot.data[position]["vnumber"]
                                              .toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          snapshot.data[position]
                                                  ["policestation_name"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey.shade700),
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
              }else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
