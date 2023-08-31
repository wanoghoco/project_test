import 'package:raven_verification/app_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:project_test/barcode_reader/barcode_scanner.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff755AE2).withOpacity(0.2),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffEDE8FB)),
                  color: const Color(0xffFAFAFF),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            VerificationPlugin.startPlugin(
                                context,
                                VerificationPlugin.getInstance(
                                    clientNumber: "",
                                    baseColor: const Color(0xFF0B8376),
                                    initToken: "imiZ5J6HTZZi2jUoookqvEP30CKVR0",
                                    metaDataGetterUrl:
                                        "https://2824-156-0-250-54.ngrok-free.app/user/initiate_bvn_verification2",
                                    bearer:
                                        "RVPUB-ac560d8e0ec5b83225e3c3f8ce6f1d316f00b8c4f98db3458358b2c64b29-1655335692169",
                                    failiure: (data) {},
                                    success: (data) {}));
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.verified,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("BVN Ver",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            VerificationPlugin.startPlugin(
                                context,
                                VerificationPlugin.getInstance(
                                    type: VerificationType.ninstandalone,
                                    baseColor: const Color(0xFF0B8376),
                                    bearer:
                                        "RVPUB-ac560d8e0ec5b83225e3c3f8ce6f1d316f00b8c4f98db3458358b2c64b29-1655335692169",
                                    failiure: (data) {},
                                    success: (data) {}));
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.document_scanner,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("NIN",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            VerificationPlugin.startPlugin(
                                context,
                                VerificationPlugin.getInstance(
                                    type: VerificationType.ninverification,
                                    baseColor: const Color(0xFF0B8376),
                                    bearer:
                                        "RVPUB-ac560d8e0ec5b83225e3c3f8ce6f1d316f00b8c4f98db3458358b2c64b29-1655335692169",
                                    failiure: (data) {},
                                    success: (data) {}));
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.document_scanner,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("NIN",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            VerificationPlugin.startPlugin(
                                context,
                                VerificationPlugin.getInstance(
                                    type: VerificationType.docVerification,
                                    baseColor: const Color(0xFF0B8376),
                                    bearer:
                                        "RVPUB-ac560d8e0ec5b83225e3c3f8ce6f1d316f00b8c4f98db3458358b2c64b29-1655335692169",
                                    failiure: (data) {},
                                    success: (data) {}));
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.document_scanner,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("Doc Ver",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            String barcodeScanRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#FF0F00", "close", true, ScanMode.BARCODE);
                            print(barcodeScanRes);
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.barcode_reader,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("Reader 1",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BarCodeScanner()));
                          },
                          child: const Column(
                            children: [
                              Icon(Icons.barcode_reader,
                                  color: Color(0xff755AE2), size: 24),
                              SizedBox(height: 8),
                              Text("Reader 2",
                                  style: TextStyle(
                                      color: Color(0xff755AE2),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ))
        ]),
      )),
    );
  }
}
