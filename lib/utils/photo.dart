import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> pickImage(
  ImageSource source,
  BuildContext context,
  void Function(String path) handlePicked,
) async {
  final ImagePicker picker = ImagePicker();

  try {
    final XFile? pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      handlePicked(pickedFile.path);
    }
    // ignore: empty_catches
  } catch (e) {}
}

void showImageSourceActionSheet(
  BuildContext parentContext,
  void Function(String path) handlePicked,
) {
  showModalBottomSheet(
    context: parentContext,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
              ),
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                pickImage(
                  ImageSource.gallery,
                  context,
                  handlePicked,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Câmera'),
              onTap: () {
                Navigator.pop(context);
                pickImage(
                  ImageSource.gallery,
                  context,
                  handlePicked,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
