import 'dart:io';

import 'package:bvn_selfie/back_button.dart';
import 'package:bvn_selfie/main_intro.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class OnFinishedScreen extends StatefulWidget {
  final String path;
  const OnFinishedScreen({super.key, required this.path});

  @override
  State<OnFinishedScreen> createState() => _OnFinishedScreenState();
}

class _OnFinishedScreenState extends State<OnFinishedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.to(const MainIntro());
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff755AE2))),
              child: const Text("Use This Photo"),
            )),
        const SizedBox(height: 24)
      ]),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              const AppBackButton(),
              const SizedBox(height: 24),
              Image.file(File(widget.path))
            ])),
      ),
    );
  }
}
