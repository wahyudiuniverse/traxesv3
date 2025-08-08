import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Color(0xFF1C4966), Color(0xFF661C63)]),
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient, 
        borderRadius: effectiveBorderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, 
          shadowColor: Colors.transparent, 
          shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
          padding: padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16), 
        ),
        child: child,
      ),
    );
  }
}
