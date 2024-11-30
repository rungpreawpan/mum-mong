import 'package:flutter/material.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/widgets/custom_submit_button.dart';
import 'package:seeable/widgets/text_font_style.dart';

class IntroTemplate extends StatelessWidget {
  final bool isWelcomePage;
  final IconData icon;
  final String description;
  final Function() next;
  final Function() back;

  const IntroTemplate({
    super.key,
    this.isWelcomePage = false,
    required this.icon,
    required this.description,
    required this.next,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _introContent(),
            isWelcomePage ? _welcomeButton() : _actionButton(),
          ],
        ),
      ),
    );
  }

  _introContent() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _permissionIcon(),
          const SizedBox(height: 30.0),
          _permissionDescription(),
        ],
      ),
    );
  }

  _permissionIcon() {
    return Container(
      height: 300.0,
      width: 300.0,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(150.0),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 100.0,
        ),
      ),
    );
  }

  _permissionDescription() {
    return TextFontStyle(
      description,
      size: fontSizeL,
    );
  }

  _welcomeButton() {
    return CustomSubmitButton(
      onTap: next,
      title: 'Start',
      buttonMargin: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 50.0,
      ),
      borderRadius: 25.0,
    );
  }

  _actionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: back,
            child: const TextFontStyle(
              'ย้อนกลับ',
              size: fontSizeL,
            ),
          ),
          InkWell(
            onTap: next,
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const Center(
                child: Icon(Icons.arrow_forward_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
