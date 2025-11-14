import 'package:flutter/material.dart';
class DoodleBox extends StatelessWidget {
  const DoodleBox({
    super.key,
    this.child,
    this.size,
  });

  final Widget? child;
  final Size? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size?.height ?? 200,
      width: size?.width ?? 200,
      child: CustomPaint(
        painter: DoodlePainter(),
        child: child ?? const Center(
          child: Text(
            'Doodle Canvas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class DoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A) // Dark gray "pencil" color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0; // Hand-drawn look

    final path = Path();
    // Start drawing from the top left corner
    path.moveTo(0, 0); 
    
    // Draw a series of random, wavy lines to simulate a doodle outline
    // The control points for the Bezier curves are randomized
    
    // Top wavy edge
    path.quadraticBezierTo(size.width * 0.25, 20, size.width * 0.5, 0);
    path.quadraticBezierTo(size.width * 0.75, -20, size.width, 0);

    // Right wavy edge
    path.quadraticBezierTo(size.width - 20, size.height * 0.25, size.width, size.height * 0.5);
    path.quadraticBezierTo(size.width + 20, size.height * 0.75, size.width, size.height);

    // Bottom wavy edge
    path.quadraticBezierTo(size.width * 0.75, size.height - 20, size.width * 0.5, size.height);
    path.quadraticBezierTo(size.width * 0.25, size.height + 20, 0, size.height);

    // Left wavy edge
    path.quadraticBezierTo(20, size.height * 0.75, 0, size.height * 0.5);
    path.quadraticBezierTo(-20, size.height * 0.25, 0, 0);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // The shape is static, so we don't need to repaint
  }
}
