import 'package:firebase_analytics/firebase_analytics.dart';

setLogEvent(String logLabel) async {
  await FirebaseAnalytics.instance.logEvent(name: logLabel);
}
