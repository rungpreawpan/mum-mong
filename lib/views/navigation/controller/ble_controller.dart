import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BleController extends GetxController {
  var isLoading = false.obs;
  var isScanning = false.obs;

  RxList<ScanResult> deviceList = <ScanResult>[].obs;
  List favoriteList = [];
  int? rssi;

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
      timeout: const Duration(seconds: 5),
    );

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    isScanning.value = false;
  }

  connectDevice(BluetoothDevice device) async {
    await device.connect();

    if (kDebugMode) {
      print('Connected to ${device.platformName}');
    }
  }

  readRssi(BluetoothDevice device) async {
    rssi = await device.readRssi(timeout: 1);
  }

  disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();

    if (kDebugMode) {
      print('Disconnected to ${device.platformName}');
    }
  }

  clear() {
    favoriteList.clear();
    deviceList.clear();
  }
}
