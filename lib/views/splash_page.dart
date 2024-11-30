import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:seeable/constant/value_constant.dart';
import 'package:seeable/controller/app_info_controller.dart';
import 'package:seeable/views/home/home_page.dart';
import 'package:seeable/views/intro/intro_page.dart';
import 'package:seeable/widgets/text_font_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppInfoController _appInfoController = Get.put(AppInfoController());

  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _checkFirstRun();
    _redirect();
  }

  _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('first_run') ?? true) {
      await storage.deleteAll();

      prefs.setBool('first_run', false);
    }
  }

  _redirect() async {
    await _appInfoController.getDeviceInfo();
    await Future.delayed(const Duration(seconds: 2));

    String? intro = await storage.read(key: 'intro');

    if (intro == null) {
      Get.off(() => const IntroPage());
    } else {
      Get.off(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo(),
              const SizedBox(height: marginX2),
              _appVersion(),
            ],
          ),
        ),
      ),
    );
  }

  _logo() {
    return Container(
      color: Colors.grey,
      width: 100,
      height: 100,
    );
  }

  _appVersion() {
    return Obx(() {
      return TextFontStyle(
        'v ${_appInfoController.appVersion.value}',
        size: fontSizeM,
        color: Colors.white,
        weight: FontWeight.bold,
      );
    });
  }
}
