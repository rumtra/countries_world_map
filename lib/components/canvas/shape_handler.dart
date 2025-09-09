import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'shapes/clip.dart';
import 'shapes/shape.dart';
import 'shapes/util.dart';
import 'types/types.dart';

class ShapeHandler {
  final List<Shape> _shapeStack = [];
  final List<ClipShapeItem> clipItems = [];
  final Set<GestureType> _registeredGestures = {};

  // Track the currently hovered shapes for hover exit detection
  static final Set<Shape> _currentlyHoveredShapes = {};

  Set<GestureType> get registeredGestures => _registeredGestures;

  void addShape(Shape shape) {
    if (shape is ClipShape) {
      clipItems.add(ClipShapeItem(shape, _shapeStack.length));
    } else {
      _shapeStack.add(shape);
      _registeredGestures.addAll(shape.registeredGestures);
    }
  }

  List<ClipShape> _getClipShapesBelowPosition(int position) {
    return clipItems
        .where((element) => element.position <= position)
        .map((e) => e.clipShape)
        .toList();
  }

  ///returns [true] if point lies inside all the clipShapes
  bool _isPointInsideClipShapes(List<ClipShape> clipShapes, Offset point) {
    for (int i = 0; i < clipShapes.length; i++) {
      if (!clipShapes[i].isInside(point)) return false;
    }
    return true;
  }

  Offset _getActualOffsetFromScrollController(Offset touchPoint,
      ScrollController? controller, AxisDirection direction) {
    if (controller == null) {
      return touchPoint;
    }

    final scrollPosition = controller.position;
    final actualScrollPixels =
        direction == AxisDirection.left || direction == AxisDirection.up
            ? scrollPosition.maxScrollExtent - scrollPosition.pixels
            : scrollPosition.pixels;

    if (direction == AxisDirection.left || direction == AxisDirection.right) {
      return Offset(touchPoint.dx + actualScrollPixels, touchPoint.dy);
    } else {
      return Offset(touchPoint.dx, touchPoint.dy + actualScrollPixels);
    }
  }

  List<Shape> _getTouchedShapes(Offset point) {
    var selectedShapes = <Shape>[];
    for (int i = _shapeStack.length - 1; i >= 0; i--) {
      var shape = _shapeStack[i];
      if (shape.hitTestBehavior == HitTestBehavior.deferToChild) {
        continue;
      }
      if (shape.isInside(point)) {
        if (_isPointInsideClipShapes(_getClipShapesBelowPosition(i), point) ==
            false) {
          if (shape.hitTestBehavior == HitTestBehavior.opaque) {
            return selectedShapes;
          }
          continue;
        }
        selectedShapes.add(shape);
        if (shape.hitTestBehavior == HitTestBehavior.opaque) {
          return selectedShapes;
        }
      }
    }
    return selectedShapes;
  }

  Future<void> handleGestureEvent(
    Gesture gesture, {
    ScrollController? scrollController,
    AxisDirection direction = AxisDirection.down,
  }) async {
    var touchPoint = _getActualOffsetFromScrollController(
        TouchCanvasUtil.getPointFromGestureDetail(gesture.gestureDetail),
        scrollController,
        direction);
    if (!_registeredGestures.contains(gesture.gestureType)) return;

    if (gesture.gestureType == GestureType.onHover) {
      var touchedShapes = _getTouchedShapes(touchPoint);

      // Handle hover exit for shapes that are no longer being hovered
      for (var previouslyHoveredShape
          in Set<Shape>.from(_currentlyHoveredShapes)) {
        if (!touchedShapes.contains(previouslyHoveredShape)) {
          if (previouslyHoveredShape.registeredGestures
              .contains(GestureType.onHoverExit)) {
            // Create a synthetic exit event using the current hover position
            var hoverEvent = gesture.gestureDetail as PointerHoverEvent;
            var syntheticExitEvent = PointerExitEvent(
              timeStamp: hoverEvent.timeStamp,
              pointer: hoverEvent.pointer,
              kind: hoverEvent.kind,
              device: hoverEvent.device,
              position: hoverEvent.position,
              delta: hoverEvent.delta,
              buttons: hoverEvent.buttons,
              obscured: hoverEvent.obscured,
              pressureMin: hoverEvent.pressureMin,
              pressureMax: hoverEvent.pressureMax,
              distance: hoverEvent.distance,
              distanceMax: hoverEvent.distanceMax,
              size: hoverEvent.size,
              radiusMajor: hoverEvent.radiusMajor,
              radiusMinor: hoverEvent.radiusMinor,
              radiusMin: hoverEvent.radiusMin,
              radiusMax: hoverEvent.radiusMax,
              orientation: hoverEvent.orientation,
              tilt: hoverEvent.tilt,
              synthesized: true,
            );
            var exitGesture =
                Gesture(GestureType.onHoverExit, syntheticExitEvent);
            var exitCallback =
                previouslyHoveredShape.getCallbackFromGesture(exitGesture);
            exitCallback();
          }
          _currentlyHoveredShapes.remove(previouslyHoveredShape);
        }
      }

      // Handle hover enter for newly hovered shapes
      for (var touchedShape in touchedShapes) {
        if (touchedShape.registeredGestures.contains(gesture.gestureType)) {
          var callback = touchedShape.getCallbackFromGesture(gesture);
          callback();
          _currentlyHoveredShapes.add(touchedShape);
        }
      }
    } else if (gesture.gestureType == GestureType.onHoverExit) {
      // Handle global exit (when mouse leaves the entire widget)
      for (var hoveredShape in Set<Shape>.from(_currentlyHoveredShapes)) {
        if (hoveredShape.registeredGestures.contains(GestureType.onHoverExit)) {
          var exitCallback = hoveredShape.getCallbackFromGesture(gesture);
          exitCallback();
        }
      }
      _currentlyHoveredShapes.clear();
    } else {
      // Handle other gesture types normally
      var touchedShapes = _getTouchedShapes(touchPoint);
      if (touchedShapes.isEmpty) return;
      for (var touchedShape in touchedShapes) {
        if (touchedShape.registeredGestures.contains(gesture.gestureType)) {
          var callback = touchedShape.getCallbackFromGesture(gesture);
          callback();
        }
      }
    }
  }
}
