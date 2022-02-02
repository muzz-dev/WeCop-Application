import 'dart:convert';
import 'dart:io';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/rounded_button.dart';
import 'package:flutter_app/constants.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class PreserveHome extends StatefulWidget {
  @override
  PreserveHomeState createState() => PreserveHomeState();
}

class PreserveHomeState extends State<PreserveHome> {
  File _image;
  final picker = ImagePicker();
  final formkey = GlobalKey<FormState>();

  TextEditingController _startdate = new TextEditingController();
  TextEditingController _enddate = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _landmark = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();
  TextEditingController _remarks = new TextEditingController();
  TextEditingController _latitude = new TextEditingController();
  TextEditingController _longtitude = new TextEditingController();

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

  LocationResult _pickedLocation;
  double lat, log;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preserve Home"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextField(
                  controller: _remarks,
                  maxLines: 6,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    hintText: "Remarks",
                    labelText: "Remarks",
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 3,
                      child: TextField(
                        readOnly: true,
                        controller: _startdate,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: "Start Date",
                            hintText: "YYYY-MM-DD"),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      width: 2.0,
                    )),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 3,
                      child: TextField(
                        readOnly: true,
                        controller: _enddate,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: "End Date",
                            hintText: "YYYY-MM-DD"),
                      ),
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: FlatButton(
                          child: Icon(
                            Icons.calendar_today_rounded,
                            size: 30,
                          ),
                          onPressed: () async {
                            final List<DateTime> picked =
                                await DateRangePicker.showDatePicker(
                                    context: context,
                                    initialFirstDate: new DateTime.now(),
                                    initialLastDate: (new DateTime.now())
                                        .add(new Duration(days: 7)),
                                    firstDate: new DateTime(2015),
                                    lastDate:
                                        new DateTime(DateTime.now().year + 2));
                            if (picked != null && picked.length == 2) {
                              print(picked.last);
                              setState(() {
                                _startdate.text = picked.first.year.toString() +
                                    "-" +
                                    picked.first.month.toString() +
                                    "-" +
                                    picked.first.day.toString();
                                _enddate.text = picked.last.year.toString() +
                                    "-" +
                                    picked.last.month.toString() +
                                    "-" +
                                    picked.last.day.toString();
                              });
                            }
                          },
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _address,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: "Address",
                      hintText: "Enter Your Address"),
                ),
                SizedBox(
                  height: 20.0,
                ),
                RoundedButton(
                  text: "Upload Image",
                  color: kPrimaryLightColor,
                  textColor: kPrimaryColor,
                  press: () {
                    _getImagefromgallery();
                  },
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
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 3,
                      child: TextField(
                        readOnly: true,
                        controller: _latitude,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: "Latitude",
                            hintText: "Latitude"),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      width: 2.0,
                    )),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 3,
                      child: TextField(
                        readOnly: true,
                        controller: _longtitude,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: "Longtitude",
                            hintText: "Longtitude"),
                      ),
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: FlatButton(
                            child: Icon(
                              Icons.location_pin,
                              size: 30,
                            ),
                            onPressed: () async {
                              LocationResult result = await showLocationPicker(
                                context,
                                "AIzaSyANmqipynqosCyCCMq6fP8XkH2TCwyZtSE",
                                initialCenter: LatLng(21.1702, 72.8311),
                                requiredGPS: true,
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                                myLocationButtonEnabled: true,
                                // requiredGPS: true,
                                layersButtonEnabled: true,
                                countries: ['IN'],

//                      resultCardAlignment: Alignment.bottomCenter,
                                desiredAccuracy: LocationAccuracy.high,
                              );

                              print("result = $result");
                              setState(() {
                                _latitude.text =
                                    result.latLng.latitude.toString();
                                _longtitude.text =
                                    result.latLng.longitude.toString();
                              });
                              setState(() => _pickedLocation = result);
                              // print(result.latLng.latitude);
                            }))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 3,
                      child: TextField(
                        controller: _landmark,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: "Landmark",
                            hintText: "Landmark"),
                      ),
                    ),
                    Flexible(
                        child: SizedBox(
                      width: 1.0,
                    )),
                    Flexible(
                        fit: FlexFit.loose,
                        flex: 3,
                        child: TextField(
                          controller: _pincode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              labelText: "Pincode",
                              hintText: "Pincode"),
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                RoundedButton(
                  color: kPrimaryColor,
                  text: "Add Home",
                  press: () async {
                    List<int> imageBytes = _image.readAsBytesSync();
                    String imageB64 = base64Encode(imageBytes);
                    String filename = _image.path.split('/').last;
                    print(imageB64);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var id = prefs.getString("userid").toString();
                    var url = Uri.parse(Config.ADD_HOME);
                    var response = await http.post(url, body: {
                      "userid": id.toString(),
                      "remark": _remarks.text.toString(),
                      "startdate": _startdate.text.toString(),
                      "enddate": _enddate.text.toString(),
                      "lat": _latitude.text.toString(),
                      "long": _longtitude.text.toString(),
                      "address": _address.text.toString(),
                      "landmark": _landmark.text.toString(),
                      "pincode": _pincode.text.toString(),
                      "image": imageB64,
                    });
                    if (response.statusCode == 200) {
                      print(response.body);
                      var json = jsonDecode(response.body);
                      if (json["status"] == "yes") {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: "Your home added successfully!",
                            onConfirmBtnTap: () {
                              Navigator.of(context).pushNamed("Home");
                            });
                      } else if (json["status"] == "no") {
                        print("no");
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
