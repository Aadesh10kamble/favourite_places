import 'package:uuid/uuid.dart';
import "dart:io";

const uuid = Uuid();

class PlaceAddress {
  const PlaceAddress({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final String address;
  final double latitude;
  final double longitude;
}

class Place {
  Place(
    this.title, {
    required this.image,
    required this.location,
  }) : id = uuid.v4();
  
  final String title;
  final String id;
  final File image;
  final PlaceAddress location;
}
