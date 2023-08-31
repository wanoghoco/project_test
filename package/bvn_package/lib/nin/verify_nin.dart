// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:raven_verification/app_data_helper.dart';
import 'package:raven_verification/back_button.dart';
import 'package:raven_verification/bvn/verification_succesful.dart';
import 'package:raven_verification/progress_loader.dart';
import 'package:raven_verification/server/server.dart';
import 'package:raven_verification/textstyle.dart';
import 'package:flutter/material.dart';

class VerifyNin extends StatefulWidget {
  const VerifyNin({super.key});

  @override
  State<VerifyNin> createState() => _VerifyNinState();
}

class _VerifyNinState extends State<VerifyNin> {
  final ninController = TextEditingController();

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
                  if ((VerificationPlugin.getClientNumber() == null ||
                      VerificationPlugin.getClientNumber().toString().length <
                          10)) {
                    showAlert("BVN not passed");
                    return;
                  }
                  if (ninController.text.length < 10) {
                    showAlert("please enter your NIN");
                    return;
                  }
                  if (VerificationPlugin.getmetaDataGetterUrl() != null) {
                    showProgressContainer(context);
                    var response = await Server(
                            key:
                                VerificationPlugin.getmetaDataGetterUrl() ?? "",
                            isFull: true)
                        .getRequest();
                    Navigator.pop(context);
                    if (response == "failed") {
                      showAlert("something went wrong... please try again");

                      return;
                    }

                    if (response['status'] != "success") {
                      showAlert(response['message']);
                    }
                    response = response;
                    VerificationPlugin.setMetaData(
                        jsonEncode(response['data'] ?? ""));
                  }

                  var response = await Server(key: "").postRequest({
                    "bvn": VerificationPlugin.getClientNumber(),
                    "nin": ninController.text
                  });
                  if (response.toString() == "failed") {
                    showAlert("something went wrong");
                    return;
                  }
                  if (response.toString() == "success") {
                    showAlert(response['message']);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationSuccessful(
                                  type: "NIN",
                                )));
                    return;
                  }
                  showAlert(response['message']);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor: MaterialStateProperty.all(
                        VerificationPlugin.getBaseColor())),
                child: Text(
                  "Proceed to verify",
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
                    Text("Verify Your NIN",
                        style: headling1.copyWith(
                          fontSize: 20,
                          color: VerificationPlugin.getBaseColor(),
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 8),
                    Text(
                        "We need your NIN so you can get verified on Raven bank",
                        style:
                            subtitle.copyWith(color: const Color(0xff8B8B8B))),
                    const SizedBox(
                      height: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Provide Your NIN",
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
                            controller: ninController,
                            decoration: InputDecoration(
                                hintText: "Enter your NIN here...",
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
                  ])),
        ),
      ),
    );
  }
}
