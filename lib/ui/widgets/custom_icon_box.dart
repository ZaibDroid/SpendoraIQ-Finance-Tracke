import 'package:flutter/material.dart';

class CustomIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final double opacity;
  final BoxShape shape;
  final double? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const CustomIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
    this.iconSize = 20,
    this.opacity = 0.15,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: opacity),
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius ?? 10)
            : null,
        boxShadow: boxShadow,
      ),
      child: Center(
        child: Icon(icon, color: color, size: iconSize),
      ),
    );
  }
}
