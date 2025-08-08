import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final TextStyle? titleStyle;
  final Color? color;
  final VoidCallback? onTap;
  final FaIcon? faIcon;

  const CustomCard({super.key, 
    required this.icon,
    required this.title,
    this.faIcon,
    this.color,
    this.titleStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFFFFF),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
          ],
        ),
        title: Text(
          title,
          style: titleStyle,
        ),
        onTap: onTap,
      ),
    );
  }
}