// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/bvn_selfie.dart';
import 'package:bvn_selfie/bvn_selfie_view.dart';
import 'package:bvn_selfie/progress_loader.dart';
import 'package:bvn_selfie/server/server.dart';
import 'package:bvn_selfie/verification_succesful.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late BvnServiceProvider provider;
  @override
  Widget build(BuildContext appContext) {
    return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: BvnSelfieView(
          allowTakePhoto: false,
          onImageCapture: (imagePath) async {
            showProgressContainer(appContext);
            provider.destroyer();
            Map<String, dynamic> form = {
              "token": BVNPlugin.getBVN(),
              "type": "bvn"
            };
            String filePath = (await compressImage(file: File(imagePath))).path;
            var response = await Server(key: "").uploadFile(filePath, form);
            Navigator.pop(appContext);
            try {
              Fluttertoast.showToast(
                  msg: response['message'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: BVNPlugin.getBaseColor(),
                  textColor: Colors.white,
                  fontSize: 16.0);
              if (response['status'] == "success") {
                Navigator.push(
                    appContext,
                    MaterialPageRoute(
                        builder: (context) => const VerificationSuccessful()));
                return;
              }
              Navigator.pop(context);
            } catch (ex) {}
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

class _compressImage {}
