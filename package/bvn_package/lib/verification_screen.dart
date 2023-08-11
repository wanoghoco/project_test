import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/bvn_selfie.dart';
import 'package:bvn_selfie/bvn_selfie_view.dart';
import 'package:bvn_selfie/progress_loader.dart';
import 'package:bvn_selfie/server/server.dart';
import 'package:flutter/material.dart';

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
          onImageCapture: (image) async {
            Navigator.pop(context);
            provider.destroyer();
            showProgressContainer(context);
            Map<String, dynamic> form = {
              "token": BVNPlugin.getBVN(),
              "type": "bvn"
            };
            var response = await Server(key: "").uploadFile(image, form);
            Navigator.pop(context);
            print(response);
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
