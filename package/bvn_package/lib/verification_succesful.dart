import 'dart:io';

import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/back_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class VerificationSuccessful extends StatefulWidget {
  const VerificationSuccessful({super.key});

  @override
  State<VerificationSuccessful> createState() => _VerificationSuccessfulState();
}

class _VerificationSuccessfulState extends State<VerificationSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {},
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff755AE2))),
              child: const Text("Verify Now"),
            )),
        const SizedBox(height: 24)
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              const AppBackButton(),
              const SizedBox(height: 24),
              const Text("Your Identity is being verified.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  "Your identity is currently being verified. Please wait while we complete this process"),
              const SizedBox(
                height: 24,
              ),
              const Text("Tips", style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffEDE8FB)),
                    color: const Color(0xffFAFAFF),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            loadAsset("no_glass.png"),
                            width: 54,
                          ),
                          const SizedBox(height: 8),
                          const Text("No Glass",
                              style: TextStyle(color: Color(0xff755AE2)))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            loadAsset("no_mask.png"),
                            width: 54,
                          ),
                          const SizedBox(height: 8),
                          const Text("No Face Mask",
                              style: TextStyle(color: Color(0xff755AE2)))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Image.asset(
                            loadAsset("no_hat.png"),
                            width: 54,
                          ),
                          const SizedBox(height: 8),
                          const Text("No Hat",
                              style: TextStyle(color: Color(0xff755AE2)))
                        ],
                      ),
                    )
                  ],
                ),
              )
            ])),
      ),
    );
  }

  static Future<XFile> _compressImage(
      {required File file,
      required int compressQualityandroid,
      required int compressQualityiOS}) async {
    Directory tempDir = await getTemporaryDirectory();
    print(tempDir.path);
    String dir = "${tempDir.absolute.path}/test.jpeg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      dir,
      quality: TargetPlatform.iOS == defaultTargetPlatform
          ? compressQualityiOS
          : compressQualityandroid,
    );

    return result!;
  }
}
