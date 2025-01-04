import 'package:flutter/material.dart';

class bottomnavigation extends StatelessWidget {
  const bottomnavigation({
    super.key,
    this.ontap,
    this.icon,
  });

  final void Function()? ontap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: SizedBox(
        height: 36,
        width: 36,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}