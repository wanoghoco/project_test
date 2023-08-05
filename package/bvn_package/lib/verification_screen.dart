import 'package:bvn_selfie/bvn_selfie.dart';
import 'package:bvn_selfie/bvn_selfie_view.dart';
import 'package:bvn_selfie/onFinished.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late BvnServiceProvider provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BvnSelfieView(
          allowTakePhoto: false,
          onImageCapture: (image) {
            print(image);
            provider.destroyer();
            Get.off(OnFinishedScreen(path: image));
          },
          onError: (String errorLog) {
            print(errorLog);
          },
          onInit: (BvnServiceProvider provider) {
            this.provider = provider;
          },
        ));
  }
}
