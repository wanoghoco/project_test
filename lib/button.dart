import 'package:flutter/material.dart';

class PackageButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  const PackageButton(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xff755AE2))),
          child: Text(buttonText),
        ));
  }
}
