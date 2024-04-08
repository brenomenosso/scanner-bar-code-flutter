import 'package:flutter_test/flutter_test.dart';
import 'package:horizontal_barcode_scanner/horizontal_barcode_scanner.dart';
import 'package:horizontal_barcode_scanner/horizontal_barcode_scanner_platform_interface.dart';
import 'package:horizontal_barcode_scanner/horizontal_barcode_scanner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHorizontalBarcodeScannerPlatform
    with MockPlatformInterfaceMixin
    implements HorizontalBarcodeScannerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final HorizontalBarcodeScannerPlatform initialPlatform = HorizontalBarcodeScannerPlatform.instance;

  test('$MethodChannelHorizontalBarcodeScanner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHorizontalBarcodeScanner>());
  });

  test('getPlatformVersion', () async {
    HorizontalBarcodeScanner horizontalBarcodeScannerPlugin = HorizontalBarcodeScanner();
    MockHorizontalBarcodeScannerPlatform fakePlatform = MockHorizontalBarcodeScannerPlatform();
    HorizontalBarcodeScannerPlatform.instance = fakePlatform;

    expect(await horizontalBarcodeScannerPlugin.getPlatformVersion(), '42');
  });
}
