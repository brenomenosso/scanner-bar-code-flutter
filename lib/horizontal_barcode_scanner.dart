import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'horizontal_barcode_scanner_platform_interface.dart';
import 'src/scanner_page.dart';
export 'package:camera/camera.dart';

class HorizontalBarcodeScanner {
  Future<String?> getPlatformVersion() {
    return HorizontalBarcodeScannerPlatform.instance.getPlatformVersion();
  }

  static void open({
    required BuildContext context,
    required void Function(String code) onSuccess,
    required void Function(String error) onError,
    required void Function() onCancel,
    ResolutionPreset cameraResolution = ResolutionPreset.high,
    String label = 'Point the barcode at the scanner',
    double labelSize = 14,
    String goBackLabel = 'Leave scanner',
    String flashLightLabel = 'Flashlight',
    bool showLine = true,
    Color lineColor = Colors.blue,
    double lineWidth = 2,
    double scannerHeight = 160,
    Widget loadingWidget = const Text(
      'Loading...',
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
    ),
  }) async {
    final Object? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannerPage(
          cameraResolution: cameraResolution,
          formats: const [
            BarcodeFormat.itf,
            BarcodeFormat.codabar,
          ],
          showLine: showLine,
          lineColor: lineColor,
          lineWidth: lineWidth,
          label: label,
          labelSize: labelSize,
          goBackLabel: goBackLabel,
          flashLightLabel: flashLightLabel,
          scannerHeight: scannerHeight,
          loadingWidget: loadingWidget,
        ),
      ),
    );
    if (result != null) {
      if (result is String) {
        onSuccess(result);
      } else {
        onError('Error processing barcode.');
      }
    } else {
      onCancel();
    }
  }
}
