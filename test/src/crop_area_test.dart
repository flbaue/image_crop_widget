// Copyright 2019 Florian Bauer. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:image_crop_widget/src/crop_area.dart';

void main() {
  test('moves top left corner and checks the bounds', () {
    final cropArea = CropArea(
      cornerSize: 10.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    cropArea.moveTopLeftCorner(Offset(20.0, 20.0));
    expect(cropArea.cropRect.left, 20.0);
    expect(cropArea.cropRect.top, 20.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 190.0);

    cropArea.moveTopLeftCorner(Offset(0.0, 0.0));
    expect(cropArea.cropRect.left, 10.0);
    expect(cropArea.cropRect.top, 10.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 190.0);

    cropArea.moveTopLeftCorner(Offset(125.0, 180.0));
    expect(cropArea.cropRect.left, 125.0);
    expect(cropArea.cropRect.top, 180.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 190.0);

    cropArea.moveTopLeftCorner(Offset(130.0, 185.0));
    expect(cropArea.cropRect.left, 125.0);
    expect(cropArea.cropRect.top, 180.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 190.0);
  });

  test('moves top right corner and checks the bounds', () {
    final cropArea = CropArea(
      cornerSize: 10.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    cropArea.moveTopRightCorner(Offset(180.0, 20.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 20.0);
    expect(cropArea.cropRect.right, 180.0);
    expect(cropArea.cropRect.bottom, 190.0);

    cropArea.moveTopRightCorner(Offset(200.0, 0.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 10.0);
    expect(cropArea.cropRect.right, 190.0);
    expect(cropArea.cropRect.bottom, 190.0);

    cropArea.moveTopRightCorner(Offset(0.0, 300.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 180.0);
    expect(cropArea.cropRect.right, 75.0);
    expect(cropArea.cropRect.bottom, 190.0);
  });

  test('moves bottom right corner and checks the bounds', () {
    final cropArea = CropArea(
      cornerSize: 10.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    cropArea.moveBottomRightCorner(Offset(180.0, 280.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 180.0);
    expect(cropArea.cropRect.bottom, 280.0);

    cropArea.moveBottomRightCorner(Offset(200.0, 300.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 190.0);
    expect(cropArea.cropRect.bottom, 290.0);

    cropArea.moveBottomRightCorner(Offset(0.0, 0.0));
    expect(cropArea.cropRect.left, 65.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 75.0);
    expect(cropArea.cropRect.bottom, 120.0);
  });

  test('moves bottom left corner and checks the bounds', () {
    final cropArea = CropArea(
      cornerSize: 10.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    cropArea.moveBottomLeftCorner(Offset(20.0, 280.0));
    expect(cropArea.cropRect.left, 20.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 280.0);

    cropArea.moveBottomLeftCorner(Offset(0.0, 300.0));
    expect(cropArea.cropRect.left, 10.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 290.0);

    cropArea.moveBottomLeftCorner(Offset(200.0, 0.0));
    expect(cropArea.cropRect.left, 125.0);
    expect(cropArea.cropRect.top, 110.0);
    expect(cropArea.cropRect.right, 135.0);
    expect(cropArea.cropRect.bottom, 120.0);
  });

  test('moves a crop area and checks the bounds', () {
    final cropArea = CropArea(
      cornerSize: 15.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    cropArea.moveArea(Offset(80.0, 80.0));
    expect(cropArea.cropRect.left, 45.0);
    expect(cropArea.cropRect.top, 40.0);
    expect(cropArea.cropRect.right, 115.0);
    expect(cropArea.cropRect.bottom, 120.0);

    cropArea.moveArea(Offset(20.0, 20.0));
    expect(cropArea.cropRect.left, 10.0);
    expect(cropArea.cropRect.top, 10.0);
    expect(cropArea.cropRect.right, 80.0);
    expect(cropArea.cropRect.bottom, 90.0);

    cropArea.moveArea(Offset(180.0, 280.0));
    expect(cropArea.cropRect.left, 120.0);
    expect(cropArea.cropRect.top, 210.0);
    expect(cropArea.cropRect.right, 190.0);
    expect(cropArea.cropRect.bottom, 290.0);
  });

  test('creates a crop area and checks the contains method', () {
    final cropArea = CropArea(
      cornerSize: 15.0,
    );

    cropArea.initSizes(
      bounds: Rect.fromLTRB(10, 10, 190, 290),
      center: Offset(100.0, 150.0),
      width: 70.0,
      height: 80.0,
    );

    expect(
      cropArea.contains(Offset(65.0, 110.0)),
      true,
      reason: "top left corner",
    );
    expect(
      cropArea.contains(Offset(135.0, 110.0)),
      true,
      reason: "top right corner",
    );
    expect(
      cropArea.contains(Offset(135.0, 190.0)),
      true,
      reason: "bottom right corner",
    );
    expect(
      cropArea.contains(Offset(65.0, 190.0)),
      true,
      reason: "bottom left corner",
    );

    expect(
      cropArea.contains(Offset(57.5, 102.5)),
      true,
      reason: "top left corner of corner rect",
    );
    expect(
      cropArea.contains(Offset(57.4, 102.4)),
      false,
      reason: "outside top left corner of corner rect",
    );

    expect(
      cropArea.contains(Offset(142.4, 102.6)),
      true,
      reason: "top right corner of corner rect",
    );
    expect(
      cropArea.contains(Offset(142.5, 102.5)),
      false,
      reason: "top right corner of corner rect",
    );

    expect(
      cropArea.contains(Offset(142.4, 197.4)),
      true,
      reason: "bottom right corner of corner rect",
    );
    expect(
      cropArea.contains(Offset(142.5, 197.5)),
      false,
      reason: "bottom right corner of corner rect",
    );

    expect(
      cropArea.contains(Offset(57.5, 197.4)),
      true,
      reason: "bottom left corner of corner rect",
    );
    expect(
      cropArea.contains(Offset(57.4, 197.5)),
      false,
      reason: "bottom left corner of corner rect",
    );
  });
}
