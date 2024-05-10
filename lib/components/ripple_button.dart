import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  const RippleButton({super.key, required this.onTap}) ;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
      ),
    );
  }
}
