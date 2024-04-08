import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TorchButton extends StatefulWidget {
  const TorchButton({
    super.key,
    required this.cameraController,
  });
  final CameraController cameraController;
  @override
  State<TorchButton> createState() => _TorchButtonState();
}

class _TorchButtonState extends State<TorchButton> {
  bool _isTorchOn = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          _isTorchOn = !_isTorchOn;
        });
        widget.cameraController.setFlashMode(
          _isTorchOn ? FlashMode.torch : FlashMode.off,
        );
      },
      icon: Icon(
        _isTorchOn ? Icons.flash_off : Icons.flash_on,
      ),
    );
  }
}
