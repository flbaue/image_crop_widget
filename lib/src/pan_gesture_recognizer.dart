import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

typedef OnPanUpdate = Function(PointerEvent);
typedef OnPanEnd = Function(PointerEvent);

class PanGestureRecognizer extends OneSequenceGestureRecognizer {
  final OnPanUpdate onPanUpdate;
  final OnPanEnd onPanEnd;

  PanGestureRecognizer({@required this.onPanUpdate, @required this.onPanEnd});

  @override
  void addPointer(PointerEvent event) {
    startTrackingPointer(event.pointer);
    resolve(GestureDisposition.accepted);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      onPanUpdate(event);
    } else if (event is PointerDownEvent) {
      onPanUpdate(event);
    } else if (event is PointerUpEvent) {
      onPanEnd(event);
      stopTrackingPointer(event.pointer);
    } else {
      print("PanGestureRecognizer Pointer Event: ${event.runtimeType}");
    }
  }

  @override
  String get debugDescription => 'PanGestureRecognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
