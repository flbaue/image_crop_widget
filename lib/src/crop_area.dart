// Copyright 2019 Florian Bauer. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

class CropArea {
  final double _cornerSize;
  Rect _bounds;
  Rect _cropRect;
  Rect _topLeftCorner;
  Rect _topRightCorner;
  Rect _bottomRightCorner;
  Rect _bottomLeftCorner;

  CropArea({
    double cornerSize = 32.0,
  }) : _cornerSize = cornerSize;

  void initSizes({
    @required Offset center,
    @required double width,
    @required double height,
    @required Rect bounds,
  }) {
    _bounds = bounds;
    _cropRect = Rect.fromCenter(center: center, width: width, height: height);
    _updateCorners();
  }

  Rect get cropRect => _cropRect;

  void _updateCorners() {
    _topLeftCorner = Rect.fromCenter(
      center: _cropRect.topLeft,
      width: _cornerSize,
      height: _cornerSize,
    );
    _topRightCorner = Rect.fromCenter(
      center: _cropRect.topRight,
      width: _cornerSize,
      height: _cornerSize,
    );
    _bottomRightCorner = Rect.fromCenter(
      center: _cropRect.bottomRight,
      width: _cornerSize,
      height: _cornerSize,
    );
    _bottomLeftCorner = Rect.fromCenter(
      center: _cropRect.bottomLeft,
      width: _cornerSize,
      height: _cornerSize,
    );
  }

  bool contains(Offset position) {
    return _cropRect.contains(position) ||
        _topLeftCorner.contains(position) ||
        _topRightCorner.contains(position) ||
        _bottomRightCorner.contains(position) ||
        _bottomLeftCorner.contains(position);
  }

  void moveArea(Offset newCenter) {
    final newRect = Rect.fromCenter(
      center: newCenter,
      width: _cropRect.width,
      height: _cropRect.height,
    );

    var offset = Offset(0.0, 0.0);
    if (newRect.left < _bounds.left) {
      offset = offset.translate(_bounds.left - newRect.left, 0.0);
    }

    if (newRect.top < _bounds.top) {
      offset = offset.translate(0.0, _bounds.top - newRect.top);
    }

    if (newRect.right > _bounds.right) {
      offset = offset.translate(_bounds.right - newRect.right, 0.0);
    }

    if (newRect.bottom > _bounds.bottom) {
      offset = offset.translate(0.0, _bounds.bottom - newRect.bottom);
    }

    _cropRect = newRect.shift(offset);
    _updateCorners();
  }

  double _applyLeftBounds(double left) {
    var boundedLeft = max(
      left,
      _bounds.left,
    ); // left bound
    boundedLeft = min(
      boundedLeft,
      _cropRect.right - _cornerSize,
    ); // right bound
    return boundedLeft;
  }

  double _applyTopBounds(double top) {
    var boundedTop = max(
      top,
      _bounds.top,
    ); // top bound
    boundedTop = min(
      boundedTop,
      _cropRect.bottom - _cornerSize,
    ); // bottom bound
    return boundedTop;
  }

  double _applyRightBounds(double right) {
    var boundedRight = min(
      right,
      _bounds.right,
    ); // right bound
    boundedRight = max(
      boundedRight,
      _cropRect.left + _cornerSize,
    ); // left bound
    return boundedRight;
  }

  double _applyBottomBounds(double bottom) {
    var boundedBottom = min(
      bottom,
      _bounds.bottom,
    ); // bottom bound
    boundedBottom = max(
      boundedBottom,
      _cropRect.top + _cornerSize,
    ); // top bound
    return boundedBottom;
  }

  void moveTopLeftCorner(Offset newPosition) {
    _cropRect = Rect.fromLTRB(
      _applyLeftBounds(newPosition.dx),
      _applyTopBounds(newPosition.dy),
      _cropRect.right,
      _cropRect.bottom,
    );
    _updateCorners();
  }

  void moveTopRightCorner(Offset newPosition) {
    _cropRect = Rect.fromLTRB(
      _cropRect.left,
      _applyTopBounds(newPosition.dy),
      _applyRightBounds(newPosition.dx),
      _cropRect.bottom,
    );
    _updateCorners();
  }

  void moveBottomRightCorner(Offset newPosition) {
    _cropRect = Rect.fromLTRB(
      _cropRect.left,
      _cropRect.top,
      _applyRightBounds(newPosition.dx),
      _applyBottomBounds(newPosition.dy),
    );
    _updateCorners();
  }

  void moveBottomLeftCorner(Offset newPosition) {
    _cropRect = Rect.fromLTRB(
      _applyLeftBounds(newPosition.dx),
      _cropRect.top,
      _cropRect.right,
      _applyBottomBounds(newPosition.dy),
    );
    _updateCorners();
  }

  Offset _getTopLeftDelta(Offset position) {
    return _topLeftCorner.center - position;
  }

  Offset _getTopRightDelta(Offset position) {
    return _topRightCorner.center - position;
  }

  Offset _getBottomRightDelta(Offset position) {
    return _bottomRightCorner.center - position;
  }

  Offset _getBottomLeftDelta(Offset position) {
    return _bottomLeftCorner.center - position;
  }

  Offset _getCenterDelta(Offset position) {
    return _cropRect.center - position;
  }

  CropActionArea getActionArea(Offset position) {
    if (_topLeftCorner.contains(position)) {
      return CropActionArea.top_left;
    }

    if (_topRightCorner.contains(position)) {
      return CropActionArea.top_right;
    }

    if (_bottomLeftCorner.contains(position)) {
      return CropActionArea.bottom_left;
    }

    if (_bottomRightCorner.contains(position)) {
      return CropActionArea.bottom_right;
    }

    if (_cropRect.contains(position)) {
      return CropActionArea.center;
    }

    return CropActionArea.none;
  }

  Offset getActionAreaDelta(Offset position, CropActionArea activeArea) {
    switch (activeArea) {
      case CropActionArea.top_left:
        return _getTopLeftDelta(position);
      case CropActionArea.top_right:
        return _getTopRightDelta(position);
      case CropActionArea.bottom_right:
        return _getBottomRightDelta(position);
      case CropActionArea.bottom_left:
        return _getBottomLeftDelta(position);
      case CropActionArea.center:
        return _getCenterDelta(position);
      default:
        return Offset.zero;
    }
  }

  void move(Offset position, Offset delta, CropActionArea actionArea) {
    switch (actionArea) {
      case CropActionArea.top_left:
        moveTopLeftCorner(position + delta);
        break;
      case CropActionArea.top_right:
        moveTopRightCorner(position + delta);
        break;
      case CropActionArea.bottom_right:
        moveBottomRightCorner(position + delta);
        break;
      case CropActionArea.bottom_left:
        moveBottomLeftCorner(position + delta);
        break;
      case CropActionArea.center:
        moveArea(position + delta);
        break;
      default:
    }
  }
}

enum CropActionArea {
  top_left,
  top_right,
  bottom_right,
  bottom_left,
  center,
  none
}
