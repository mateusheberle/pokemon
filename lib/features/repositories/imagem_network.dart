import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget for displaying images from network URLs
///
/// Supports both regular images and SVG files.
/// Shows a loading indicator while fetching and an error icon on failure.
class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.color,
  });

  /// URL of the image to display
  final String url;

  /// How the image should be inscribed into the space
  final BoxFit fit;

  /// Optional height constraint
  final double? height;

  /// Optional width constraint
  final double? width;

  /// Optional color for loading indicator
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Check if URL is empty
    if (url.isEmpty) {
      return Icon(Icons.broken_image, size: height ?? 100);
    }

    // Determine file type from URL extension
    final lastPart = url.split('.');
    final isSvg = lastPart.last == 'svg';

    if (isSvg) {
      return SvgPicture.network(
        url,
        fit: fit,
        height: height ?? 100,
        width: width ?? 100,
        placeholderBuilder: (BuildContext context) =>
            Center(child: CircularProgressIndicator(color: color)),
        // ignore: deprecated_member_use
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, size: 50.0);
        },
      );
    }

    return Image.network(
      url,
      fit: fit,
      height: height ?? 100,
      width: width ?? 100,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image, size: height ?? 100);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
            color: color,
          ),
        );
      },
    );
  }
}
