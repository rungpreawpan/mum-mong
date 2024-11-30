import 'package:flutter/material.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/widgets/text_font_style.dart';

class ListviewButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  const ListviewButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconSize = 50.0,
    this.iconColor = Colors.black,
    required this.title,
    this.fontSize = fontSizeXL,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
            const SizedBox(width: marginX2),
            TextFontStyle(
              title,
              size: fontSize,
              weight: fontWeight,
            )
          ],
        ),
      ),
    );
  }
}
