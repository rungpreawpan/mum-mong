import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seeable/constant/value_constant.dart';

class TextFontStyle extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  final FontWeight weight;
  final bool underline;
  final TextOverflow? overflow;

  const TextFontStyle(
    this.data, {
    super.key,
    this.color = Colors.black,
    this.size = fontSizeS,
    this.weight = FontWeight.normal,
    this.underline = false,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        fontFamily: GoogleFonts.kanit().fontFamily,
        decoration: underline ? TextDecoration.underline : null,
        overflow: overflow,
      ),
    );
  }
}
