import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/core/models/arguments.dart';
import 'package:pokemon/core/styles/appstyle.dart';
import 'package:pokemon/core/utils/string_utils.dart';

/// Custom AppBar widget for the Pokemon app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    required this.arguments,
    required this.globalKey,
    required this.isDetailPage,
  });

  final String title;
  final Arguments arguments;
  final GlobalKey globalKey;
  final bool isDetailPage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.greenAccent,
      centerTitle: true,
      leadingWidth: 60,
      foregroundColor: AppStyle.mainColor,
      title: Center(
        child: Text(
          StringUtils.capitalize(title),
          style: GoogleFonts.pressStart2p(color: Colors.black, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
