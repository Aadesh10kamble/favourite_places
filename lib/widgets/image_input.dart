import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.saveImage});

  final void Function (File image) saveImage;
  @override
  State<ImageInput> createState() {
    return ImageInputState();
  }
}

class ImageInputState extends State<ImageInput> {
  final ImagePicker picker = ImagePicker();
  File? image;

  void selectPicture(ImageSource source) async {
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() =>image = File(pickedImage.path));
      widget.saveImage(File(pickedImage.path));
    }
    if (context.mounted) Navigator.pop(context);
  }

  void openSnackBar() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                      onPressed: () => selectPicture(ImageSource.gallery),
                      icon: const Icon(Icons.photo),
                      label: const Text("Gallery")),
                  TextButton.icon(
                      onPressed: () => selectPicture(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera),
                      label: const Text("Camera")),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white.withOpacity(0.2))),
        height: 200,
        width: double.infinity,
        alignment: Alignment.center,
        child: image != null
            ? InkWell(
                onTap: openSnackBar,
                child: Image.file(image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity))
            : ElevatedButton.icon(
                onPressed: openSnackBar,
                icon: const Icon(Icons.camera),
                label: const Text("Pick an Image")));
  }
}
