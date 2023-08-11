import 'package:bvn_selfie/main_intro.dart';
import 'package:flutter/material.dart';

class BVNPlugin {
  final String clientBVN;
  final Function onSucess;
  final String bearerToken;
  final Function onFailure;
  static BVNPlugin? _instance;

  BVNPlugin._(
      {required this.clientBVN,
      required this.onFailure,
      required this.bearerToken,
      required this.onSucess});

  static BVNPlugin getInstance(
          {required String bearer,
          required String clientBvn,
          required Function success,
          required Function failiure}) =>
      BVNPlugin._(
          onFailure: failiure,
          onSucess: success,
          clientBVN: clientBvn,
          bearerToken: bearer);

  static Future<void> startPlugin(
      BuildContext context, BVNPlugin bvnInstance) async {
    _instance = bvnInstance;
    await Navigator.push(
      context,
      PageRouteBuilder(
        settings: const RouteSettings(name: "bvn_service"),
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => const MainIntro(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );

    return;
  }

  static String getBVN() {
    return _instance!.clientBVN;
  }

  static String getBearer() {
    return _instance!.bearerToken;
  }

  static Future<void> closePlugin(BuildContext context, bool success,
      {dynamic payload}) async {
    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.isFirst);
    if (success) {
      _instance!.onSucess(payload);
      return;
    }
    _instance!.onFailure(payload);
  }
}
