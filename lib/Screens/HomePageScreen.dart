import 'dart:async';
import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_app/Screens/CovidTracker.dart';
import 'package:flutter_app/Screens/LoginScreen.dart';
import 'package:flutter_app/Utility/Config.dart';
import 'package:flutter_app/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/infowindow.dart';
import 'package:flutter_app/Screens/user.dart';
import 'package:flutter_app/Screens/widget/map_helper.dart';
import 'package:flutter_app/Screens/widget/map_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageScreen extends StatefulWidget {
  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> {
  var latitude, longtitude;
  var id, _sfname, _sfemail, _sfcontact, _sfusertype;
  String newsimage = "";
  List<Container> finaldata = new List<Container>();

  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Completer<GoogleMapController> _mapController = Completer();
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;
 checkpref() async
 {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   var type  = prefs.getString("usertype");
   (type=="police")?_gethomemarkers():_getmarkers();
 }
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    checkpref();
    getCurrentLocation();
    //checkFirstSeen();
  }

  GoogleMapController mapController;
  Set<Marker> _markers = Set<Marker>();

  final LatLng _center = LatLng(21.1702, 72.8311);
  final double _zoom = 15.0;

  final Map<String, User> _userList = {
    "spiderman": User('spiderman', 'spiderman', 'images/missingperson1.jpg',
        LatLng(21.2014, 72.8005), 4),
    "ironman": User('ironman', 'ironman', 'images/missingperson2.jpg',
        LatLng(21.2016, 72.8014), 4),
  };

  final double _infoWindowWidth = 250;
  final double _markerOffset = 170;
  var providerObject = null;
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  _gethomemarkers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid").toString();
      _sfname = prefs.getString("_sfname");
      _sfcontact = prefs.getString("_sfcontact");
      _sfemail = prefs.getString("_sfemail");
    });
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);
    var url = Uri.parse(Config.READ_HOME);
    var response = await http.post(url, body: {"pid": id});
    print(id);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body.toString().trim());
      for (int i = 0; i < res.length; i++) {
        print(res[i]);
        double lat = double.parse(res[i]["lat"]);
        double lon = double.parse(res[i]["long"]);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(res[i]["address"]),
            position: LatLng(lat, lon),
            onTap: () {
              providerObject.updateInfowindow(context, mapController,
                  LatLng(lat, lon), _infoWindowWidth, _markerOffset);;
              providerObject.updateVisibility(true);
              providerObject.rebuildInfowindow();
            },
          ));
        });
      }
    }
  }
  _getmarkers() async {
    final providerObject = Provider.of<InfoWindowModel>(context, listen: false);
    var url = Uri.parse(Config.READ_CRIME);
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body.toString().trim());
      for (int i = 0; i < res.length; i++) {
        //print(res[i]);
        double lat = double.parse(res[i]["lat"]);
        double lon = double.parse(res[i]["long"]);

        User value = new User(res[i]["catname"], res[i]["catname"],
            'images/missingperson2.jpg', LatLng(lat, lon), 4);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId(res[i]["catname"]),
            position: LatLng(lat, lon),
            onTap: () {
              providerObject.updateInfowindow(context, mapController,
                  LatLng(lat, lon), _infoWindowWidth, _markerOffset);
              providerObject.updateUser(value);
              providerObject.updateVisibility(true);
              providerObject.rebuildInfowindow();
            },
          ));
        });
      }
    }
  }
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString("userid").toString();
      _sfname = prefs.getString("_sfname");
      _sfcontact = prefs.getString("_sfcontact");
      _sfemail = prefs.getString("_sfemail");
      _sfusertype = prefs.getString("usertype");
    });
    var url = Uri.parse(Config.GET_NEWS);
    List<Container> templist = new List<Container>();
    var responce = await http.post(url);
    if (responce.statusCode == 200) {
      var res = jsonDecode(responce.body.toString().trim());

      for (var item in res) {
        templist.add(
          Container(
            width: MediaQuery.of(context).size.width,
            height: 700,
            child: Card(
              elevation: 10.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(Config.NEWS_PATH + item["newsimage"],
                      width: 300, height: 180, fit: BoxFit.fill),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      item["title"].toString(),
                      maxLines: 2,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    setState(() {
      finaldata = templist;
      print(finaldata);
    });
  }

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var log = position.longitude;
    print("$lat, $log");

    setState(() {
      latitude = lat;
      longtitude = log;
    });
  }

  @override
  Widget build(BuildContext context) {
    providerObject = Provider.of<InfoWindowModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: Text("We Cop"),
          actions: [
            InkWell(
              onTap: () async {
                getCurrentLocation();
                var url = Uri.parse(Config.WOMEN_SAFETY);
                var response = await http.post(url, body: {
                  "lat": latitude.toString(),
                  "long": longtitude.toString(),
                });
                if (response.statusCode == 200) {
                  var json = jsonDecode(response.body);
                  var no = json["contactnumber"];
                  setState(() {
                    _launched = _makePhoneCall('tel:$no');
                  });
                  print(no);
                }
              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10.0, 0),
                  child: Icon(Icons.call)),
            )
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: kPrimaryLightColor,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: ((id == "")
                      ? Text(
                          "Guest",
                          style: TextStyle(fontSize: 18.0),
                        )
                      : Text(_sfname)),
                  accountEmail:
                      (id == "" ? Text("Guest") : Text("+91 " + _sfcontact)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                ),
                Divider(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          (_sfusertype == "user" || _sfusertype == "visitor")
                              ? ListTile(
                                  leading: Icon(Icons.home_work),
                                  title: Text(
                                    "Go To Vacation ?",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  onTap: () {
                                    if (id == "") {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text:
                                              "You need to login to view this content. Please Login",
                                          confirmBtnText: 'Login',
                                          cancelBtnText: 'Cancel',
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushNamed("Login");
                                          });
                                    } else if (id != "") {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamed("PreserveHome");
                                    }
                                  },
                                )
                              : Visibility(
                                  child: Text(""),
                                  visible: false,
                                ),
                          (_sfusertype == "police")
                              ? ListTile(
                                  leading: Icon(Icons.menu_book),
                                  title: Text(
                                    "Allocated FIR",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("AllocatedFIR");
                                  },
                                )
                              : Visibility(
                                  child: Text(""),
                                  visible: false,
                                ),
                          (_sfusertype == "police")
                              ? ListTile(
                                  leading: Icon(Icons.home),
                                  title: Text(
                                    "Preserve Home",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("AllocatedHome");
                                  },
                                )
                              : Visibility(
                                  child: Text(""),
                                  visible: false,
                                ),
                          (_sfusertype == "user" || _sfusertype == "visitor")
                              ? ListTile(
                                  leading: Icon(Icons.menu_book),
                                  title: Text(
                                    "FIR Status",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  onTap: () {
                                    if (id == "") {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text:
                                              "You need to login to view this content. Please Login",
                                          confirmBtnText: 'Login',
                                          cancelBtnText: 'Cancel',
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushNamed("Login");
                                          });
                                    } else if (id != "") {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamed("FIRStatus");
                                    }
                                  },
                                )
                              : Visibility(
                                  child: Text(""),
                                  visible: false,
                                ),
                          ListTile(
                            leading: Icon(Icons.book),
                            title: Text(
                              "News",
                              style: TextStyle(fontSize: 17.0),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("NewsList");
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.coronavirus),
                            title: Text(
                              "Co-WIN Application",
                              style: TextStyle(fontSize: 17.0),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("CovidRegistration");
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.call),
                            title: Text(
                              "Emergency Number",
                              style: TextStyle(fontSize: 17.0),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("EmergencyNumber");
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                              "Police Stations",
                              style: TextStyle(fontSize: 17.0),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("PoliceStationList");
                            },
                          ),
                          (_sfusertype == "user")
                              ? ListTile(
                                  leading: Icon(Icons.chat),
                                  title: Text(
                                    "Feedback",
                                    style: TextStyle(fontSize: 17.0),
                                  ),
                                  onTap: () {
                                    if (id == "") {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text:
                                              "You need to login to view this content. Please Login",
                                          confirmBtnText: 'Login',
                                          cancelBtnText: 'Cancel',
                                          onConfirmBtnTap: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushNamed("Login");
                                          });
                                    } else if (id != "") {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushNamed("AddFeedback");
                                    }
                                  },
                                )
                              : Visibility(
                                  child: Text(""),
                                  visible: false,
                                ),
                          ExpansionTile(
                            leading: Icon(Icons.view_headline_rounded),
                            title: Text(
                              "Utility",
                              style: TextStyle(fontSize: 17.0),
                            ),
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person_search_rounded,
                                ),
                                title: Text(
                                  "Missing Person",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed("MissingPersonList");
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.directions_bike_outlined),
                                title: Text(
                                  "Vehicle",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed("Vehicle");
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.person_remove),
                                title: Text(
                                  "Wanted Person",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed("WantedPerson");
                                },
                              ),
                              // ListTile(
                              //   leading: Icon(Icons.brightness_1_rounded),
                              //   title: Text(
                              //     "Acts",
                              //     style: TextStyle(fontSize: 17.0),
                              //   ),
                              //   onTap: () {},
                              // ),
                            ],
                          ),
                          Divider(),
                          (id != "")
                              ? Container(
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.logout,
                                    ),
                                    title: Text(
                                      "Logout",
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool("islogin", false);
                                      prefs.setString("userid", "");
                                      prefs.setString("usertype", "");
                                      prefs.setString("_sfname", "");
                                      prefs.setString("_sfemail", "");
                                      prefs.setString("_sfcontact", "");

                                      Navigator.of(context)
                                          .popUntil((route) => route.isActive);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed("Login");
                                    },
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.login_outlined,
                                    ),
                                    title: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 17.0),
                                    ),
                                    onTap: () async {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed("Login");
                                    },
                                  ),
                                )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: kPrimaryColor,
          height: 50,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(Icons.home, size: 25,semanticLabel: "Home",),
            Icon(Icons.security, size: 25),
            Icon(Icons.coronavirus_outlined, size: 25),
            Icon(Icons.perm_identity, size: 25),
          ],
          animationDuration: Duration(
            milliseconds: 300,
          ),
          animationCurve: Curves.bounceInOut,
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: SafeArea(
          child: Container(
            color: kPrimaryLightColor,
            child: Column(
              children: [
                (_page == 0)
                    ? SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                  child: (finaldata.length <= 0)
                                      ? CircularProgressIndicator()
                                      : CarouselSlider(
                                          options: CarouselOptions(
                                            aspectRatio: 2.0,
                                            height: 325,
                                            enlargeCenterPage: true,
                                            scrollDirection: Axis.horizontal,
                                            autoPlay: true,
                                          ),
                                          items: finaldata,
                                        )),
                              Divider(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  (_sfusertype == "user")
                                      ? Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  "HomeIntroduction");
                                            },
                                            child: Card(
                                              elevation: 8.0,
                                              child: Container(
                                                height: 170,
                                                width: 190,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Flex(
                                                    direction: Axis.vertical,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.security_outlined,
                                                        size: 65.0,
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text("Secure your home")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : (_sfusertype == "police")
                                          ? Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          "AllocatedHome");
                                                },
                                                child: Card(
                                                  elevation: 8.0,
                                                  child: Container(
                                                    height: 170,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Flex(
                                                        direction:
                                                            Axis.vertical,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .security_outlined,
                                                            size: 65.0,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text("Allocated Home")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .pushNamed(
                                                          "HomeIntroduction");
                                                },
                                                child: Card(
                                                  elevation: 8.0,
                                                  child: Container(
                                                    height: 170,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Flex(
                                                        direction:
                                                            Axis.vertical,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .security_outlined,
                                                            size: 65.0,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              "Secure your home")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            "WomenSafetyIntroduction");
                                      },
                                      child: Card(
                                        elevation: 8.0,
                                        child: Container(
                                          height: 170,
                                          width: 190,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Flex(
                                              direction: Axis.vertical,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.call_outlined,
                                                  size: 65.0,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text("Women Safety")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  (_sfusertype == "user")
                                      ? Flexible(
                                          fit: FlexFit.tight,
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              if (id == "") {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text:
                                                        "You need to login to view this content. Please Login",
                                                    confirmBtnText: 'Login',
                                                    cancelBtnText: 'Cancel',
                                                    onConfirmBtnTap: () {
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isActive);
                                                      Navigator.of(context)
                                                          .pushNamed("Login");
                                                    });
                                              } else {
                                                Navigator.of(context)
                                                    .pushNamed("FIRStatus");
                                              }
                                            },
                                            child: Card(
                                              elevation: 8.0,
                                              child: Container(
                                                height: 170,
                                                width: 190,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Flex(
                                                    direction: Axis.vertical,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.menu_book,
                                                        size: 65.0,
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                          "Check your FIR Status")
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : (_sfusertype == "police")
                                          ? Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  if (id == "") {
                                                    CoolAlert.show(
                                                        context: context,
                                                        type:
                                                            CoolAlertType.error,
                                                        text:
                                                            "You need to login to view this content. Please Login",
                                                        confirmBtnText: 'Login',
                                                        cancelBtnText: 'Cancel',
                                                        onConfirmBtnTap: () {
                                                          Navigator.of(context)
                                                              .popUntil((route) =>
                                                                  route
                                                                      .isActive);
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  "Login");
                                                        });
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            "AllocatedFIR");
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 8.0,
                                                  child: Container(
                                                    height: 170,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Flex(
                                                        direction:
                                                            Axis.vertical,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.menu_book,
                                                            size: 65.0,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text("Allocated FIR")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Flexible(
                                              fit: FlexFit.tight,
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  if (id == "") {
                                                    CoolAlert.show(
                                                        context: context,
                                                        type:
                                                            CoolAlertType.error,
                                                        text:
                                                            "You need to login to view this content. Please Login",
                                                        confirmBtnText: 'Login',
                                                        cancelBtnText: 'Cancel',
                                                        onConfirmBtnTap: () {
                                                          Navigator.of(context)
                                                              .popUntil((route) =>
                                                                  route
                                                                      .isActive);
                                                          Navigator.of(context)
                                                              .pushNamed(
                                                                  "Login");
                                                        });
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamed("FIRStatus");
                                                  }
                                                },
                                                child: Card(
                                                  elevation: 8.0,
                                                  child: Container(
                                                    height: 170,
                                                    width: 190,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Flex(
                                                        direction:
                                                            Axis.vertical,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.menu_book,
                                                            size: 65.0,
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                              "Check your FIR Status")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("EmergencyNumber");
                                      },
                                      child: Card(
                                        elevation: 8.0,
                                        child: Container(
                                          height: 170,
                                          width: 190,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Flex(
                                              direction: Axis.vertical,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  size: 65.0,
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                Text("Emergency Numbers")
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Visibility(
                        child: Text(""),
                        visible: false,
                      ),
                (_page == 1)
                    ? Expanded(
                  child: Stack(
                    children: [
                      Consumer<InfoWindowModel>(
                        builder: (context, model, child) {
                          return Stack(
                            children: [
                              child,
                              Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Visibility(
                                    visible:
                                    providerObject.showInfoWindow,
                                    child: (providerObject.user == null ||
                                        !providerObject
                                            .showInfoWindow)
                                        ? Container()
                                        : Container(
                                      margin: EdgeInsets.only(
                                        left: providerObject
                                            .leftMargin,
                                        top: providerObject
                                            .topMargin,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration:
                                            BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    5),
                                                gradient:
                                                LinearGradient(
                                                  colors: [
                                                    Colors
                                                        .white,
                                                    Color(
                                                        0xffcceeF5),
                                                  ],
                                                  end: Alignment
                                                      .bottomCenter,
                                                  begin: Alignment
                                                      .topCenter,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors
                                                          .grey,
                                                      offset:
                                                      Offset(
                                                          0.0,
                                                          1.0),
                                                      blurRadius:
                                                      6.0),
                                                ]),
                                            height: 115,
                                            width: 250,
                                            padding:
                                            EdgeInsets.all(15),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                Image.asset(
                                                  providerObject
                                                      .user.image,
                                                  height: 75,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      providerObject
                                                          .user
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize:
                                                          16,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .black87),
                                                    ),
                                                    FlatButton(
                                                      onPressed:
                                                          () {},
                                                      child: Text(
                                                          "View more"),
                                                      color: Colors
                                                          .red,
                                                      textColor:
                                                      Colors
                                                          .white,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Triangle.isosceles(
                                            edge: Edge.BOTTOM,
                                            child: Container(
                                              color:
                                              Colors.blueGrey,
                                              width: 20.0,
                                              height: 15.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                            ],
                          );
                        },
                        child: Positioned(
                          child: GoogleMap(
                            onTap: (position) {
                              if (providerObject.showInfoWindow) {
                                providerObject.updateVisibility(false);
                                providerObject.rebuildInfowindow();
                              }
                            },
                            onCameraMove: (position) {
                              if (providerObject.user != null) {
                                providerObject.updateInfowindow(
                                    context,
                                    mapController,
                                    providerObject.user.location,
                                    _infoWindowWidth,
                                    _markerOffset);
                                providerObject.rebuildInfowindow();
                              }
                            },
                            onMapCreated:
                                (GoogleMapController controller) {
                              mapController = controller;
                            },
                            mapToolbarEnabled: true,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(21.1702, 72.8311),
                              zoom: _currentZoom,
                            ),
                            markers: _markers,
                            // onMapCreated: (controller) => _onMapCreated(controller),
                            // onCameraMove: (position) => _updateMarkers(position.zoom),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Visibility(
                  child: Text(""),
                  visible: false,
                ),
                (_page == 2)
                    ? Expanded(child: CovidTracker())
                    : Visibility(
                  child: Text(""),
                  visible: false,
                ),
                (_page == 3)
                    ? Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            height: 115,
                            width: 115,
                            child: CircleAvatar(
                              backgroundImage: AssetImage("images/profile.png"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: FlatButton(
                              height: 45,
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Color(0xFFF5F6F9),
                              onPressed: () {},
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Name",
                                        style: TextStyle(),
                                      )),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: (id == "")
                                                ? Text(
                                                    "Guest",
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )
                                                : Text(
                                                    _sfname,
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: FlatButton(
                              height: 45,
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Color(0xFFF5F6F9),
                              onPressed: () {},
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Contact",
                                        style: TextStyle(),
                                      )),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: (id == "")
                                                ? Text(
                                                    "Guest",
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )
                                                : Text(
                                                    _sfcontact,
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: FlatButton(
                              height: 45,
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Color(0xFFF5F6F9),
                              onPressed: () {},
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "Email",
                                        style: TextStyle(),
                                      )),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: (id == "")
                                                ? Text(
                                                    "Guest",
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )
                                                : Text(
                                                    _sfemail,
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: FlatButton(
                              height: 45,
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Color(0xFFF5F6F9),
                              onPressed: () {
                                (id == "")
                                    ? CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text:
                                            "You need to login to view this content. Please Login",
                                        onConfirmBtnTap: () {
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          Navigator.of(context).pop();
                                          Navigator.of(context)
                                              .pushNamed("Login");
                                        })
                                    : Navigator.of(context).pushNamed(
                                        "ChangePassword",
                                        arguments: {"userid": id});
                              },
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.keyboard,
                                        color: Colors.grey,
                                        size: 22,
                                      ),
                                      Expanded(
                                        child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "Change Password",
                                              style: TextStyle(fontSize: 18.0),
                                            )),
                                      ),
                                      Icon(Icons.arrow_forward_ios),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Visibility(
                        child: Text(""),
                        visible: false,
                      ),
              ],
            ),
          ),
        ));
  }
}
