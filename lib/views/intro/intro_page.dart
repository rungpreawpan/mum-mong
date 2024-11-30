import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seeable/controller/app_info_controller.dart';
import 'package:seeable/views/home/home_page.dart';
import 'package:seeable/views/intro/controller/intro_controller.dart';
import 'package:seeable/views/intro/template/intro_template.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final AppInfoController _appInfoController = Get.find();
  final IntroController _introController = Get.put(IntroController());

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  _content() {
    return Obx(() {
      switch (_introController.currentPage.value) {
        case 0:
          return IntroTemplate(
            isWelcomePage: true,
            icon: Icons.home_filled,
            description: 'Welcome to Seeable',
            next: _welcome,
            back: () {},
          );
        case 1:
          return IntroTemplate(
            icon: Icons.camera_alt_rounded,
            description: 'camera',
            next: _cameraPermission,
            back: () {
              _introController.currentPage(0);
            },
          );

        case 2:
          return IntroTemplate(
            icon: Icons.mic_rounded,
            description: 'microphone',
            next: _micPermission,
            back: () {
              _introController.currentPage(1);
            },
          );

        case 3:
          return IntroTemplate(
            icon: Icons.record_voice_over_rounded,
            description: 'speech to text',
            next: _speechToTextPermission,
            back: () {
              _introController.currentPage(2);
            },
          );

        case 4:
          return IntroTemplate(
            icon: Icons.accessibility_new_rounded,
            description: 'accessibility',
            next: _accessibilityPermission,
            back: () {
              _introController.currentPage(3);
            },
          );

        case 5:
          return IntroTemplate(
            icon: Icons.location_pin,
            description: 'location',
            next: _locationPermission,
            back: () {
              _introController.currentPage(4);
            },
          );

        case 6:
          return IntroTemplate(
            icon: Icons.bluetooth,
            description: 'bluetooth',
            next: _bluetoothPermission,
            back: () {
              _introController.currentPage(5);
            },
          );

        default:
          return Container();
      }
    });
  }

  _welcome() async {
    _introController.currentPage(1);
  }

  _cameraPermission() async {
    var result = await Permission.camera.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.cameraGranted(true);
    } else {
      _appInfoController.cameraGranted(false);
    }

    _introController.currentPage(2);
  }

  _micPermission() async {
    var result = await Permission.microphone.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.micGranted(true);
    } else {
      _appInfoController.micGranted(false);
    }

    _introController.currentPage(3);
  }

  _speechToTextPermission() async {
    var result = await Permission.speech.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.speechToTextGranted(true);
    } else {
      _appInfoController.speechToTextGranted(false);
    }

    _introController.currentPage(4);
  }

  _accessibilityPermission() async {
    var result = await Permission.assistant.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.accessibilityGranted(true);
    } else {
      _appInfoController.accessibilityGranted(false);
    }

    _introController.currentPage(5);
  }

  _locationPermission() async {
    var result = await Permission.assistant.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.accessibilityGranted(true);
    } else {
      _appInfoController.accessibilityGranted(false);
    }

    _introController.currentPage(6);
  }

  _bluetoothPermission() async {
    var result = await Permission.assistant.request();

    if (result == PermissionStatus.granted) {
      _appInfoController.accessibilityGranted(true);
    } else {
      _appInfoController.accessibilityGranted(false);
    }

    await storage.write(key: 'intro', value: 'true');
    Get.offAll(() => const HomePage());
  }
}
