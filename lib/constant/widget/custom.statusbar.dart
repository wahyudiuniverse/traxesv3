import 'package:flutter/material.dart';

class GradientsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final Widget widget;

  const GradientsAppBar({super.key, required this.title, this.height = kToolbarHeight, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF661C63), // Start color (vibrant purple)
                  Color(0xFF1C4966), // End color
                ],
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
