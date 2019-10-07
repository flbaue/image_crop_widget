import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_crop_widget/image_crop_widget.dart';

class ExampleScreen extends StatefulWidget {
  final ui.Image imageFile;
  ExampleScreen(this.imageFile);

  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final key = GlobalKey<ImageCropState>();

  void _onCropPress() async {
    final croppedImage = await key.currentState.cropImage();

    showModalBottomSheet(
      context: context,
      builder: (context) => RawImage(
        image: croppedImage,
        fit: BoxFit.contain,
        height: croppedImage.height.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ImageCrop(key: key, image: widget.imageFile),
            ),
            FlatButton(
              child: Text("Okay"),
              onPressed: _onCropPress,
            ),
          ],
        ),
      ),
    );
  }
}
