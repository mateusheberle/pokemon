import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageNetwork extends StatelessWidget {
  const ImageNetwork({
    super.key,
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.color,
  });

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    List<String> lastPart = (url).split('.');
    if (lastPart.last == 'svg') {
      return SvgPicture.network(
        url,
        fit: fit,
        height: height ?? 100,
        width: width ?? 100,
        placeholderBuilder: (BuildContext context) => Center(
            child: CircularProgressIndicator(
          color: color,
        )),
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error,
              size: 50.0); // Fallback em caso de erro
        },
      );
    } else {
      if (url.isEmpty) {
        return Icon(Icons.broken_image,
            size: height ?? 100); // Fallback para URL vazia
      }
      return Image.network(
        url,
        fit: fit,
        height: height ?? 100,
        width: width ?? 100,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.e_mobiledata,
              size: height ?? 100); // Fallback em caso de erro
        },
      );
    }
  }
}
