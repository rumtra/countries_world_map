import 'package:flutter/material.dart';

class MyTooltip extends StatelessWidget {
  const MyTooltip({
    Key? key,
    required this.isCurrentlyHovering,
    required this.hoveredCountry,
    required this.hoveredCountryId,
    required this.hoverPosition,
  }) : super(key: key);

  final bool isCurrentlyHovering;
  final String hoveredCountry;
  final String hoveredCountryId;
  final Offset? hoverPosition;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: isCurrentlyHovering ? Colors.blue.shade50 : Colors.grey.shade50,
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
                  isCurrentlyHovering ? 'Currently Hovering:' : 'Last Hovered:',
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
                    color: isCurrentlyHovering ? Colors.green : Colors.grey,
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
                color: isCurrentlyHovering ? Colors.blue : Colors.grey.shade700,
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
    );
  }
}
