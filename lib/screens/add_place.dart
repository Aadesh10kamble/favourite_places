import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/favorite_place_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/widgets/location_input.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() {
    return AddPlaceState();
  }
}

class AddPlaceState extends ConsumerState<AddPlace> {
  final formKey = GlobalKey<FormState>();
  String titleField = '';
  File? image;
  PlaceAddress? locationData;

  void saveImage(File incomingImage) => setState(() => image = incomingImage);

  void saveCurrentLocation(PlaceAddress data) {
    setState(() => locationData = data);
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Inefficient Data"),
        content: const Text("Data is Missing"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"))
        ],
      ),
    );
  }

  void addItem() {
    final isValid = formKey.currentState!.validate();
    if (!isValid || image == null || locationData == null) return openDialog();
    formKey.currentState!.save();
    ref
        .read(favoritePlaceProvider.notifier)
        .addItem(titleField, image!, locationData!);

    formKey.currentState!.reset();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Add Place")),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 20.0 + keyboardHeight),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                    decoration: const InputDecoration(label: Text("Title")),
                    maxLength: 60,
                    validator: (value) {
                      if (value == null || value.trim().length <= 1) {
                        return "Title should be between 1 and 60 Characters long.";
                      }
                      return null;
                    },
                    onSaved: (newValue) => setState(() => titleField = newValue!),
                  ),
                  const SizedBox(height: 20),
                  ImageInput(saveImage: saveImage),
                  const SizedBox(height: 20),
                  LocationInput(saveLocation: saveCurrentLocation),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                      onPressed: addItem,
                      label: const Text("Add Place"),
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
          ),
      ),
      );
  }
}
