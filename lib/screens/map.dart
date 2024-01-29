import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  const MapScreen(
      {super.key,
      this.placeAddress = const PlaceAddress(
        latitude: 37.11,
        longitude: -122,
        address: "",
      ),
      this.isSelecting = true});

  final PlaceAddress placeAddress;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;

  void getCurrentLocation() {
      Navigator.pop(context,pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting
            ? "Pick a Location"
            : widget.placeAddress.address),
        actions: [
          if (widget.isSelecting)
            IconButton(onPressed: pickedLocation == null ? () {} : getCurrentLocation, icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        mapToolbarEnabled: true,
        buildingsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              widget.placeAddress.latitude, widget.placeAddress.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting ?
        (argument) => setState(() => pickedLocation = argument) : null,
        mapType: MapType.satellite,
        markers: {
          Marker(
              markerId: const MarkerId("m1"),
              position: pickedLocation == null
                  ? LatLng(widget.placeAddress.latitude,
                      widget.placeAddress.longitude)
                  : pickedLocation!)
        },
      ),
    );
  }
}
