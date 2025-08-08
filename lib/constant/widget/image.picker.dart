import 'package:flutter/material.dart';
import 'dart:io';

import 'package:traxes/constant/text.style.dart';

class CustomImagePicker extends StatelessWidget {
  final File? imageFile;
  final String label;
  final Function() onTap;

  const CustomImagePicker({
    super.key,
    required this.imageFile,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: MediaQuery.of(context).size.width / 3.8,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: imageFile == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt,
                    color: Colors.black45,
                    size: 40,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    style: smallBlackText,
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
