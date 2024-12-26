import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/views/navigation/controller/ble_controller.dart';
import 'package:seeable/widgets/custom_submit_button.dart';
import 'package:seeable/widgets/text_font_style.dart';
import 'package:sensors_plus/sensors_plus.dart';

class NavigationPage extends StatefulWidget {
  final BluetoothDevice device;

  const NavigationPage({
    super.key,
    required this.device,
  });

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final BleController _bleController = Get.find();

  Timer? _timer;
  bool isNavigate = false;
  bool isFavorite = false; //TODO: edit this fn

  double angle = 0;
  double userX = 0.0, userY = 0.0;
  double rotationX = 0.0, rotationY = 0.0, rotationZ = 0.0;

  @override
  void initState() {
    super.initState();

    _startTimer();
    _trackOrientation();
  }

  _startTimer() async {
    await _bleController.connectDevice(widget.device);

    _timer ??= Timer.periodic(
      const Duration(milliseconds: 500),
          (Timer t) async {
        await _bleController.readRssi(widget.device);

        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  _trackOrientation() {
    magnetometerEvents.listen((MagnetometerEvent event) {
      angle = atan2(event.y, event.x) * (180 / pi);
      setState(() {});
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        rotationX += event.x;
        rotationY += event.y;
        rotationZ += event.z;

        userX += event.y * 0.01;
        userY += event.x * 0.01;
        print(userX);
        print(userY);
      });
    });
  }

  _calculateRssi() {
    // Distance = 10 ^ ((Measured Power -RSSI)/(10 * N))
    if (_bleController.rssi != null) {
      double distance =
      pow(10, (-69 - _bleController.rssi!) / (10 * 3)).toDouble();

      return distance.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextFontStyle(
          widget.device.platformName,
          size: fontAppbar,
          color: primaryColor,
          weight: FontWeight.bold,
          align: TextAlign.center,
        ),
        leading: InkWell(
          onTap: () {
            Get.back(result: true);
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
              turns: AlwaysStoppedAnimation(angle / 360),
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
          title: '${angle.toStringAsFixed(0)}° / ${_bleController.rssi} / ${_calculateRssi()}m',
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