import 'package:get/get.dart';
import 'package:seeable/localization/en.dart';
import 'package:seeable/localization/th.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'th': th,
  };
}