import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'torch_button.dart';

class TransparentHole extends StatelessWidget {
  const TransparentHole({
    super.key,
    required this.cameraController,
    required this.showLine,
    required this.lineColor,
    required this.lineWidth,
    required this.label,
    required this.labelSize,
    required this.goBackLabel,
    required this.flashLightLabel,
    required this.scannerHeight,
  });
  final CameraController cameraController;
  final bool showLine;
  final Color lineColor;
  final double lineWidth;
  final String label;
  final double labelSize;
  final String goBackLabel;
  final String flashLightLabel;
  final double scannerHeight;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width - 60;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: HolePainter(
              scannerHeight: scannerHeight,
            ),
          ),
        ),
        Center(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: scannerHeight + 32,
                left: 30,
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: labelSize,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BackButton(),
                  Text(
                    goBackLabel,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    flashLightLabel,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  TorchButton(
                    cameraController: cameraController,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showLine)
          Container(
            width: width,
            height: lineWidth,
            color: lineColor,
          ),
      ],
    );
  }
}

class HolePainter extends CustomPainter {
  const HolePainter({required this.scannerHeight});
  final double scannerHeight;
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width - 40;

    final Rect rect =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));

    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: rect.center,
        width: width,
        height: scannerHeight,
      ),
      const Radius.circular(12),
    );

    final Path transparentHole = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()..addRRect(roundedRect),
    );

    canvas.drawPath(
      transparentHole,
      Paint()..color = Colors.black.withOpacity(0.7),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
