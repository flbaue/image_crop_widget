// Copyright 2019 Florian Bauer. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library image_crop_widget;

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'src/crop_area.dart';
import 'src/crop_area_touch_handler.dart';
import 'src/pan_gesture_recognizer.dart';

class ImageCrop extends StatefulWidget {
  final ui.Image image;

  ImageCrop({Key key, this.image})
      : assert(image != null),
        super(key: key);

  @override
  ImageCropState createState() => ImageCropState();
}

class ImageCropState extends State<ImageCrop> {
  /// Rotates the image clockwise by 90 degree.
  /// Completes when the rotation is done.
  Future<void> rotateImage() async {
    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);

    canvas.rotate(pi / 2);
    canvas.translate(-0, -_state.image.height.toDouble());
    canvas.drawImage(_state.image, Offset.zero, Paint());

    final image = await pictureRecorder
        .endRecording()
        .toImage(_state.image.height, _state.image.width);

    setState(() {
      _state.image = image;
    });
  }

  /// Crops the image to the currently marked area.
  /// Returns a new [ui.Image].
  Future<ui.Image> cropImage() async {
    final yOffset =
        (_state.widgetSize.height - _state.fittedImageSize.destination.height) /
            2.0;
    final xOffset =
        (_state.widgetSize.width - _state.fittedImageSize.destination.width) /
            2.0;
    final fittedCropRect = Rect.fromCenter(
      center: Offset(
        _state.cropArea.cropRect.center.dx - xOffset,
        _state.cropArea.cropRect.center.dy - yOffset,
      ),
      width: _state.cropArea.cropRect.width,
      height: _state.cropArea.cropRect.height,
    );

    final scale =
        _state.imageSize.width / _state.fittedImageSize.destination.width;
    final imageCropRect = Rect.fromLTRB(
        fittedCropRect.left * scale,
        fittedCropRect.top * scale,
        fittedCropRect.right * scale,
        fittedCropRect.bottom * scale);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImage(
      _state.image,
      Offset(-imageCropRect.left, -imageCropRect.top),
      Paint(),
    );

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(
      imageCropRect.width.toInt(),
      imageCropRect.height.toInt(),
    );

    return croppedImage;
  }

  _SharedCropState _state = _SharedCropState();

  @override
  void initState() {
    super.initState();
    _state.image = widget.image;
    _state.cropArea = CropArea();
    _state.cropAreaTouchHandler =
        CropAreaTouchHandler(cropArea: _state.cropArea);
  }

  void _onPanUpdate(PointerEvent event) {
    _onUpdate(event.position);
  }

  void _onPanEnd(PointerEvent event) {
    setState(() {
      _state.lastTouchPosition = null;
      _state.touchPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black87,
      child: CustomPaint(
        painter: _ImagePainter(_state),
        foregroundPainter: _OverlayPainter(_state),
        child: RawGestureDetector(
          gestures: {
            PanGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
              () => PanGestureRecognizer(
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
              ),
              (PanGestureRecognizer instance) {},
            )
          },
        ),
      ),
    );
  }

  void _onUpdate(Offset globalPosition) {
    final RenderBox renderBox = context.findRenderObject();
    _state.lastTouchPosition = _state.touchPosition;
    _state.touchPosition = renderBox.globalToLocal(globalPosition);

    if (_state.lastTouchPosition == null) {
      _state.cropAreaTouchHandler.startTouch(_state.touchPosition);
    } else {
      _state.cropAreaTouchHandler.updateTouch(_state.touchPosition);
    }

    setState(() {});
  }
}

class _SharedCropState {
  ui.Image image;

  Offset touchPosition;
  Offset lastTouchPosition;

  Size widgetSize;
  Size imageSize;
  FittedSizes fittedImageSize;
  double horizontalSpacing;
  double verticalSpacing;
  Rect imageContainingRect;

  CropArea cropArea;
  CropAreaTouchHandler cropAreaTouchHandler;
}

class _ImagePainter extends CustomPainter {
  final _SharedCropState state;
  final ui.Image image;

  _ImagePainter(this.state) : image = state.image;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final displayRect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    state.widgetSize = size;
    paintImage(
      canvas: canvas,
      image: state.image,
      rect: displayRect,
      fit: BoxFit.contain,
    );
    state.imageSize = Size(
      state.image.width.toDouble(),
      state.image.height.toDouble(),
    );
    state.fittedImageSize = applyBoxFit(
      BoxFit.contain,
      state.imageSize,
      size,
    );
    state.horizontalSpacing =
        (state.widgetSize.width - state.fittedImageSize.destination.width) / 2;
    state.verticalSpacing =
        (state.widgetSize.height - state.fittedImageSize.destination.height) /
            2;
    state.imageContainingRect = Rect.fromLTWH(
        state.horizontalSpacing,
        state.verticalSpacing,
        state.fittedImageSize.destination.width,
        state.fittedImageSize.destination.height);
  }

  @override
  bool shouldRepaint(_ImagePainter oldDelegate) {
    return image != oldDelegate.image;
  }
}

class _OverlayPainter extends CustomPainter {
  final _SharedCropState _state;
  final Rect _cropRect;
  final paintCorner = Paint()
    ..strokeWidth = 10.0
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;
  final paintBackground = Paint()..color = Colors.white30;

  _OverlayPainter(this._state) : _cropRect = _state.cropArea.cropRect;

  @override
  void paint(Canvas canvas, Size size) {
    if (_state.cropArea.cropRect == null) {
      _state.cropArea.initSizes(
        bounds: _state.imageContainingRect,
        center: Offset(size.width / 2, size.height / 2),
        height: 100.0,
        width: 100.0,
      );
    }

    canvas.drawRect(_state.cropArea.cropRect, paintBackground);
    final points = <Offset>[
      _state.cropArea.cropRect.topLeft,
      _state.cropArea.cropRect.topRight,
      _state.cropArea.cropRect.bottomLeft,
      _state.cropArea.cropRect.bottomRight
    ];

    canvas.drawPoints(ui.PointMode.points, points, paintCorner);
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) {
    return _cropRect != oldDelegate._cropRect;
  }
}
