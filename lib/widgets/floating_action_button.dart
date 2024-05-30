import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final IconData icon;

  const FloatingActionButtonWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor = themeProvider.isDarkMode ? const Color(0xFF212121) : Colors.white;

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Icon(icon),
    );
  }
}
