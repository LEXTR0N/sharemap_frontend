import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final IconData icon;

  const FloatingActionButtonWidget({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Icon(icon),
    );
  }
}
