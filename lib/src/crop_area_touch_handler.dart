// Copyright 2019 Florian Bauer. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'crop_area.dart';

class CropAreaTouchHandler {
  final CropArea _cropArea;
  Offset _activeAreaDelta;
  CropActionArea _activeArea;

  CropAreaTouchHandler({@required CropArea cropArea}) : _cropArea = cropArea;

  void startTouch(Offset touchPosition) {
    _activeArea = _cropArea.getActionArea(touchPosition);
    _activeAreaDelta = _cropArea.getActionAreaDelta(touchPosition, _activeArea);
  }

  void updateTouch(Offset touchPosition) {
    _cropArea.move(touchPosition, _activeAreaDelta, _activeArea);
  }

  void endTouch() {
    _activeArea = null;
    _activeAreaDelta = null;
  }
}
