import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'horizontal_barcode_scanner_platform_interface.dart';

/// An implementation of [HorizontalBarcodeScannerPlatform] that uses method channels.
class MethodChannelHorizontalBarcodeScanner extends HorizontalBarcodeScannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('horizontal_barcode_scanner');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
