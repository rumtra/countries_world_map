import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

class HoverExampleMap extends StatefulWidget {
  const HoverExampleMap({Key? key}) : super(key: key);

  @override
  _HoverExampleMapState createState() => _HoverExampleMapState();
}

class _HoverExampleMapState extends State<HoverExampleMap> {
  String hoveredCountry = '';
  String hoveredCountryId = '';
  Offset? hoverPosition;
  bool isCurrentlyHovering = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            maxScale: 75.0,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: SimpleMap(
                    instructions: SMapWorld.instructionsMercator,
                    defaultColor: Colors.grey,
                    callback: (id, name, tapdetails) {},
                    onHover: (id, name, position, isHovering) {
                      setState(() {
                        if (isHovering) {
                          hoveredCountry = name;
                          hoveredCountryId = id;
                          hoverPosition = position;
                          isCurrentlyHovering = true;
                        } else {
                          isCurrentlyHovering = false;
                        }
                      });
                    },
                    countryBorder: CountryBorder(color: Colors.white),
                    colors: SMapWorldColors(
                      uS: Colors.blue.shade300,
                      cA: Colors.red.shade300,
                      bR: Colors.green.shade300,
                      rU: Colors.purple.shade300,
                      cN: Colors.orange.shade300,
                      iN: Colors.pink.shade300,
                      aU: Colors.cyan.shade300,
                      dE: Colors.yellow.shade600,
                      fR: Colors.indigo.shade300,
                      gB: Colors.teal.shade300,
                    ).toMap(),
                  ),
                ),
                Container(width: MediaQuery.of(context).size.width * 0.08),
              ],
            ),
          ),
        ),
        if (hoveredCountryId.isNotEmpty && hoverPosition != null)
          Positioned(
            left: hoverPosition!.dx,
            top: hoverPosition!.dy,
            child: Card(
              elevation: 8,
              color: isCurrentlyHovering
                  ? Colors.blue.shade50
                  : Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isCurrentlyHovering
                              ? 'Currently Hovering:'
                              : 'Last Hovered:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrentlyHovering
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      hoveredCountry,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCurrentlyHovering
                            ? Colors.blue
                            : Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Country ID: $hoveredCountryId',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (hoverPosition != null) ...[
                      SizedBox(height: 4),
                      Text(
                        'Country Center: (${hoverPosition!.dx.toStringAsFixed(1)}, ${hoverPosition!.dy.toStringAsFixed(1)})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    SizedBox(height: 4),
                    Text(
                      'Hovering: ${isCurrentlyHovering ? 'Yes' : 'No'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isCurrentlyHovering ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
