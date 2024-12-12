import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/views/navigation/controller/ble_controller.dart';
import 'package:seeable/widgets/custom_submit_button.dart';
import 'package:seeable/widgets/text_font_style.dart';

class NavigationPage extends StatefulWidget {
  final String appBarTitle;

  const NavigationPage({
    super.key,
    required this.appBarTitle,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final BleController _bleController = Get.find();

  bool isNavigate = false;
  bool isFavorite = false; //TODO: edit this fn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextFontStyle(
          widget.appBarTitle,
          size: fontAppbar,
          color: primaryColor,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: marginX2),
            child: CircleAvatar(
              backgroundColor: primaryColor,
              radius: 20,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 19,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: primaryColor,
                  size: 30.0,
                ),
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              isFavorite = !isFavorite;
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(right: marginX2),
              child: SvgPicture.asset(
                isFavorite
                    ? 'assets/icons/favorite_filled_icon.svg'
                    : 'assets/icons/favorite_icon.svg',
                color: primaryColor,
                height: 30.0,
              ),
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 90.0,
        elevation: 0.0,
      ),
      body: _content(),
    );
  }

  _content() {
    if (isNavigate) {
      return _navigation();
    } else {
      return _map();
    }
  }

  _map() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _infographic(),
        const SizedBox(height: marginX2),
        CustomSubmitButton(
          onTap: () {
            isNavigate = true;
            setState(() {});
          },
          title: 'start'.tr,
          buttonHeight: 70.0,
          buttonColor: Colors.grey.shade300,
          buttonMargin: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 20.0,
          ),
          borderRadius: 40.0,
          fontSize: 30.0,
          fontWeight: FontWeight.normal,
          fontColor: Colors.black,
          icon: SvgPicture.asset(
            'assets/icons/navigate_arrow_icon.svg',
          ),
        ),
      ],
    );
  }

  _infographic() {
    //TODO: add map
    return Container(
      color: Colors.grey.shade700,
      height: 100,
      width: 100,
    );
  }

  _navigation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: Get.width - 40.0,
          height: Get.width - 40.0,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(Get.width - 40 / 2),
          ),
          child: Center(
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(45 / 360), //TODO: rotate the arrow
              child: Icon(
                Icons.navigation_rounded,
                color: Colors.grey.shade800,
                size: 250.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: marginX2),
        CustomSubmitButton(
          onTap: () {},
          title: 'test',
          buttonHeight: 80.0,
          buttonColor: Colors.grey.shade300,
          buttonMargin: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 20.0,
          ),
          borderRadius: 15.0,
          fontSize: 30.0,
          fontColor: Colors.black,
        ),
      ],
    );
  }
}
