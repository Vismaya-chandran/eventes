import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtils {
//========== Image PopUp ==========
  static Future<File?> imagePopUp(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                final NavigatorState nav = Navigator.of(context);

                final selectedImage = await imagePicker(ImageSource.camera);

                nav.pop(selectedImage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.collections),
              title: const Text('Gallery'),
              onTap: () async {
                final NavigatorState nav = Navigator.of(context);

                final selectedImage = await imagePicker(ImageSource.gallery);

                nav.pop(selectedImage);
              },
            ),
          ],
        );
      },
    );

    return result;
  }

//========== Image Picker ==========
  static Future<File?> imagePicker(ImageSource imageSource) async {
    final imagePicker = ImagePicker();
    try {
      final file = await imagePicker.pickImage(source: imageSource);
      if (file == null) return null;
      final imageFile = File(file.path);
      final croppedImage = await imageCropper(imageFile);
      if (croppedImage == null) return null;

      return croppedImage;

      // blobImage = await selectedImage.readAsBytes();
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
    return null;
  }

//========== Image Cropper ==========
  static Future<File?> imageCropper(File imageFile) async {
    try {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        // aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original
        ],
        uiSettings: [AndroidUiSettings(toolbarTitle: 'Crop Image')],
      );
      if (croppedImage != null) {
        return File(croppedImage.path);
      }

      return null;
    } catch (e, s) {
      log('Exception :$e', stackTrace: s);
    }
    return null;
  }
}
