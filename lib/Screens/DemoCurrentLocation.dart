import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocation extends StatefulWidget {
  CurrentLocationState createState() => CurrentLocationState();
}

class CurrentLocationState extends State<CurrentLocation> {
  var locationMessage = "";

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var log = position.longitude;
    print("$lat, $log");

    setState(() {
      locationMessage = "Latitude : $lat, Longtitude : $log";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 46.0,
                color: Colors.blue,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Get user location",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(locationMessage),
              FlatButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  color: Colors.blue,
                  child: Text(
                    "Get Current Location",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
