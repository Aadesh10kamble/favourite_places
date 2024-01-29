import 'dart:convert';

import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:favourite_places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.saveLocation});

  final void Function(PlaceAddress) saveLocation;
  @override
  State<LocationInput> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  PlaceAddress? coordinate;
  bool isGettingLocation = false;
  String address = '';

  Future<void> getAddress(double latitude, double longitude) async {
    final uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${dotenv.env["googleApiKey"]}');

    final response = await http.get(uri);
    if (response.statusCode != 200) return;
    final responseBody = json.decode(response.body);

    final String formattedAddress =
        responseBody["results"][0]["formatted_address"];

    final formattedLocation = PlaceAddress(
        latitude: latitude, longitude: longitude, address: formattedAddress);

    widget.saveLocation(formattedLocation);

    setState(() {
      isGettingLocation = false;
      coordinate = formattedLocation;
    });
  }

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() => isGettingLocation = true);
    locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;
    if (latitude == null || longitude == null) return;
    await getAddress(latitude, longitude);
  }

  String get getMap {
    final address = coordinate!.address;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$address&size=600x400&zoom=16&markers=color:blue%7Clabel:L%7C${coordinate!.latitude},${coordinate!.longitude}&key=${dotenv.env["googleApiKey"]}';
  }

  void goToMapScreen() async {
    final pickedLocation = await Navigator.push<LatLng>(
        context, MaterialPageRoute(builder: (context) => const MapScreen()));
    if (pickedLocation == null) return;
    setState(() => isGettingLocation = true);
    await getAddress(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton.icon(
              onPressed: isGettingLocation ? () {} : getCurrentLocation,
              label: Text(isGettingLocation ? "Loading.." : "Get Location"),
              icon: const Icon(Icons.location_on)),
          ElevatedButton.icon(
              onPressed: () => goToMapScreen(),
              label: const Text("Open maps"),
              icon: const Icon(Icons.map)),
        ]),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1, color: Colors.white.withOpacity(0.2))),
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          child: isGettingLocation
              ? const CircularProgressIndicator()
              : coordinate == null
                  ? const Text("")
                  : Image.network(getMap,
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity),
        ),
        Text(
          coordinate == null ? '' : coordinate!.address,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
        )
      ],
    );
  }
}
