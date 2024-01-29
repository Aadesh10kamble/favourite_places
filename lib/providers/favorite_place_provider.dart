import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class FavoritePlaceNotifier extends StateNotifier<List<Place>> {
  FavoritePlaceNotifier() : super([]);

  void addItem(String title, File image, PlaceAddress address) {
    final updatedList = List.of(state);
    final favoritePlace = Place(title, image: image, location: address);

    updatedList.add(favoritePlace);
    state = updatedList;
  }
}

final favoritePlaceProvider =
    StateNotifierProvider<FavoritePlaceNotifier, List<Place>>(
        (ref) => FavoritePlaceNotifier());
