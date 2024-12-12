import 'package:flutter/material.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/widgets/text_font_style.dart';

class SettingsLabel extends StatelessWidget {
  final String title;
  final bool showSwitch;
  final bool showList;

  const SettingsLabel({
    super.key,
    required this.title,
    this.showSwitch = true,
    this.showList = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFontStyle(
          title,
          size: fontSizeL,
        ),
      ],
    );
  }

  // TODO:
  // _switch() {
  //
  // }
  //
  // _list() {
  //   return InkWell(
  //     onTap: () {},
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade300,
  //         borderRadius: BorderRadius.circular(margin),
  //       ),
  //       child: Row(
  //         children: [
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
