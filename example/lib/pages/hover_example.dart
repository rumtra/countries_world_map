import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:example/pages/my_tooltip.dart';
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
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: Stack(
              children: [
                SimpleMap(
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
                if (hoveredCountryId.isNotEmpty && hoverPosition != null)
                  Positioned(
                    left: hoverPosition!.dx,
                    top: hoverPosition!.dy,
                    child: MyTooltip(
                      isCurrentlyHovering: isCurrentlyHovering,
                      hoveredCountry: hoveredCountry,
                      hoveredCountryId: hoveredCountryId,
                      hoverPosition: hoverPosition,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
