
import 'package:flutter/material.dart';

class DoodleButton extends StatefulWidget {
  const DoodleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = const Color(0xFFF0F0F0),
    this.foregroundColor = Colors.black,
    this.elevation = 2.0,
    this.pressedElevation = 8.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.animationDuration = const Duration(milliseconds: 200),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final double pressedElevation;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;

  @override
  State<DoodleButton> createState() => _DoodleButtonState();
}

class _DoodleButtonState extends State<DoodleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.pressedElevation,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleHover(bool hovering) {
    setState(() => _isHovered = hovering);
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final effectiveBackgroundColor = isDisabled
        ? widget.backgroundColor.withOpacity(0.12)
        : widget.backgroundColor;
    final effectiveForegroundColor = isDisabled
        ? widget.foregroundColor.withOpacity(0.38)
        : widget.foregroundColor;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: widget.padding,
                decoration: ShapeDecoration(
                  color: effectiveBackgroundColor,
                  shape: DoodleBorder(
                    borderRadius: widget.borderRadius,
                    isPressed: _isPressed,
                    isHovered: _isHovered,
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: effectiveForegroundColor,
                    fontWeight: FontWeight.w500,
                  ),
                  child: IconTheme(
                    data: IconThemeData(color: effectiveForegroundColor),
                    child: widget.child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DoodleBorder extends ShapeBorder {
  const DoodleBorder({
    required this.borderRadius,
    this.isPressed = false,
    this.isHovered = false,
  });

  final double borderRadius;
  final bool isPressed;
  final bool isHovered;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    final radius = borderRadius;
    
    // Create a hand-drawn style border with slight variations
    final variation = isPressed ? 2.0 : (isHovered ? 1.5 : 1.0);
    
    // Top-left corner
    path.moveTo(radius + variation, 0);
    
    // Top edge with slight wave
    path.quadraticBezierTo(
      rect.width * 0.25, -variation,
      rect.width * 0.5, variation * 0.5,
    );
    path.quadraticBezierTo(
      rect.width * 0.75, variation,
      rect.width - radius - variation, 0,
    );
    
    // Top-right corner
    path.quadraticBezierTo(rect.width, 0, rect.width, radius + variation);
    
    // Right edge
    path.quadraticBezierTo(
      rect.width + variation * 0.5, rect.height * 0.5,
      rect.width, rect.height - radius - variation,
    );
    
    // Bottom-right corner
    path.quadraticBezierTo(
      rect.width, rect.height,
      rect.width - radius - variation, rect.height,
    );
    
    // Bottom edge
    path.quadraticBezierTo(
      rect.width * 0.75, rect.height + variation * 0.5,
      rect.width * 0.5, rect.height - variation * 0.5,
    );
    path.quadraticBezierTo(
      rect.width * 0.25, rect.height - variation,
      radius + variation, rect.height,
    );
    
    // Bottom-left corner
    path.quadraticBezierTo(0, rect.height, 0, rect.height - radius - variation);
    
    // Left edge
    path.quadraticBezierTo(
      -variation * 0.5, rect.height * 0.5,
      0, radius + variation,
    );
    
    // Close the path
    path.quadraticBezierTo(0, 0, radius + variation, 0);
    
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isPressed ? 2.5 : (isHovered ? 2.2 : 2.0);

    canvas.drawPath(getOuterPath(rect, textDirection: textDirection), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
