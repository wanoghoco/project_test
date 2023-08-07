import 'package:bvn_selfie/back_button.dart';
import 'package:bvn_selfie/bvn_selfie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BvnSelfieView extends StatefulWidget {
  final Function(String) onImageCapture;
  final Function(String) onError;
  final Function(BvnServiceProvider) onInit;
  final bool allowTakePhoto;

  const BvnSelfieView(
      {super.key,
      required this.onImageCapture,
      required this.onError,
      required this.allowTakePhoto,
      required this.onInit});

  @override
  State<BvnSelfieView> createState() => _BvnSelfieViewState();
}

class _BvnSelfieViewState extends State<BvnSelfieView>
    with SingleTickerProviderStateMixin {
  bool enabled = false;
  late AnimationController _animationController;
  String? actionText;
  late BvnServiceProvider instance;

  Color surfaceColor = Colors.red;
  int? textureId;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        enabled = true;
        if (mounted) {
          setState(() {});
        }
      }
    });
    instance = BvnServiceProvider(
        controller: BvnServiceProviderController(
      onTextureCreated: (textureID) {
        textureId = textureID;
        if (mounted) {
          setState(() {});
        }
      },
      gesturetEvent: (DetectionType type) {
        if (type == DetectionType.NoFaceDetected) {
          surfaceColor = Colors.red;
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (type == DetectionType.FaceDetected) {
          surfaceColor = const Color(0xff755AE2);
          if (mounted) {
            setState(() {});
          }
          return;
        }
      },
      actionRecongnition: (RecongnitionType recongnitionType) {
        if (recongnitionType == RecongnitionType.SMILE_AND_BLINK) {
          actionText = "SMILE AND BLINK";
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (recongnitionType == RecongnitionType.FROWN_ONLY) {
          actionText = "FROWN FACE";
          setState(() {});
          return;
        }
        if (recongnitionType == RecongnitionType.CLOSE_AND_OPEN_SLOWLY) {
          actionText = "CLOSE AND OPEN EYE SLOWLY";
          if (mounted) {
            setState(() {});
          }
          return;
        }
        if (recongnitionType == RecongnitionType.HEAD_ROTATE) {
          actionText = "ROTATE HEAD";
          setState(() {});
          return;
        }
        if (recongnitionType == RecongnitionType.SMILE_AND_OPEN_ONLY) {
          if (mounted) {
            actionText = "SMILE";
          }
          setState(() {});
        }
      },
      onImageCapture: widget.onImageCapture,
      onError: widget.onError,
      onInit: widget.onInit,
    ));

    instance.startBvnService();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    widget.onInit(instance);
    super.initState();
  }

  String loadAsset(String asset) {
    return "packages/bvn_selfie/asset/$asset";
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    Size size = MediaQuery.of(context).size;
    if (textureId == null && TargetPlatform.android == defaultTargetPlatform) {
      return const SizedBox();
    } else {
      return SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: size.width * 0.76,
              width: size.width * 0.76,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textureId != null ? surfaceColor : Colors.transparent),
            ),
            Container(
              height: size.width * 0.76,
              width: size.width * 0.76,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: textureId != null
                      ? Colors.transparent
                      : Colors.transparent),
            ),
            SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: SizedBox(
                    height: size.width * 0.74,
                    width: size.width * 0.74,
                    child: AspectRatio(
                        aspectRatio: size.width / (size.width * 1.9),
                        child: defaultTargetPlatform == TargetPlatform.android
                            ? Texture(textureId: textureId!)
                            : UiKitView(
                                viewType: "bvnview_cam",
                                creationParams: creationParams,
                                creationParamsCodec:
                                    const StandardMessageCodec(),
                              )),
                  ),
                ),
              ),
            ),
            Positioned(
                top: size.height * 0.02,
                left: 20,
                child: const AppBackButton(textColor: Color(0xffEEEEEE))),
            Positioned(
              top: size.height * 0.1,
              left: 20,
              right: 20,
              child: const Text(
                "Position your phone at eye level and ensure that your face fits within the oval",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffEEEEEE)),
              ),
            ),
            Positioned(
              top: size.height * 0.24,
              child: Text(
                (actionText ?? "PLACE YOUR FACE PROPERLY").toUpperCase(),
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xffEEEEEE),
                    fontWeight: FontWeight.w900),
              ),
            ),
            Image.asset(
              loadAsset("frame_cover.png"),
              color: const Color(0xff755AE2),
              width: size.width * 0.76,
            ),
            if (widget.allowTakePhoto &&
                enabled &&
                TargetPlatform.android == defaultTargetPlatform) ...[
              Positioned(
                  bottom: size.height * 0.1,
                  child: GestureDetector(
                    onTap: () {
                      instance.takePhoto();
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          loadAsset("shutter.png"),
                          height: 54,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("You Can Take Shot Now...",
                            style: TextStyle(
                              color: Color(0xffEEEEEE),
                            ))
                      ],
                    ),
                  )),
            ]
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
