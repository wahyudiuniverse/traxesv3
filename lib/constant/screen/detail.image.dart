import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailFullScreenImageScreen extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageUrl;

  const DetailFullScreenImageScreen({super.key, this.imageBytes, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: PhotoView(
              imageProvider: imageBytes != null 
                ? MemoryImage(imageBytes!)
                : NetworkImage(imageUrl!) as ImageProvider,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
