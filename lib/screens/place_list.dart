import 'package:favourite_places/providers/favorite_place_provider.dart';
import 'package:favourite_places/screens/add_place.dart';
import 'package:favourite_places/screens/single_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/models/place.dart';

class PlaceList extends ConsumerWidget {
  const PlaceList({super.key});

  void goToAddPlaceScreen(BuildContext context) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddPlace(),
      ));

  void goToPlaceScreen(BuildContext context, Place place) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SinglePlace(place: place)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(favoritePlaceProvider);
    final noItemsWidget = Center(
      child: Text('NO places Found!',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
              onPressed: () => goToAddPlaceScreen(context),
              icon: const Icon(Icons.add))
        ],
      ),
      body: places.isEmpty
          ? noItemsWidget
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(places[index].image)),
                    title: Text(places[index].title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(color: Colors.white)),
                    subtitle: Text(places[index].location.address),
                    onTap: () => goToPlaceScreen(context, places[index])),
              ),
            ),
    );
  }
}
