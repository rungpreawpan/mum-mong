import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BleController extends GetxController {
  var isLoading = false.obs;
  var isScanning = false.obs;

  RxList<ScanResult> deviceList = <ScanResult>[].obs;
  List favoriteList = [];

  // RxInt rssi1Avg = 0.obs;
  // RxInt rssi2Avg = 0.obs;
  // RxInt rssi3Avg = 0.obs;
  // RxInt rssi4Avg = 0.obs;
  // RxInt rssi5Avg = 0.obs;

  // List<int> rssi1List = [];
  // List<int> rssi2List = [];
  // List<int> rssi3List = [];
  // List<int> rssi4List = [];
  // List<int> rssi5List = [];

  double? calculateX;
  double? calculateY;

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
                  if (kDebugMode) {
                    print(
                        '${e.device.remoteId} ${e.device.platformName} ${e.rssi}');
                  }
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

  connectDevice(BluetoothDevice device) async {
    await device.connect();

    if (kDebugMode) {
      print('Connected to ${device.platformName}');
    }
  }

  calculateRssi(
    RxList<ScanResult> deviceList,
    BluetoothDevice destination,
  ) async {
    if (destination.platformName == 'Ruuvi 2559') {
      //2559 869D 30E9
      var topRightDevice = deviceList
          .firstWhere((item) => item.device.platformName == 'Ruuvi 2559');
      var topLeftDevice = deviceList
          .firstWhere((item) => item.device.platformName == 'Ruuvi BAAD');
      var bottomRightDevice = deviceList
          .firstWhere((item) => item.device.platformName == 'Ruuvi 862F');
      var bottomLeftDevice = deviceList
          .firstWhere((item) => item.device.platformName == 'Ruuvi 30E9');

      int topRightRssiAvg = 0;
      int topLeftRssiAvg = 0;
      int bottomRightRssiAvg = 0;
      int bottomLeftRssiAvg = 0;

      double topRightDistance = 0;
      double topLeftDistance = 0;
      double bottomRightDistance = 0;
      double bottomLeftDistance = 0;

      List<int> topRightRssi = [];
      if (topRightRssi.length >= 20) {
        topRightRssi.removeAt(0);
      }
      topRightRssi.add(topRightDevice.rssi);
      topRightRssiAvg =
          (topRightRssi.reduce((a, b) => a + b) / topRightRssi.length).toInt();
      topRightDistance = await calDistance(topRightRssiAvg);
      print('topRightRssiAvg $topRightRssiAvg');
      print('topRightDistance $topRightDistance');

      List<int> topLeftRssi = [];
      if (topLeftRssi.length >= 20) {
        topLeftRssi.removeAt(0);
      }
      topLeftRssi.add(topLeftDevice.rssi);
      topLeftRssiAvg =
          (topLeftRssi.reduce((a, b) => a + b) / topLeftRssi.length).toInt();
      topLeftDistance = await calDistance(topLeftRssiAvg);
      print('topLeftRssiAvg $topLeftRssiAvg');
      print('topLeftDistance $topLeftDistance');

      List<int> bottomRightRssi = [];
      if (bottomRightRssi.length >= 20) {
        bottomRightRssi.removeAt(0);
      }
      bottomRightRssi.add(bottomRightDevice.rssi);
      bottomRightRssiAvg =
          (bottomRightRssi.reduce((a, b) => a + b) / bottomRightRssi.length)
              .toInt();
      bottomRightDistance = await calDistance(bottomRightRssiAvg);
      print('bottomRightRssiAvg $bottomRightRssiAvg');
      print('bottomRightDistance $bottomRightDistance');

      List<int> bottomLeftRssi = [];
      if (bottomLeftRssi.length >= 20) {
        bottomLeftRssi.removeAt(0);
      }
      bottomLeftRssi.add(bottomLeftDevice.rssi);
      bottomLeftRssiAvg =
          (bottomLeftRssi.reduce((a, b) => a + b) / bottomLeftRssi.length)
              .toInt();
      bottomLeftDistance = await calDistance(bottomLeftRssiAvg);
      print('bottomLeftRssiAvg $bottomLeftRssiAvg');
      print('bottomLeftDistance $bottomLeftDistance');

      double x1 = 0.0, y1 = 0.0, d1 = bottomLeftDistance;
      double x2 = 3.3, y2 = 1.25, d2 = bottomRightDistance;
      double x3 = 0.0, y3 = 2.6, d3 = topLeftDistance;
      double x4 = 2.65, y4 = 2.6, d4 = topRightDistance;

      triangulate2D(
        x1: x1,
        x2: x2,
        x3: x3,
        y1: y1,
        y2: y2,
        y3: y3,
        d1: d1,
        d2: d2,
        d3: d3,
      );

      multilateration2D(
        x1: x1,
        x2: x2,
        x3: x3,
        x4: x4,
        y1: y1,
        y2: y2,
        y3: y3,
        y4: y4,
        d1: d1,
        d2: d2,
        d3: d3,
        d4: d4,
      );
    }
  }

  getRssi({
    required BluetoothDevice device,
    required RxInt rssiAvg,
    required List<int> rssiList,
  }) async {
    int rssi = await device.readRssi(timeout: 1);

    if (rssiList.length >= 20) {
      rssiList.removeAt(0);
    }
    rssiList.add(rssi);
    rssiAvg.value =
        (rssiList.reduce((a, b) => a + b) / rssiList.length).toInt();
  }

  calDistance(int rssiAvg) async {
    // Distance = 10 ^ ((Measured Power -RSSI)/(10 * N))
    double distance = pow(10, (-69 - rssiAvg) / (10 * 3)).toDouble();

    return double.parse(distance.toStringAsFixed(2));
  }

  triangulate2D({
    required double x1,
    required double x2,
    required double x3,
    required double y1,
    required double y2,
    required double y3,
    required double d1,
    required double d2,
    required double d3,
  }) async {
    if (deviceList.length < 3) {
      return null;
    }

    double A1 = 2 * (x1 - x2);
    double B1 = 2 * (y1 - y2);
    double C1 = (pow(d2, 2) -
            pow(d1, 2) +
            pow(x1, 2) -
            pow(x2, 2) +
            pow(y1, 2) -
            pow(y2, 2))
        .toDouble();

    double A2 = 2 * (x1 - x3);
    double B2 = 2 * (y1 - y3);
    double C2 = (pow(d3, 2) -
            pow(d1, 2) +
            pow(x1, 2) -
            pow(x3, 2) +
            pow(y1, 2) -
            pow(y3, 2))
        .toDouble();

    // det = A1*B2 - B1*A2
    double denominator = (A1 * B2) - (B1 * A2);

    if (denominator.abs() < 1e-10) {
      print('determinant is zero or near zero');
      return null;
    }

    // Cramer's Rule
    // x = (C1*B2 - B1*C2) / (A1*B2 - B1*A2)
    // y = (A1*C2 - C1*A2) / (A1*B2 - B1*A2)
    double x = (C1 * B2 - B1 * C2) / denominator;
    double y = (A1 * C2 - C1 * A2) / denominator;

    print('triangulate2D x:$x y:$y');
  }

  multilateration2D({
    required double x1,
    required double x2,
    required double x3,
    required double x4,
    required double y1,
    required double y2,
    required double y3,
    required double y4,
    required double d1,
    required double d2,
    required double d3,
    required double d4,
  }) async {
    if (deviceList.length < 4) {
      return null;
    }

    List<Anchor2D> anchors = [
      Anchor2D(x1, y1),
      Anchor2D(x2, y2),
      Anchor2D(x3, y3),
      Anchor2D(x4, y4),
    ];

    List<double> distances = [
      d1,
      d2,
      d3,
      d4,
    ];

    final int n = anchors.length;
    final Anchor2D refAnchor = anchors[n - 1];
    final double refDistance = distances[n - 1];

    // Matrix A, vector b
    List<List<double>> A = [];
    List<double> b = [];

    for (int i = 0; i < n - 1; i++) {
      final Anchor2D anchor = anchors[i];
      final double distance = distances[i];

      // linearization
      // A_i = -2 (x_i - x_n)
      // B_i = -2 (y_i - y_n)
      // C_i = d^2 - d_n^2 - (x_i^2 + y_i^2 - x_n^2 - y_n^2)
      double Ai = -2.0 * (anchor.x - refAnchor.x);
      double Bi = -2.0 * (anchor.y - refAnchor.y);
      double Ci = (pow(distance, 2) -
              pow(refDistance, 2) -
              (pow(anchor.x, 2) +
                  pow(anchor.y, 2) -
                  pow(refAnchor.x, 2) -
                  pow(refAnchor.y, 2)))
          .toDouble();

      A.add([Ai, Bi]);
      b.add(Ci);

      // print('A $A');
      // print('b $b');
    }

    // change A, b to Matrix
    // x = (A^T A)^{-1} A^T b
    final result = _solveLeastSquares(A, b);
    if (result == null) {
      return null;
    }

    final double x = result[0];
    final double y = result[1];

    //TODO
    calculateX = x;
    calculateY = y;

    print('multilateration2D x:$x y:$y');
  }

  // Least Squares x = (A^T A)^{-1} A^T b
  // A = m x 2, b = m x 1 (m >= 2)
  List<double>? _solveLeastSquares(List<List<double>> A, List<double> b) {
    final m = A.length; // equation length
    if (m == 0) {
      return null;
    }

    final n = A[0].length; // = 2 (2D)

    // A^T A -> n x n (2 x 2)
    // A^T b -> n x 1 (2 x 1)
    // calculate A^T
    List<List<double>> AT = List.generate(n, (_) => List.filled(m, 0.0));
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        AT[j][i] = A[i][j];
      }
    }

    // calculate A^T A (2 x 2)
    List<List<double>> ATA = List.generate(n, (_) => List.filled(n, 0.0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        double sum = 0.0;
        for (int k = 0; k < m; k++) {
          sum += AT[i][k] * A[k][j];
        }
        ATA[i][j] = sum;
      }
    }

    // calculate A^T b (2 x 1)
    List<double> ATb = List.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      double sum = 0.0;
      for (int k = 0; k < m; k++) {
        sum += AT[i][k] * b[k];
      }
      ATb[i] = sum;
    }

    // find (A^T A)^{-1} * (A^T b)
    // แต่ (A^T A) เป็น 2x2 => เราหาอินเวิร์สได้ง่ายโดยสูตรดีเทอร์มิแนนต์
    double det = ATA[0][0] * ATA[1][1] - ATA[0][1] * ATA[1][0];
    if (det.abs() < 1e-12) {
      print('det is zero or near zero');
      return null;
    }

    double inv00 = ATA[1][1] / det;
    double inv01 = -ATA[0][1] / det;
    double inv10 = -ATA[1][0] / det;
    double inv11 = ATA[0][0] / det;

    // (A^T A)^{-1} (A^T b) => 2x2 dot 2x1 => 2x1
    double x = inv00 * ATb[0] + inv01 * ATb[1];
    double y = inv10 * ATb[0] + inv11 * ATb[1];

    return [x, y];
  }

  disconnectDevice(BluetoothDevice device) async {
    await device.disconnect();

    if (kDebugMode) {
      print('Disconnected to ${device.platformName}');
    }
  }

  clearDevice() {
    favoriteList.clear();
    deviceList.clear();
  }

// clearRssi() {
//   rssi1Avg = 0.obs;
//   rssi2Avg = 0.obs;
//   rssi3Avg = 0.obs;
//   rssi4Avg = 0.obs;
//   rssi5Avg = 0.obs;
//   rssi1List.clear();
//   rssi2List.clear();
//   rssi3List.clear();
//   rssi4List.clear();
//   rssi5List.clear();
// }
}

class Point2D {
  final double x;
  final double y;

  Point2D(
    this.x,
    this.y,
  );

  @override
  String toString() => '($x, $y)';
}

class Anchor2D {
  final double x;
  final double y;

  Anchor2D(
    this.x,
    this.y,
  );

  @override
  String toString() => '($x, $y)';
}
