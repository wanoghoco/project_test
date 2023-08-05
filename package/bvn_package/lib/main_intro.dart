import 'package:bvn_selfie/back_button.dart';
import 'package:bvn_selfie/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MainIntro extends StatefulWidget {
  const MainIntro({super.key});

  @override
  State<MainIntro> createState() => _MainIntroState();
}

class _MainIntroState extends State<MainIntro> {
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
                Get.to(const VerificationScreen());
              },
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
              const Text("Take a clear selfie.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  "We need your BVN so you can get verified on Raven bank"),
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

  String loadAsset(String asset) {
    return "packages/bvn_selfie/asset/$asset";
  }
}
