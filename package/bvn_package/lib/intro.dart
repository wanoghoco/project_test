import 'package:bvn_selfie/back_button.dart';
import 'package:bvn_selfie/main_intro.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class IntroBvnPage extends StatefulWidget {
  const IntroBvnPage({super.key});

  @override
  State<IntroBvnPage> createState() => _IntroBvnPageState();
}

class _IntroBvnPageState extends State<IntroBvnPage> {
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
              child: const Text("Proceed"),
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
              const Text("Enter your BVN ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  "We need your BVN so you can get verified on Raven bank"),
              const SizedBox(
                height: 24,
              ),
              const ProjectTextField(),
              const SizedBox(height: 24),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffEDE8FB)),
                      color: const Color(0xffFAFAFF),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xff755AE2)),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Why do we need your bvn?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff755AE2))),
                                SizedBox(height: 8),
                                Text(
                                    "Your BVN helps us verify that transactions are carried out by a real person which is you",
                                    style: TextStyle(
                                        color: Color(0xff755AE2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xff755AE2)),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("How to get your BVN? (Dial *565*0)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff755AE2))),
                                SizedBox(height: 8),
                                Text(
                                    "Using the Phone number Linked to BVN , dial *565*0# to get your BVN",
                                    style: TextStyle(
                                        color: Color(0xff755AE2),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ))
            ])),
      ),
    );
  }
}

class ProjectTextField extends StatelessWidget {
  const ProjectTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text("BVN"),
        ),
        const SizedBox(
          height: 4,
        ),
        TextField(
          decoration: InputDecoration(
            hintText: "Enter BVN Here...",
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            filled: true,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 0, color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
