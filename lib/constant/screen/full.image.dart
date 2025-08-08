// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';

class FullScreenImageScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const FullScreenImageScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Detail foto", style: standarWhiteTextB,),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                
                color: Colors.white
              ),
              imageProvider: MemoryImage(imageBytes),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
