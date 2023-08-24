// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bvn_selfie/app_data_helper.dart';
import 'package:bvn_selfie/progress_loader.dart';
import 'package:bvn_selfie/server/server.dart';
import 'package:bvn_selfie/textstyle.dart';
import 'package:bvn_selfie/verification_screen.dart';
import 'package:bvn_selfie/verification_succesful.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageViewScreen extends StatefulWidget {
  final String imagePath;
  const ImageViewScreen({super.key, required this.imagePath});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    onVerify();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      backgroundColor:
                          MaterialStateProperty.all(BVNPlugin.getBaseColor())),
                  child: Text(
                    "Use this selfie",
                    style: subtitle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )),
            const SizedBox(height: 24),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationScreen()));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      backgroundColor:
                          MaterialStateProperty.all(BVNPlugin.getBaseColor())),
                  child: Text(
                    "Re-take selfie",
                    style: subtitle.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                )),
            const SizedBox(height: 24)
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(children: [
          const SizedBox(height: 24),
          Text("Take a clear selfie", style: headling1.copyWith(fontSize: 20)),
          const SizedBox(
            height: 8,
          ),
          Text(
              "Ensure that your entire face is clearly visible within the provided frame.",
              style: subtitle.copyWith(fontSize: 14)),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
              height: size.height * 0.4,
              width: double.infinity,
              child: Image.file(File(widget.imagePath))),
          const SizedBox(
            height: 16,
          ),
          Text("Is this clear enough?", style: bodyText.copyWith()),
          Text(
              "Make sure your face is clear enough and the photo is not blurry",
              style: subtitle.copyWith()),
          const SizedBox(
            height: 16,
          ),
        ]),
      ),
    );
  }

  onVerify() async {
    showProgressContainer(context);

    Map<String, dynamic> form = {"token": BVNPlugin.getBVN(), "type": "bvn"};
    String filePath = (await compressImage(file: File(widget.imagePath))).path;
    var response = await Server(key: "").uploadFile(filePath, form);
    Navigator.pop(context);
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
            context,
            MaterialPageRoute(
                builder: (context) => const VerificationSuccessful()));
        return;
      }
      Navigator.pop(context);
    } catch (ex) {}
  }
}
