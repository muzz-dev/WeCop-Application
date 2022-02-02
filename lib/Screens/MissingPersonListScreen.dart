import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:http/http.dart' as http;

class MissingPersonListScreen extends StatefulWidget {
  @override
  MissingPersonListScreenState createState() => MissingPersonListScreenState();
}

class MissingPersonListScreenState extends State<MissingPersonListScreen> {
  Future<List> data;

  Future<List> _getData() async {
    var url = Uri.parse(Config.GET_MISSINGPERSON);
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
          title: Text("Missing Person List"),
          
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search,color: Colors.white,),
          //     onPressed: (){
          //
          //     },
          //   )
          // ],
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
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("MissingPersonDetails", arguments: {
                            "id": snapshot.data[position]["pid"].toString()
                          });
                        },
                        child: Card(
                          elevation: 8.0,
                          child: Container(
                              child: Column(
                            children: [
                              Image.network(Config.MISSINGPERSON_PATH +
                                  snapshot.data[position]["mphoto"]
                                      .toString(),height:170,width:350,fit: BoxFit.contain,),
                              Text(
                                snapshot.data[position]["mname"]
                                    .toString(),
                                style: TextStyle(fontSize: 18.0),
                              ),
                              Text(
                                snapshot.data[position]["age"]
                                    .toString(),
                              ),
                            ],
                          )),
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
