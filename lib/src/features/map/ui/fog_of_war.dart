import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class FogOfWarPainter extends CustomPainter {
  final List<LatLng> revealedAreas;

  FogOfWarPainter(this.revealedAreas);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill the entire canvas with a semi-transparent color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black.withOpacity(0.7),
    );

    // For each revealed area, draw a clear circle at the corresponding position
    for (var area in revealedAreas) {
      var pos = Offset(area.longitude, area.latitude); // Convert LatLng to Offset
      canvas.drawCircle(pos, 50, Paint()..blendMode = BlendMode.clear);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // You might need to provide a condition based on your needs
    return true;
  }
}