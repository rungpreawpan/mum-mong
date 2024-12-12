import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BleController extends GetxController {
  var isLoading = false.obs;
  var isScanning = false.obs;

  RxList<ScanResult> deviceList = <ScanResult>[].obs;
  List favoriteList = [];

  scanDevices() async {
    if (kDebugMode) {
      print('start scan');
    }

    isScanning.value = true;

    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          deviceList.value = results
              .where((e) {
                if (e.device.platformName.contains('Ruuvi')) {
                  print(
                      '${e.device.remoteId} ${e.device.platformName} ${e.rssi}');
                }
                return e.device.platformName.contains('Ruuvi');
              })
              .map((e) => e)
              .toList();
        }
      },
      onError: (e) {
        log(e);
      },
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 3),
    );

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    isScanning.value = false;
  }

  clear() {
    favoriteList.clear();
    deviceList.clear();
  }
}
