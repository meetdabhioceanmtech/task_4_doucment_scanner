// ignore_for_file: lines_longer_than_80_chars, use_build_context_synchronously, inference_failure_on_instance_creation

import 'dart:typed_data';

import 'package:document_scanner/main.dart';
import 'package:document_scanner/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Color color = const Color(0XFF084277);

class CustomPage extends StatefulWidget {
  const CustomPage({super.key});

  @override
  State<CustomPage> createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  final _controller = DocumentScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentScanner(
        controller: _controller,
        generalStyles: GeneralStyles(
          hideDefaultBottomNavigation: true,
          // messageTakingPicture: 'Taking picture of document',
          // messageCroppingPicture: 'Cropping picture of document',
          // messageEditingPicture: 'Editing picture of document',
          // messageSavingPicture: 'Saving picture of document',
          baseColor: color,
        ),
        takePhotoDocumentStyle: TakePhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top + 25,
          hideDefaultButtonTakePicture: true,
          onLoading: const CircularProgressIndicator(
            color: Colors.white,
          ),
          children: [
            // * AppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: color,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 15,
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.document_scanner,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Scan document',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // * Button to take picture
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 10,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _controller.takePhoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: const Text(
                    'Take picture',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        cropPhotoDocumentStyle: CropPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
          maskColor: color.withOpacity(0.2),
        ),
        editPhotoDocumentStyle: EditPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
        ),
        resolutionCamera: ResolutionPreset.ultraHigh,
        pageTransitionBuilder: (child, animation) {
          final tween = Tween<double>(begin: 0, end: 1);

          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return ScaleTransition(
            scale: tween.animate(curvedAnimation),
            child: child,
          );
        },
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
}
