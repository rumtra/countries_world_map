import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../types/types.dart';

class ShapeUtil {
  static double distance(Offset p1, Offset p2) {
    return sqrt(pow(p2.dy - p1.dy, 2) + pow(p2.dx - p1.dx, 2));
  }
}

typedef GestureCallbackFunction = void Function();

class TouchCanvasUtil {
  static Offset getPointFromGestureDetail(dynamic gestureDetail) {
    if (gestureDetail is TapUpDetails) {
      return gestureDetail.localPosition;
    } else if (gestureDetail is PointerHoverEvent) {
      return gestureDetail.localPosition;
    } else if (gestureDetail is PointerExitEvent) {
      return gestureDetail.localPosition;
    } else {
      throw Exception(
          "gestureDetail.runTimeType = ${gestureDetail.runtimeType} is not recognized ! ");
    }
  }

  static Map<GestureType, Function> getGestureCallbackMap({
    // required GestureTapDownCallback? onTapDown,
    required GestureTapUpCallback? onTapUp,
    required void Function(PointerHoverEvent)? onHover,
    required void Function(PointerExitEvent)? onHoverExit,
    // required GestureLongPressStartCallback? onLongPressStart,
    // required GestureLongPressEndCallback? onLongPressEnd,
    // required GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate,
    // required GestureForcePressStartCallback? onForcePressStart,
    // required GestureForcePressEndCallback? onForcePressEnd,
    // required GestureForcePressPeakCallback? onForcePressPeak,
    // required GestureForcePressUpdateCallback? onForcePressUpdate,
    // required GestureDragStartCallback? onPanStart,
    // required GestureDragUpdateCallback? onPanUpdate,
    // required GestureDragDownCallback? onPanDown,
    // required GestureTapDownCallback? onSecondaryTapDown,
    // required GestureTapUpCallback? onSecondaryTapUp,
  }) {
    var map = <GestureType, Function>{};

    // if (onTapDown != null) {
    //   map.putIfAbsent(GestureType.onTapDown, () => onTapDown);
    // }
    if (onTapUp != null) map.putIfAbsent(GestureType.onTapUp, () => onTapUp);
    if (onHover != null) map.putIfAbsent(GestureType.onHover, () => onHover);
    if (onHoverExit != null)
      map.putIfAbsent(GestureType.onHoverExit, () => onHoverExit);

    // if (onLongPressStart != null) {
    //   map.putIfAbsent(GestureType.onLongPressStart, () => onLongPressStart);
    // }
    // if (onLongPressMoveUpdate != null) {
    //   map.putIfAbsent(GestureType.onLongPressMoveUpdate, () => onLongPressMoveUpdate);
    // }
    // if (onLongPressEnd != null) {
    //   map.putIfAbsent(GestureType.onLongPressEnd, () => onLongPressEnd);
    // }

    // if (onForcePressStart != null) {
    //   map.putIfAbsent(GestureType.onForcePressStart, () => onForcePressStart);
    // }
    // if (onForcePressEnd != null) {
    //   map.putIfAbsent(GestureType.onForcePressEnd, () => onForcePressEnd);
    // }
    // if (onForcePressUpdate != null) {
    //   map.putIfAbsent(GestureType.onForcePressUpdate, () => onForcePressUpdate);
    // }
    // if (onForcePressPeak != null) {
    //   map.putIfAbsent(GestureType.onForcePressPeak, () => onForcePressPeak);
    // }

    // if (onPanStart != null) {
    //   map.putIfAbsent(GestureType.onPanStart, () => onPanStart);
    // }
    // if (onPanUpdate != null) {
    //   map.putIfAbsent(GestureType.onPanUpdate, () => onPanUpdate);
    // }
    // if (onPanDown != null) {
    //   map.putIfAbsent(GestureType.onPanDown, () => onPanDown);
    // }

    // if (onSecondaryTapDown != null) {
    //   map.putIfAbsent(GestureType.onSecondaryTapDown, () => onSecondaryTapDown);
    // }
    // if (onSecondaryTapUp != null) {
    //   map.putIfAbsent(GestureType.onSecondaryTapUp, () => onSecondaryTapUp);
    // }

    return map;
  }
}
