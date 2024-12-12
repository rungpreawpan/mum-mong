import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/widgets/text_font_style.dart';

class ObjectDetectionPage extends StatelessWidget {
  const ObjectDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFontStyle(
          'object detection'.tr,
          size: fontSizeXL,
          weight: FontWeight.bold,
        ),
      ),
      body: SizedBox(),
    );
  }
}
