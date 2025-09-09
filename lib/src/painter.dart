import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/canvas/touchy_canvas.dart';
import '../countries_world_map.dart';

/// This painter will paint a world map with all///
/// Giving countries a different color based on a data set can help visualize data.

class SimpleMapPainter extends CustomPainter {
  final List<Map<String, dynamic>> instructions;

  /// This Color is used for all the countries that have no custom color
  final Color defaultColor;
  final BuildContext context;

  /// The CountryColors is basically a list of Countries and Colors to give a Countrie a color of choice.
  final Map? colors;
  final void Function(String id, String name, TapUpDetails tapUpDetails)
      callback;

  /// Triggered when a country is hovered over.
  final void Function(String id, String name, Offset position, bool isHovering)?
      onHover;

  final CountryBorder? countryBorder;

  const SimpleMapPainter({
    required this.instructions,
    required this.defaultColor,
    this.colors,
    required this.context,
    required this.callback,
    this.onHover,
    this.countryBorder,
  });

  /// Calculate the center position of a country based on its path coordinates
  Offset? _getCountryCenter(SimpleMapInstruction country, Size canvasSize) {
    if (country.instructions.isEmpty) return null;

    try {
      double minX = double.infinity;
      double maxX = double.negativeInfinity;
      double minY = double.infinity;
      double maxY = double.negativeInfinity;

      // Parse all path instructions to find the bounding box
      for (String instruction in country.instructions) {
        if (instruction == "c") continue; // Skip close path instruction

        List<String> coordinates = instruction.substring(1).split(',');
        if (coordinates.length != 2) continue;

        double x = double.parse(coordinates[0]);
        double y = double.parse(coordinates[1]);

        minX = x < minX ? x : minX;
        maxX = x > maxX ? x : maxX;
        minY = y < minY ? y : minY;
        maxY = y > maxY ? y : maxY;
      }

      // Calculate center coordinates (normalized 0-1)
      double centerX = (minX + maxX) / 2;
      double centerY = (minY + maxY) / 2;

      // Scale to canvas size
      return Offset(centerX * canvasSize.width, centerY * canvasSize.height);
    } catch (e) {
      return null;
    }
  }

  @override
  void paint(Canvas c, Size s) {
    TouchyCanvas canvas = TouchyCanvas(context, c);

    // Get country paths from Json
    // List countryPaths = json.decode(jsonData);
    List<SimpleMapInstruction> countryPathList = <SimpleMapInstruction>[];
    for (var path in instructions) {
      countryPathList.add(SimpleMapInstruction.fromJson(path));
    }

    // Draw paths
    for (int i = 0; i < countryPathList.length; i++) {
      List<String> paths = countryPathList[i].instructions;
      Path path = Path();

      // Read path instructions and start drawing
      for (int j = 0; j < paths.length; j++) {
        String instruction = paths[j];
        if (instruction == "c") {
          path.close();
        } else {
          List<String> coordinates = instruction.substring(1).split(',');
          double x = double.parse(coordinates[0]);
          double y = double.parse(coordinates[1]);

          if (instruction[0] == 'm') path.moveTo(s.width * x, s.height * y);
          if (instruction[0] == 'l') path.lineTo(s.width * x, s.height * y);
        }
      }

      final onTapUp = (tabdetail) => callback(
            countryPathList[i].uniqueID,
            countryPathList[i].name,
            tabdetail,
          );

      final onHoverCallback = onHover != null
          ? (PointerHoverEvent hoverEvent) {
              final countryCenter = _getCountryCenter(countryPathList[i], s);
              onHover!(
                countryPathList[i].uniqueID,
                countryPathList[i].name,
                countryCenter ?? hoverEvent.localPosition,
                true,
              );
            }
          : null;

      final onHoverExitCallback = onHover != null
          ? (PointerExitEvent exitEvent) {
              final countryCenter = _getCountryCenter(countryPathList[i], s);
              onHover!(
                countryPathList[i].uniqueID,
                countryPathList[i].name,
                countryCenter ?? exitEvent.localPosition,
                false,
              );
            }
          : null;

      // Draw country body
      String uniqueID = countryPathList[i].uniqueID;
      Paint paint = Paint()..color = colors?[uniqueID] ?? defaultColor;
      canvas.drawPath(path, paint,
          onTapUp: onTapUp,
          onHover: onHoverCallback,
          onHoverExit: onHoverExitCallback);

      // Draw country border
      if (countryBorder != null) {
        paint.color = countryBorder!.color;
        paint.strokeWidth = countryBorder!.width;
        paint.style = PaintingStyle.stroke;
        canvas.drawPath(path, paint,
            onTapUp: onTapUp,
            onHover: onHoverCallback,
            onHoverExit: onHoverExitCallback);
      }
    }
  }

  @override
  bool shouldRepaint(SimpleMapPainter oldDelegate) =>
      oldDelegate.colors != colors;
}

class SimpleMapInstruction {
  /// uniqueID of the territory being drawn
  String uniqueID;

  /// Name of the territory being drawn
  String name;

  /// List of instructions to draw the territory
  List<String> instructions;

  /// Geographic bounds of the territory
  Map<String, dynamic>? geographicBounds;

  SimpleMapInstruction({
    required this.uniqueID,
    required this.instructions,
    required this.name,
    this.geographicBounds,
  });

  // To Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      "\"n\"": "\"$name\"",
      "\"u\"": "\"$uniqueID\"",
      "\"i\"": instructions,
    };
    if (geographicBounds != null) {
      data["\"g\""] = geographicBounds;
    }
    return data;
  }

  // From Json
  factory SimpleMapInstruction.fromJson(Map<String, dynamic> json) {
    List<String> paths = <String>[];

    List jsonPaths = json['i'];

    for (int i = 0; i < jsonPaths.length; i++) {
      paths.add(jsonPaths[i]);
    }

    return SimpleMapInstruction(
        uniqueID: json['u'],
        name: json['n'],
        instructions: paths,
        geographicBounds: json['g']);
  }
}
