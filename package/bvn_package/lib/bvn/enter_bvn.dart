import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/verification_screen.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EnterBVNScreen extends StatefulWidget {
  const EnterBVNScreen({super.key});

  @override
  State<EnterBVNScreen> createState() => _EnterBVNScreenState();
}

class _EnterBVNScreenState extends State<EnterBVNScreen> {
  final bvnController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {});
                  if ((VerificationPlugin.getBVN() == null ||
                          VerificationPlugin.getBVN().toString().length < 10) &&
                      bvnController.text.length < 10) {
                    Fluttertoast.showToast(
                        msg: "Please enter your BVN",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: VerificationPlugin.getBaseColor(),
                        textColor: Colors.white,
                        fontSize: 16.0);
                    return;
                  }
                  if ((VerificationPlugin.getBVN() == null ||
                      VerificationPlugin.getBVN().toString().length < 10)) {
                    VerificationPlugin.setBVN(bvnController.text);
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VerificationScreen()));
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Continue to verify",
                  style: subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              )),
          const SizedBox(height: 34)
        ]),
        body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    const AppBackButton(),
                    const SizedBox(height: 24),
                    Text("Take a clear selfie.",
                        style: headling1.copyWith(
                          fontSize: 20,
                          color: VerificationPlugin.getBaseColor(),
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    Text(
                        "We need your BVN so you can get verified on Raven bank",
                        style:
                            subtitle.copyWith(color: const Color(0xff8B8B8B))),
                    const SizedBox(
                      height: 24,
                    ),
                    if (VerificationPlugin.getBVN() == null ||
                        VerificationPlugin.getBVN().toString().length < 10) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Provide Your BVN",
                                  style: subtitle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          const Color.fromARGB(255, 78, 78, 78),
                                      fontSize: 14)),
                              Text(" *",
                                  style: subtitle.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red,
                                      fontSize: 14)),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          TextField(
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                              keyboardType: TextInputType.number,
                              controller: bvnController,
                              decoration: InputDecoration(
                                  hintText: "Enter your BVN here...",
                                  hintStyle:
                                      subtitle.copyWith(color: Colors.grey),
                                  fillColor: const Color(0xFFF4F4F4),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFF4F4F4), width: 0)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFF4F4F4), width: 0)),
                                  border: InputBorder.none)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 34),
                    Text("Tips",
                        style: subtitle.copyWith(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xffEDE8FB)),
                          color: const Color(0xffFAFAFF),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Item(
                            asset: "no_glass.png",
                            title: "No glass",
                          ),
                          Item(
                            asset: "no_mask.png",
                            title: "No face mask",
                          ),
                          Item(
                            asset: "no_hat.png",
                            title: "No hat",
                          ),
                        ],
                      ),
                    )
                  ])),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  final String asset;
  final String title;
  const Item({super.key, required this.asset, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                loadAsset(asset),
                color: VerificationPlugin.getBaseColor(),
                height: 54,
                width: 54,
              ),
              Image.asset(
                loadAsset("no.png"),
                height: 54,
                width: 54,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title,
              style: subtitle.copyWith(
                  color: VerificationPlugin.getBaseColor(), fontSize: 13))
        ],
      ),
    );
  }
}