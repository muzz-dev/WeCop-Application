import 'package:google_maps_flutter/google_maps_flutter.dart';

class User{
  final String username;
  final String name;
  final String image;
  final LatLng location;
  final int rating;

  User(
      this.username,
      this.name,
      this.image,
      this.location,
      this.rating,
      );
}