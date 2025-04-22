import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class GalleryPage extends StatelessWidget {
  final List<ImageProvider> images;
  final int initialIndex;

  const GalleryPage({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(initialPage: initialIndex);

    return PageView.builder(
      controller: pageController,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return PhotoView(
          imageProvider: images[index],
        );
      },
    );
  }
}
