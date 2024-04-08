import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'horizontal_barcode_scanner_method_channel.dart';

abstract class HorizontalBarcodeScannerPlatform extends PlatformInterface {
  /// Constructs a HorizontalBarcodeScannerPlatform.
  HorizontalBarcodeScannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static HorizontalBarcodeScannerPlatform _instance = MethodChannelHorizontalBarcodeScanner();

  /// The default instance of [HorizontalBarcodeScannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelHorizontalBarcodeScanner].
  static HorizontalBarcodeScannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HorizontalBarcodeScannerPlatform] when
  /// they register themselves.
  static set instance(HorizontalBarcodeScannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
