import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImagePickerDemo extends StatefulWidget {
  @override
  ImagePickerDemoState createState() => ImagePickerDemoState();
}

class ImagePickerDemoState extends State<ImagePickerDemo> {
  File _image;
  final picker = ImagePicker();

  Future _getImagefromcamera() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  Future _getImagefromgallery() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker Demo"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Image Picker Demo",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Center(
                  child: _image == null
                      ? Text("No Image Selected")
                      : Image.file(_image),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _getImagefromcamera,
                  tooltip: "Pick Image from Camera",
                  child: Icon(Icons.camera),
                ),
                FloatingActionButton(
                  onPressed: _getImagefromgallery,
                  tooltip: "Pick Image from Gallery",
                  child: Icon(Icons.folder),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () async {
                  print("clicked");
                  List<int> imageBytes = _image.readAsBytesSync();
                  String imageB64 = base64Encode(imageBytes);
                  String filename = _image.path.split('/').last;
                  print(filename);
                  print(imageB64);
                  var url = Uri.parse(Config.IMAGE_DEMO);
                  var response = await http.post(url, body: {
                    "data": imageB64,
                    "filename" : filename
                  });

                  if (response.statusCode == 200) {
                    var json = jsonDecode(response.body);
                    print(json["status"]);
                  }
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Upload",
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 2, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }
}
