import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SinglePlace extends StatelessWidget {
  const SinglePlace({super.key, required this.place});

  final Place place;

  String get getMap {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=${place.location.address}&size=600x400&zoom=16&markers=color:blue%7Clabel:L%7C${place.location.latitude},${place.location.longitude}&key=${dotenv.env["googleApiKey"]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(place.title)),
        body: Stack(
          children: [
            Image.file(place.image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                            placeAddress: place.location, isSelecting: false),
                      ));
                },
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(getMap),
                    )),
              ),
            ),
          ],
        ));
  }
}
