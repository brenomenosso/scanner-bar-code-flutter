import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'barcode_utils.dart';
import 'transparent_hole.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({
    super.key,
    required this.cameraResolution,
    required this.formats,
    required this.showLine,
    required this.lineColor,
    required this.lineWidth,
    required this.label,
    required this.labelSize,
    required this.goBackLabel,
    required this.flashLightLabel,
    required this.scannerHeight,
    required this.loadingWidget,
  });
  final ResolutionPreset cameraResolution;
  final List<BarcodeFormat> formats;
  final bool showLine;
  final Color lineColor;
  final double lineWidth;
  final String label;
  final double labelSize;
  final String goBackLabel;
  final String flashLightLabel;
  final double scannerHeight;
  final Widget loadingWidget;
  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  CameraController? _cameraController;
  BarcodeScanner? _barcodeScanner;
  CameraDescription? _firstCamera;
  bool _done = false;
  int _frameCounter = 0;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final sensorOrientation = _firstCamera!.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (_firstCamera!.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  _processCameraImage(BuildContext ctx, CameraImage image) async {
    if (_frameCounter++ % 3 != 0) return;
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      return;
    }
    final barcodes = await _barcodeScanner!.processImage(inputImage);
    if (barcodes.isEmpty) {
      return;
    }
    for (final barcode in barcodes) {
      if (barcode.displayValue == null ||
          barcode.displayValue!.length != 44 ||
          barcode.displayValue!.endsWith('0' * 20)) {
        continue;
      }
      if (mounted && Navigator.canPop(context)) {
        log('CAPTUROU O CODIGO');
        _done = true;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        if (Platform.isIOS) _setOrientacionVertical();
        final codeString =
            BarcodeUtils.getFormattedbarcode(barcode.displayValue!);
        Navigator.pop(ctx, codeString);
      }
    }
  }

  _initializeCamera(BuildContext ctx) async {
    await Future.delayed(const Duration(seconds: 2));
    final cameras = await availableCameras();
    log(cameras.toString());
    if (cameras.isEmpty) return;
    _firstCamera = cameras.first;
    _cameraController = CameraController(
      _firstCamera!,
      widget.cameraResolution,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _cameraController!.initialize().then((_) {
      if (!mounted) {
        log('FECHOU INITIALIZER');
        return;
      }
      _cameraController!.startImageStream((image) {
        if (_done) {
          log('FECHOU START IMAGE STREAM');
          return;
        }
        try {
          _processCameraImage(ctx, image);
        } catch (e) {
          log('horizontal_barcode_scanner [Error]: $e');
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context, 0);
          }
        }
      });
      setState(() {});
    });
  }

  _setOrientacionVertical () {
    SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp
    ]);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializeCamera(context);
    _barcodeScanner = BarcodeScanner(
      formats: widget.formats,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        return Future.value(true);
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: _cameraController == null ||
                  !_cameraController!.value.isInitialized
              ? Center(
                  child: widget.loadingWidget,
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraController!),
                    TransparentHole(
                      cameraController: _cameraController!,
                      showLine: widget.showLine,
                      lineColor: widget.lineColor,
                      lineWidth: widget.lineWidth,
                      label: widget.label,
                      labelSize: widget.labelSize,
                      goBackLabel: widget.goBackLabel,
                      flashLightLabel: widget.flashLightLabel,
                      scannerHeight: widget.scannerHeight,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _setOrientacionVertical();
    _barcodeScanner?.close();
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
  }
}
