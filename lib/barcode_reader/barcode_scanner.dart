import 'package:bvn_selfie/back_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:project_test/barcode_reader/barcode_custom_paint.dart';
import 'package:project_test/barcode_reader/raven_camera_view.dart';

class BarCodeScanner extends StatefulWidget {
  const BarCodeScanner({super.key});

  @override
  State<BarCodeScanner> createState() => _BarCodeScannerState();
}

class _BarCodeScannerState extends State<BarCodeScanner> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  ValueNotifier nt = ValueNotifier("");
  String? text;
  final _cameraLensDirection = CameraLensDirection.back;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const AppBackButton(),
            const SizedBox(height: 20),
            const Text("Barcode Scanner ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("move camera close to barcode to retrieve encoded data"),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: size.width * 0.8,
                        width: size.width * 0.8,
                        child: CameraView(
                          onImage: _processImage,
                          customPaint: _customPaint,
                        )),
                    const SizedBox(height: 40),
                    ValueListenableBuilder(
                        valueListenable: nt,
                        builder: (context, widget, child) {
                          return Text(nt.value,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black));
                        })
                  ]),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      text = '';
    });
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = BarcodeDetectorPainter(
        barcodes,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      if (barcodes.isNotEmpty) {
        nt.value = 'Barcodes found: ${barcodes[0].displayValue}\n\n';
      }
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Barcodes found: ${barcodes.length}\n\n';
      for (final barcode in barcodes) {
        text += 'Barcode: ${barcode.rawValue}\n\n';
      }
      print(text);
      text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
