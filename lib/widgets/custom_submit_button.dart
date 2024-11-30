import 'package:flutter/material.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/widgets/text_font_style.dart';

class CustomSubmitButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final double buttonHeight;
  final EdgeInsetsGeometry? buttonMargin;
  final Color buttonColor;
  final double borderRadius;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const CustomSubmitButton({
    super.key,
    required this.onTap,
    required this.title,
    this.fontSize = fontSizeL,
    this.fontWeight = FontWeight.bold,
    this.buttonColor = primaryColor,
    this.fontColor = Colors.white,
    this.buttonHeight = 50.0,
    this.buttonMargin,
    this.borderRadius = 10.0,
    this.showBorder = false,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: buttonHeight,
        margin: buttonMargin,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: showBorder
              ? Border.all(
                  color: borderColor,
                  width: borderWidth,
                )
              : null,
        ),
        child: Center(
          child: TextFontStyle(
            title,
            size: fontSize,
            weight: fontWeight,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
