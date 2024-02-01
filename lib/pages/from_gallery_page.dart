// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:document_scanner/main.dart';
import 'package:document_scanner/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class FromGalleryPage extends StatefulWidget {
  const FromGalleryPage({super.key});

  @override
  State<FromGalleryPage> createState() => _FromGalleryPageState();
}

class _FromGalleryPageState extends State<FromGalleryPage> {
  final controller = DocumentScannerController();
  bool imageIsSelected = false;

  @override
  void initState() {
    super.initState();

    controller.currentPage.listen((AppPages page) {
      if (page == AppPages.takePhoto) {
        setState(() => imageIsSelected = false);
      }

      if (page == AppPages.cropPhoto) {
        setState(() => imageIsSelected = true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentScanner(
        controller: controller,
        generalStyles: GeneralStyles(
          showCameraPreview: false,
          widgetInsteadOfCameraPreview: Center(
            child: ElevatedButton(
              onPressed: _selectImage,
              child: const Text('Select image'),
            ),
          ),
        ),
        onSave: (Uint8List imageBytes) async {
          final isDone = await ImageGallerySaver.saveImage(
            Uint8List.fromList(imageBytes),
            quality: 100,
          );
          if (isDone != null) {
            CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: 'Image saved successfully');
            await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false,
            );
          } else {
            CustomSnackbar.show(snackbarType: SnackbarType.SUCCESS, message: "Can't save the file? Try again.");
          }
        },
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await controller.findContoursFromExternalImage(
      image: File(image.path),
    );
  }
}
