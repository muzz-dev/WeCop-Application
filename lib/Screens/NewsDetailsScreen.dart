import 'package:flutter/material.dart';

class NewsDetailsScreen extends StatefulWidget
{
  @override
  NewsDetailsScreenState createState()=>NewsDetailsScreenState();
}

class NewsDetailsScreenState extends State<NewsDetailsScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Narendra Modi Stadium"),
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
                            Image.asset("images/news1.jpg",width: 300,),
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("Picture By : Ronak Sharma",style: TextStyle(color: Colors.grey.shade500),textAlign: TextAlign.right,),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Motera Stadium is rename to Shree Narendra Modi Stadium",style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("News",style: TextStyle(fontSize: 12.0)),
                          ),
                          Divider(height: 1),
                          ListTile(
                            title: Text("Ronak Sharma",style: TextStyle(fontSize: 18.0)),
                            subtitle: Text("Publisher Name",style: TextStyle(fontSize: 12.0)),
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